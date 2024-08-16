import sys
import os
import zlib
import base64
import argparse
import subprocess
from datetime import datetime
import shutil

def create_iso(input_dir, output_file, lba, volume_name):
    try:
        subprocess.run(['mkisofs', '-C', f'0,{lba}', '-V', volume_name, '-exclude', 'IP.BIN', '-G', 'IP.BIN', '-l', '-J', '-r', '-o', output_file, input_dir], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error creating ISO: {e}")
        sys.exit(1)

def create_cdi_image(input_file, output_file, lba):
    # ... (existing create_cdi_image function)

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

if __name__ == "__main__":
    # Ensure the input directory exists
    if not os.path.exists(input_dir):
        print(f"Error: '{input_dir}' directory not found. Please check the input directory and try again.")
        input("Press Enter to continue...")
        sys.exit(1)

    # a) Copy IP.TMP to IP.BIN if IP.BIN doesn't exist
    ip_bin_path = os.path.join(input_dir, "IP.BIN")
    ip_tmp_path = os.path.join(input_dir, "IP.TMP")
    if not os.path.exists(ip_bin_path):
        shutil.copy(ip_tmp_path, ip_bin_path)
    else:
        print("IP.BIN already exists in the input directory. Skipping copy.")

    # b) Copy 1ST_READ.BIN to the input directory
    first_read_bin_path = os.path.join(input_dir, "1ST_READ.BIN")
    if not os.path.exists(first_read_bin_path):
        shutil.copy(os.path.join(input_dir, "1ST_READ.BIN"), first_read_bin_path)

    # c) Use hack4.exe and binhack.exe to patch the binaries
    hack4_exe = "hack4.exe"
    binhack_exe = "binhack.exe"

    try:
        # Run hack4.exe on the files in the input_dir
        subprocess.run([hack4_exe, "-w", "-p"] + [os.path.join(input_dir, "*.bin")], check=True)
        subprocess.run([hack4_exe, "-w", "-n", str(lba)] + [os.path.join(input_dir, "*.bin")], check=True)

        # Copy the patched files back to the input_dir
        shutil.copy(os.path.join(input_dir, "IP.BIN"), os.getcwd())
        shutil.copy(os.path.join(input_dir, "1ST_READ.BIN"), os.getcwd())

        # Run binhack.exe with the binhack.cfg file
        binhack_cfg = os.path.join(os.getcwd(), "binhack.cfg")
        subprocess.run([binhack_exe], stdin=open(binhack_cfg, "r"), check=True)

        # Copy the patched files back to the input_dir
        shutil.copy(os.path.join(os.getcwd(), "IP.BIN"), input_dir)
        shutil.copy(os.path.join(os.getcwd(), "1ST_READ.BIN"), input_dir)

    except FileNotFoundError:
        print("Error: 'hack4.exe' or 'binhack.exe' not found. Skipping patching.")
    except Exception as e:
        print(f"Error: {e}")

    # Create the ISO file
    create_iso(input_dir, "test.iso", lba, volume_name)

    # Then create the CDI image
    create_cdi_image("test.iso", output_file, lba)

    # Clean up the temporary ISO file
    os.remove("test.iso")