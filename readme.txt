


-----------------------------------------------------------
Lazyboot: the Ultimate Selfboot Toolkit.
-----------------  since 2014 ---------------


Translate, Rebuild, Revive: 
Lazyboot, the Definitive Image Creation Tool for modders and enthusiasts!! The spiritual successor of the famous (in the narrow circles) "Eazyboot" Toolkit.

Lazyboot Toolkit is primarily intended for the homebrew scene (modders) and advanced users who need to translate Dreamcast games into their native languages and frequently test or debug their images. It is not a replacement for GDI Builder or other similar tools.

The default settings of Lazyboot are optimized for speed and compatibility with emulators like Redream. However, you can also use this script to create CDI images for burning to actual CD-Rs by selecting the "mastering" preset.

Not well-known yet robust tool for any Dreamcast enthusiast who want to translate their favorite games!


-----------------------------------------------------------
Mini Readme
-----------------------------------------------------------


Lazyboot is a toolkit with a lot of useful scripts, that can create self-booting images for the Dreamcast console. It offers a wide range of features, which are detailed in the full manual located in the extra_tools folder.


Features:

- It can build a CDI image faster then any other CDI4DC (IMG4DC)-based Toolkit or tool.
- It more robust then any other toolkit since had a ton of errors handling and formats
- A custom alternative for cdi4dc/img4dc with mkisofs integrated (optional)
- It can be small and portable (use mkcdi.exe or .\extra_tools\lzlite)
- It supports command-line arguments (-i, --help, -o, etc) and drag'n'drop. See changelog.txt
- It creates a dummy file for you based on the free size
- It can unpack CDI (drag'n'drop CDI to lazyboot.exe)
- It can build a GDI from data, if you provide an original IP.BIN (not very valid, tho)
- You can build a media CD with it and encode your video files (like mp4 h264) to supported format.
- It can build a lot of emulators and create a romlist for it (fast loading)
- CDI, ISO, MDF+MDS, SBI, GDI support
- Easy to integrate to any other tool or use with a specific game.
- etc, etc, etc. 


-----------------------------------------------------------
System Requirements
-----------------------------------------------------------


Lazyboot version 4 and newer do not support Windows XP. Instead, you will need to use Windows 7 x86 (with the latest updates) or Windows 10. While it may also work on Windows 11 and Wine, this has not been officially tested.

Linux users can try mkcdi.py from "extra_tools" directory (req. Python 3.12 and compatible version of mkisofs)


-----------------------------------------------------------
How to Use
-----------------------------------------------------------


Copy the files from the GDI (using GDI Explorer to extract) into the data folder.
Run lazyboot.cmd (or lazyboot.exe if you prefer).
Select the desired image format. If you're unsure, choose the first option and press Enter a few times.

You can also drag and drop a CDI file onto lazyboot.cmd to unpack all the data to the ./data folder.


-----------------------------------------------------------
FAQ
-----------------------------------------------------------


Q: My image is not booting.

A: Try to delete the IP.BIN file from the data folder to use a generic one, or vice versa: use GDI Explorer to extract the original IP.BIN from image and use that instead. You can also use the "IP.BIN 4 Win.exe" tool to modify the parameters.


-----------------------------------------------------------
Notes
-----------------------------------------------------------


For homebrew (KOS) games, you need to disable binhack manually.

To build a GDI, you need to provide an original IP.BIN and 1ST_READ.BIN (or patch an unoriginal 1ST_READ.BIN to LBA45000 using BinPATCH.exe).
Lazyboot can create images with emulators or video. Copy ROMs or MP4 videos to the roms folder.
	
Currently GDI is not well supported in this script, use GDI Builder instead, since it supports CDDA etc. Lazyboot use older version of GDI Builder for compatibility reason with older hardware.
	
Also there is not reason to build GDI for testing purposes anymore, since mkcdi (the python script) creates CDI much faster and smaller, and LBA 45000 supported


-----------------------------------------------------------
Authors & Copyrights
-----------------------------------------------------------


Built upon the work of many open-source contributors.

	
Use at your own risk.


Lazyboot is open-source, so you're free to modify the code as needed. However, please be mindful of any applicable copyrights and licenses when making changes.


Tools that are used:

"mkisofs" and "mkcdi" (based on python script from psxplanet).

"hack4" and "binhack" clone are important if the user want the LBA 11702 or whatever.

"cdi4dc" can be used to create a reliable CDI with ECC, "mds4dc" for mds+mdf with CDDA audio.

"gdibuilder" is used as a GDI creator.

"Iso7z"+ 7-Zip 22.01 ZS used as a CDI unpacker.

"sfk" and "busybox" are used for convenience. 

"logoinsert", "lbacalc", "isofix", "IP.BIN 4 Win", "BinPATCH" and other tools and custom fixes.
