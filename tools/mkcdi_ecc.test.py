#!/usr/bin/env python3

import sys
import os
import zlib
import base64
import argparse
import crcmod
import struct

def generate_ecc(data, sector_size=2048, ecc_size=288):
    """
    Generate ECC (Error-Correction Code) for the given data.
    
    Args:
        data (bytes): The input data to generate ECC for.
        sector_size (int): The size of each sector (default: 2048 bytes).
        ecc_size (int): The size of the ECC data (default: 288 bytes).
    
    Returns:
        bytes: The generated ECC data.
    """
    ecc_data = bytearray(ecc_size)
    
    # Define the CRC-16 CCITT polynomial
    crc16_ccitt = crcmod.mkCrcFun(0x11021, initCrc=0xFFFF, xorOut=0x0000, rev=False)
    
    for i in range(0, len(data), sector_size):
        sector = data[i:i+sector_size]
        crc = crc16_ccitt(sector)
        ecc_data[i//sector_size*4:(i//sector_size+1)*4] = struct.pack('<H', crc)
    
    return bytes(ecc_data)

def create_cdi_image(input_file, output_file, data_mode, lba):
    try:
        with open(input_file, 'rb') as f:
            f.seek(0, 2)
            file_size = f.tell()
            sector_count = int(file_size / 2048)
            f.seek(0)

            print(f"Processing file: {input_file}")

            with open(output_file, 'wb') as g:
                g.write(bytes(1063104))
                temp = zlib.decompress(base64.b64decode(tdi))
                g.write(temp)

                for i in range(0, sector_count, 1):
                    temp = f.read(0x800)
                    ecc_data = generate_ecc(temp)
                    if data_mode:
                        g.write(b'\x00' * 8)
                    else:
                        g.write(ecc_data)
                    g.write(temp)
                    g.write(b'\x00' * 280)

                temp = zlib.decompress(base64.b64decode(end))
                g.write(temp)

                if not data_mode:
                    g.seek(-158, 2)
                    g.write(lba.to_bytes(4, 'little'))
                    g.seek(-277, 2)
                    g.write((sector_count + 152).to_bytes(4, 'little'))
                    g.seek(-310, 2)
                    g.write(lba.to_bytes(4, 'little'))
                    g.write((sector_count + 152).to_bytes(4, 'little'))
                    g.seek(-336, 2)
                    g.write((sector_count + 2).to_bytes(4, 'little'))

        print(f"CDI image created: {output_file}")
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.")
    except Exception as e:
        print(f"Error: {e}")

tdi=b'''
eJzt1r+Lz3EcwPHPfWNCKVlMfpQVu8JlMZDBDWeSK4tYXSndopTx/gOD4QxkuY1FGVwd62
WwMon79rV9lSvdMyw3MHg86j283r179R6fw3B4GH4cAADOHHj2YtBHAAA/6SMAgNJHAACl
jwAASh8BAJQ+AgAofQQAUPoIAKD0EQBA6SMAgNJHAACljwAASh8BAJQ+AgAofQQAUPoIAK
D0EQBA6SMAgNJHAACljwAASh8BAJQ+AgAofQQAUPoIAKD0EQBA6SMAgNJHAACljwAASh8B
AJQ+AgAofQQAUPoIAKD0EQBA6SMAgNJHAACljwAASh8BAJQ+AgAofQQAUPoIAKD0EQBA6S
MAgNJHAACljwAASh8BAJQ+AgAofQQAUPoIAKD0EQBA6SMAgNJHAACljwAASh8BAJQ+AgAo
fQQAUPoIAKD0EQBA6SMAgNJHAACljwAASh8BAJQ+AgAofQQAUPoIAKD0EQBA6SMAgNJHAA
CljwAASh8BAJQ+AgAofQQAUPoIAKD0EQBA6SMAgNrqoy1Xzl+YuTwzGo2WptPpv/wUAPDX
LF4/cmv7vLx4f3xtPJlM9qysrOx464PHC6vb59en1zZPbo7H44dzc3M73vr51exGbxZW30
7mj3+6MQzvhq8HL46/nbp34ubauaUPX46d/dOW2Y03R5evHno0DHeHvS/3P9n9/OPT9+uX
9t1ev7Pr19f6CAD+P/pIHwEApY/0EQBQ+kgfAQClj/QRAFD6SB8BAKWP9BEAUPpIHwEApY/
0EQBQ+kgfAQClj/QRAFD6SB8BAKWP9BEAUPpIHwEApY/0EQBQ+kgfAQClj/QRAFD6SB8BAK
WP9BEAUPpIHwEApY/0EQBQ+kgfAQClj/QRAFD6SB8BAKWP9BEAUPpIHwEApY/0EQBQ+kgfA
QClj/QRAFD6SB8BAKWP9BEAUPpIHwEApY/0EQBQ+kgfAQClj/QRAFD6SB8BAKWP9BEAUPpI
HwEApY/0EQBQ+kgfAQClj/QRAFD6SB8BAKWP9BEAUPpIHwEApY/0EQBQ+kgfAQClj/QRAFD
6SB8BAKWP9BEAUPpIHwEApY/0EQBQ+kgfAQClj/QRAFD6SB8BAKWP9BEAUPpIHwEApY/0EQ
BQ+kgfAQClj/QRAFD6SB8BAKWP9BEAUPpIHwEApY/0EQBQ+kgfAQClj/QRAFD6SB8BAKWP9
BEAUPpIHwEApY/0EQBQ+kgfAQClj/QRAFD6SB8BAKWP9BEAUPpIHwEApY9+30ffATBSXmU='''

end=b'''
eJxjYFBgYADjUTAKRsEoGAWjYBSMglFgL7xhH8No+2gUjIJRMApGwSgYBaMADkDtIyYGRigP
RP8HAgRrNYMAEwcWfUwIZoNDHSuQmgEUmwak9RixKIeDI1hkmfBJgsF/KADJN0B1CACxyxp8
dmEzBackNYMghA1dDcz0E+sZGF6xMWAAkDwLiIFNEu546gcBzH0gd6E4hvwgWGACbGsTAmCT
8SYUEACGRcNCoB0AWgtNAw=='''

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create CDI image from an ISO file.")
    parser.add_argument("input_file", help="Input ISO file")
    parser.add_argument("output_file", help="Output CDI file")
    parser.add_argument("-d", "--data_mode", action="store_true", help="Generates a Data/Data image from a MSINFO 0 ISO")
    parser.add_argument("-l", "--lba", type=int, default=11702, help="LBA parameter (default: 11702)")

    args = parser.parse_args()

    input_file = args.input_file
    output_file = args.output_file
    data_mode = args.data_mode
    lba = args.lba

    create_cdi_image(input_file, output_file, data_mode, lba)