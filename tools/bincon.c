/****************************************************************
  0WINCEOS.BIN -> 1ST_READ.BIN Converter v2
  
  usage: bincon <0WINCEOS.BIN file> <new 1ST_READ.BIN to create>
  example: bincon 0WINCEOS.BIN 1ST_READ.BIN

  It does what it says it does. I gave the option of 
  naming the file names just incase someone didn't want
  them to have the exact names. 

  Works on: Midway Aracde Classics - 100%
	          Sega Rally 2 - 100%
            Rearview Mirror WinCE Dev Kit Demo - 100%

  Source released under the GNU General Public License:
  http://www.fsf.org/copyleft/gpl.html

  by dopefish on 7/28/00
	basic binary check by Shoometsu 1/26/08
  bincon.c
*****************************************************************/
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	char *binary;
	char *bootsector;
	char *bytech;
	char *chunk1;
	char *chunk2;

	FILE *binary_in, *binary_out;
	FILE *bootsector_in, *bootsector_out;

	long lsize;
	
	/* Argument check */
	if (argc != 4) {
		fprintf(stderr, "\nUsage: bincon <0WINCEOS.BIN file> <new 1ST_READ.BIN to create> <IP.BIN filename>\n");
		fprintf(stderr, "Example: bincon 0WINCEOS.BIN 1ST_READ.BIN IP.BIN\n");
		return 0;
	}

	/* Open 0winceos.bin + error check*/
	binary_in = fopen(argv[1], "rb");
	if (binary_in == NULL) {
		fprintf(stderr, "Error: cannot open %s.\n", argv[1]);
		return 0;
	}

	/* Open ip.bin + error check*/
	bootsector_in = fopen(argv[3], "rb");
	if (bootsector_in == NULL) {
		fprintf(stderr, "Error: cannot open %s.\n", argv[3]);
		return 0;
	}

	/* Get size of 0winceos.bin */
	fseek(binary_in, 0, SEEK_END);
	lsize = ftell(binary_in);
	rewind(binary_in);

	/* Malloc + error check */
	binary = (char *) malloc(lsize);
	bootsector = (char *) malloc(0x8000);
	bytech = (char *) malloc(0x1);
	chunk1 = (char *) malloc(0x800);
	chunk2 = (char *) malloc(0x800);

	if ((binary || chunk1 || chunk2) == NULL) {
		fprintf(stderr, "Not enough free memory or memory allocation error.\n");
		return 0;
	}

	/* Try to do a very basic check for a file already converted */
	fseek(binary_in, lsize-0x1000, SEEK_SET);
	fread(chunk1, 1, 0x800, binary_in);
	fseek(binary_in, lsize-0x800, SEEK_SET);
	fread(chunk2, 1, 0x800, binary_in);
	if (*chunk1!=*chunk2){

		/* Seems that the file wasn't (bincon)verted yet. So let's do it... */

			/* Move ptr to point we want to start at, read to mem, close 0winceos.bin */
			fseek(binary_in, 0x800, SEEK_SET);
			fread(binary, 1, lsize, binary_in);
			fclose(binary_in);

			/* Move ptr to point we want to start at, read to mem, close ip.bin */
			fread(bootsector, 1, 0x8000, bootsector_in);
			fclose(bootsector_in);

			/* Create file to write to w/ error check */
			binary_out = fopen(argv[2], "wb");
			if (binary_out == NULL) {
				fprintf(stderr, "Error: cannot create %s.\n", argv[2]);
				return 0;
			}

			/* Create file to write to w/ error check */
			bootsector_out = fopen(argv[3], "wb");
			if (bootsector_out == NULL) {
				fprintf(stderr, "Error: cannot create %s.\n", argv[3]);
				return 0;
			}

			/* Write full binary to file then the last 2k again */
			fwrite(binary, 1, lsize-0x800, binary_out);
			fwrite(binary + (lsize - 0x1000), 1, 0x800, binary_out);

			/* Write full bootsector to file */
			(*bytech) = 0x30;
			fwrite(bootsector, 1, 0x3E, bootsector_out);
			fwrite(bytech,	1, 1, bootsector_out);
			fwrite(bootsector+0x3F,	1, 0x7FC1, bootsector_out);
		
			/* Free memory, close up the last file */
  		free(binary);
			free(bootsector);
			fclose(binary_out);
			fclose(bootsector_out);

	}
	
//	else{

		/* The binary seems to be already (bincon)verted */
//			fprintf(stderr,"\n   The file %s seems to be already (bincon)verted. Nothing to do.\n",argv[1]);

//	}

	free(chunk1);
	free(chunk2);

	return 0;
}
