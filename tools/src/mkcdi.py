#!/usr/bin/env python3

import sys
import os
import zlib
import base64
import argparse
import subprocess
from datetime import datetime

def create_iso(input_dir, output_file, lba, volume_name):
    subprocess.run(['mkisofs', '-C', f'0,{lba}', '-V', volume_name, 
                    '-exclude', 'IP.BIN', '-exclude', '0.0', 
                    '-G', 'data/IP.BIN', '-l', '-J', '-r', 
                    '-o', output_file, input_dir], check=True)

def create_cdi_image(input_file, output_file, lba):
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
                    g.write(b'\x00' * 8)
                    g.write(temp)
                    g.write(b'\x00' * 280)

                temp = zlib.decompress(base64.b64decode(end))
                g.write(temp)

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
        print(f"Error: Input file or directory '{input_file}' not found.")
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
    parser.add_argument("-i", "--input", default="data", help="Input directory (default: 'data')")
    parser.add_argument("-l", "--lba", type=int, default=45000, help="LBA parameter (default: 45000)")
    parser.add_argument("-V", "--volume-name", default="dcgame", help="Volume name for the ISO image (default: 'dcgame')")
    parser.add_argument("-o", "--output", help="Output CDI file (default: <volume_name>-<current_datetime>.cdi)")

    args = parser.parse_args()

    input_dir = args.input
    lba = args.lba
    volume_name = args.volume_name

    # Get the current date and time
    current_datetime = datetime.now().strftime("%Y%m%d-%H%M%S")

    # Construct the output file name if not provided
    if args.output:
        output_file = args.output
    else:
        output_file = f"{volume_name}-{current_datetime}.cdi"

    # Ensure the input directory exists
    if not os.path.exists(input_dir):
        print(f"Error: '{input_dir}' directory not found. Please check the input directory and try again.")
        input("Press Enter to continue...")
        sys.exit(1)

    # Create the ISO file first
    create_iso(input_dir, "test.iso", lba, volume_name)

    # Then create the CDI image
    create_cdi_image("test.iso", output_file, lba)

    # Clean up the temporary ISO file
    os.remove("test.iso")