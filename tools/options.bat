	:PRINT_TITLE
    cls
    @echo off
    set LAZYVERSION=v5.5
    mode con: lines=30
    if exist binhack.exe cd ..
    if not exist tools\binhack.exe echo ERROR^:system files not found in tools^\ folder&echo.&pause

    setlocal enabledelayedexpansion

    if not exist tools\cfg\settings.ini copy /Y tools\settings.def tools\cfg\settings.ini >nul
    :NEXT
    set /a c=0
    for /f "UseBackQ delims=" %%A in ("tools\cfg\settings.ini") do (
        set /a c+=1
        if !c!==1 set "automatic=%%A"
        if !c!==2 set "sortfile=%%A"
        if !c!==3 set "logo=%%A"
        if !c!==4 set "alert=%%A"
        if !c!==5 set "imagename=%%A"
        if !c!==6 set "tool=%%A"
        if !c!==7 set "mainbinary=%%A"
        if !c!==8 set "scramble=%%A"
        if !c!==9 set "binhack=%%A"
        if !c!==10 set "datalabel=%%A"
        if !c!==11 set "lbavalue=%%A"
        if !c!==12 set "cdda=%%A"
        if !c!==13 set "dcsystem=%%A"
        if !c!==14 set "namelist=%%A"
        if !c!==15 set "inducer=%%A"
        if !c!==16 set "isonamechk=%%A"
        if !c!==17 set "doomer=%%A"
        if !c!==18 set "soundbank=%%A"
    )

    tools\SFK color white

    tools\SFK echo [cyan]++++++++++++++++++++++++++++++[def]   [red]LAZYBOOT[def] [yellow]%LAZYVERSION%[def]   [cyan]++++++++++++++++++++++++++++++++++[def] 
    tools\SFK echo [cyan]+++++++++++++++++++++++++++++++++[def]   [green]OPTIONS[def]   [cyan]+++++++++++++++++++++++++++++++++++++[def] 
    tools\SFK echo [cyan]_______________________________________________________________________________[def]
    echo.

    :SETTINGS
    set SETTINGS=null

    tools\SFK echo [cyan]Your can change settings here[def]
    echo.

    tools\SFK echo [magenta]1[def] - LOGO [cyan](change logo)[def]
    tools\SFK echo [magenta]2[def] - DUMMY [cyan]^(80min standard^)[def]
    tools\SFK echo [magenta]3[def] - IMAGE NAME
    tools\SFK echo [magenta]4[def] - BINHACK
    tools\SFK echo [magenta]5[def] - ALERT SOUND [cyan][def]
    tools\SFK echo [magenta]6[def] - AUTOMATIC MODE [cyan](turn off image creation wizard) [def]
    tools\SFK echo [magenta]7[def] - CORRECTION CODE [cyan](turn off ECC) [def]
    tools\SFK echo [magenta]8[def] - [white]DEFAULT[def] [cyan](reset all settings)[def]
    tools\SFK echo [magenta]9[def] - [cyan]EXIT (press enter)[def]

    echo.
    IF %logo%==logo_on (
        tools\SFK echo  LOGO IS [green]ON[def]
    ) ELSE IF %logo%==logo_off (
        tools\SFK echo  LOGO IS [red]OFF[def]
    ) 

    IF %doomer%==dummy_on (
        tools\SFK echo  DUMMY IS [green]ON[def] ^(slower^)
    ) ELSE IF %logo%==logo_off (
        tools\SFK echo  DUMMY IS [red]OFF[def] ^(faster^)
    ) 

    tools\SFK echo IMAGE NAME IS [green]%imagename%[def]

    IF %BINHACK%==binhack_on (
        tools\SFK echo  BINHACK AND HACK4 IS [green]ON[def]
    ) ELSE IF %BINHACK%==binhack_off (
        tools\SFK echo BINHACK AND HACK4 IS [red]OFF[def]
    ) 

    IF %tool%==cdi4dc (
        tools\SFK echo  CORRECTION CODE IS [green]ON[def] ^(slower^)
    ) ELSE IF %tool%==mkcdi (
        tools\SFK echo CORRECTION CODE IS [RED]OFF[def] ^(faster^)
    ) 

    tools\SFK echo SORTFILE SET AS [green]%sortfile%[def]

    IF %dcsystem%==kos (
        tools\SFK echo  OPTIMIZED FOR [red]KALLISTI[def]
    ) ELSE IF %dcsystem%==wince (
        tools\SFK echo OPTIMIZED FOR [red]WINDOWS CE[def]
    ) ELSE IF %dcsystem%==katana (
        tools\SFK echo OPTIMIZED FOR [red]KATANA[def]
    ) ELSE (
        tools\SFK echo OPTIMIZED FOR [green]DEFAULT[def]
    )

    echo.
    tools\SFK echo [cyan]Please enter the number:[def]
    tools\SFK echo -spat ^(you can type [cyan]katana[def], [cyan]kos[def], [cyan]wince[def], [cyan]mastering[def] or [cyan]fast[def] to switch profiles^)

    set ST_TYPE=9
    set /P ST_TYPE=   
    if %ST_TYPE%==1 goto LOGO_SELECTOR
    if %ST_TYPE%==2 goto DOOMER
    if %ST_TYPE%==3 goto IMAGENAME
    if %ST_TYPE%==4 goto BINHACK
    if %ST_TYPE%==5 goto ALERT
    if %ST_TYPE%==6 goto automatic
    if %ST_TYPE%==7 goto tool
    if %ST_TYPE%==8 goto DEFAULT
    if %ST_TYPE%==9 goto CALL_LAZYBOOT
    if %ST_TYPE%==exit exit
    if %ST_TYPE%==quit exit

    :: bonus features section
    if %ST_TYPE%==kos tools\sfk replace -quiet tools\cfg\settings.ini /default/kos/ /wince/kos/ /katana/kos/ /binhack_on/binhack_off/ -yes&set binhack=binhack_on&goto BINHACK
    if %ST_TYPE%==wince tools\sfk replace -quiet tools\cfg\settings.ini /default/wince/ /kos/wince/ /katana/wince/ /binhack_off/binhack_on/ -yes&set binhack=binhack_on&goto BINHACK
    if %ST_TYPE%==katana tools\sfk replace -quiet tools\cfg\settings.ini /default/katana/ /wince/katana/ /kos/katana/  /binhack_off/binhack_on/ -yes&set binhack=binhack_off&goto BINHACK
    if %ST_TYPE%==default copy /Y tools\settings.def tools\cfg\settings.ini >nul&copy /Y tools\logos\not_sega.mr tools\logo.mr >nul&goto DEFAULT
    if %ST_TYPE%==nologo tools\SFK replace -quiet tools\cfg\settings.ini "/logo_on/logo_off/" -yes&del /f /q tools\logo.mr&goto LOGO_SELECTOR
    if %ST_TYPE%==logo tools\SFK replace -quiet tools\cfg\settings.ini "/logo_off/logo_on/" -yes&copy /Y tools\logos\not_sega.mr tools\logo.mr >nul&goto LOGO_SELECTOR
    if %ST_TYPE%==nobinhack tools\SFK replace -quiet tools\cfg\settings.ini "/binhack_on/binhack_off/" -yes&goto BINHACK
    if %ST_TYPE%==binhack tools\SFK replace -quiet tools\cfg\settings.ini "/binhack_off/binhack_on/" -yes&goto BINHACK

    if "%ST_TYPE%"=="slower" set ST_TYPE=mastering
    if "%ST_TYPE%"=="slow" set ST_TYPE=mastering
    if "%ST_TYPE%"=="mastering" (
        tools\sfk replace -quiet tools\cfg\settings.ini /default/katana/ /wince/katana/ /kos/katana/ /binhack_off/binhack_on/ /mkcdi/cdi4dc/ /dummy_off/dummy_on/ -yes
        set binhack=binhack_off
        goto BINHACK
    )

    if "%ST_TYPE%"=="faster" set ST_TYPE=fast
    if "%ST_TYPE%"=="fast" (
        tools\sfk replace -quiet tools\cfg\settings.ini /default/katana/ /wince/katana/ /kos/katana/ /binhack_off/binhack_on/ /cdi4dc/mkcdi/ /dummy_on/dummy_off/ -yes
        set binhack=binhack_off
        goto BINHACK
    )
    :: features section end

	GOTO PRINT_TITLE
	exit

	:CALL_LAZYBOOT
		start .\tools\Lazyboot.cmd
		exit

	:DEFAULT
		copy /Y tools\logos\not_sega.mr tools\logo.mr >nul
		copy /Y tools\settings.def tools\cfg\settings.ini >nul
		tools\sfk echo [cyan]OK, default settings restored[def]
		pause
		goto PRINT_TITLE

	:BINHACK
		if %binhack%==binhack_on tools\SFK replace -quiet tools\cfg\settings.ini "/binhack_on/binhack_off/" -yes &goto EXIT_BINHACK

		if %binhack%==binhack_off tools\SFK replace -quiet tools\cfg\settings.ini "/binhack_off/binhack_on/" -yes
		tools\SFK echo [cyan]HACK4 and BINHACK is[def] [green]ON[def]
		pause
		goto PRINT_TITLE

	:EXIT_BINHACK
		tools\sfk echo [cyan]HACK4 and BINHACK is[def] [red]OFF[def]
		pause
		goto PRINT_TITLE

	:automatic
		if %automatic%==automatic_on tools\SFK replace -quiet tools\cfg\settings.ini "/automatic_on/automatic_off/" -yes &goto EXIT_automatic

		if %automatic%==automatic_off tools\SFK replace -quiet tools\cfg\settings.ini "/automatic_off/automatic_on/" -yes
		tools\SFK echo [cyan]AUTOMATIC MODE[def] [green]ON[def]
		pause
		goto PRINT_TITLE

	:EXIT_automatic
		tools\sfk echo [cyan]AUTOMATIC MODE[def] [red]OFF[def]
		pause
		goto PRINT_TITLE

	:tool
		if %tool%==cdi4dc tools\SFK replace -quiet tools\cfg\settings.ini "/cdi4dc/mkcdi/" -yes &goto EXIT_tool

		if %tool%==mkcdi tools\SFK replace -quiet tools\cfg\settings.ini "/mkcdi/cdi4dc/" -yes
		tools\SFK echo [cyan]CORRECTION CODE[def] [green]ON[def] (cdi4dc.exe will be used)
		pause
		goto PRINT_TITLE

	:EXIT_tool
		tools\sfk echo [cyan]CORRECTION CODE[def] [red]OFF[def] (mkcdi.exe will be used)
		pause
		goto PRINT_TITLE

	:LOGO_SELECTOR
		call :LAZ_TITLE

		tools\SFK echo [magenta]1 - Disable logo[def] and delete logo.mr file
		tools\SFK echo [cyan]2 - "Windows 45[def] fake logo
		tools\SFK echo [blue]3 - "Not licenced by SEGA[def]" from sturmwind
		tools\SFK echo [yellow]4 - "YARR![def]" pirate logo
		tools\SFK echo [red]5 - "Not for sale![def]" logo

		echo.
		tools\SFK echo    [cyan]Please enter the number:[def]
		set LOGO_TYPE=1

		set /P LOGO_TYPE=   

		if %LOGO_TYPE%==1 goto NOLOGO
		if %LOGO_TYPE%==2 copy tools\logos\win_45.mr tools\logo.mr /Y >nul&echo.&tools\SFK echo -spat [cyan]Done\x21[def]&pause
		if %LOGO_TYPE%==3 copy tools\logos\not_sega.mr tools\logo.mr /Y >nul&echo.&tools\SFK echo -spat [cyan]Done\x21[def]&pause
		if %LOGO_TYPE%==4 copy tools\logos\yarr.mr tools\logo.mr /Y&echo. >nul&tools\SFK echo -spat [cyan]Done\x21[def]&pause
		if %LOGO_TYPE%==5 copy tools\logos\not4sale.mr tools\logo.mr /Y >nul&echo.&tools\SFK echo -spat Done\x21&pause

		if %logo%==logo_off tools\SFK replace -quiet tools\cfg\settings.ini "/logo_off/logo_on/" -yes 
		goto PRINT_TITLE

	:ALERT
		call :LAZ_TITLE
		if %alert%==alert_on tools\SFK replace -quiet tools\cfg\settings.ini "/alert_off/alert_on/" -yes 
		rem tools\SFK echo -spat [magenta]1[def] - \x20disable
		tools\SFK echo -spat [magenta]1[def] - disable
		tools\SFK echo -spat [magenta]2[def] - classic
		tools\SFK echo -spat [magenta]3[def] - despair
		tools\SFK echo -spat [magenta]4[def] - twisted
		tools\SFK echo -spat [magenta]5[def] - avatar
		tools\SFK echo -spat [magenta]6[def] - custom
		tools\SFK echo [magenta]9[def] - [cyan]EXIT ^([cyan]press enter^)[def]

		echo.

		echo.
		tools\SFK echo    [cyan]Please enter the number:[def]
		set ALRM_SOUND=X

		set /P ALRM_SOUND=   

		if %ALRM_SOUND%==1 tools\SFK replace -quiet tools\cfg\settings.ini "/alert_on/alert_off/" -yes&echo.&tools\SFK echo -spat [cyan]OK,[cyan] [red]DISABLED[def]&set alert=alert_off&pause&goto PRINT_TITLE

		::if %ALRM_SOUND%==2 copy tools\warnings\default tools\warnings\complete /Y >NUL&echo.&tools\warnings\mpg123.exe -o s tools\warnings\complete&echo.&tools\SFK echo -spat [cyan]Done\x21[def] [green]DEFAULT SOUND[cyan] is set[def]&set alert=alert_on&pause&goto ALERT
		
		if %ALRM_SOUND%==2 (
			set "replace=classic"
			call :voicepack
			tools\SFK echo -spat [cyan]Done\x21[def]
			set alert=alert_on
			echo.
			cd .\tools\warnings
			background_play.exe "classic" "01.mp3"
			cd ..&&cd ..
			pause
			goto ALERT
		)

		if %ALRM_SOUND%==3 (
			set "replace=despair"
			call :voicepack
			tools\SFK echo -spat [cyan]Done\x21[def]
			set alert=alert_on
			echo.
			cd .\tools\warnings
			background_play.exe "despair" "there-you-go.mp3"
			cd ..&&cd ..
			pause
			goto ALERT
		)
		
		if %ALRM_SOUND%==4 (
			set "replace=twisted"
			call :voicepack
			tools\SFK echo -spat [cyan]Done\x21[def]
			set alert=alert_on
			echo.
			cd .\tools\warnings
			background_play.exe "twisted" "there-you-go.mp3"
			cd ..&&cd ..
			pause
			goto ALERT
		)
		
		if %ALRM_SOUND%==5 (
			set "replace=avatar"
			call :voicepack
			tools\SFK echo -spat [cyan]Done\x21[def]
			set alert=alert_on
			echo.
			cd .\tools\warnings
			background_play.exe "avatar" "make-your-selection.mp3"
			cd ..&&cd ..
			pause
			goto ALERT
		)
		
		if %ALRM_SOUND%==6 (
			set "replace=custom"
			call :voicepack
			tools\SFK echo -spat [cyan]Done\x21[def]
			set alert=alert_on
			echo.
			cd .\tools\warnings
			background_play.exe "custom" "make-your-selection.mp3"
			cd ..&&cd ..
			pause
			goto ALERT
		)

		if %ALRM_SOUND%==X set ALRM_SOUND=3&&goto PRINT_TITLE
		if %ALRM_SOUND%==9 goto PRINT_TITLE

		pause

		goto PRINT_TITLE

	:NOLOGO
		if %logo%==logo_off echo.&tools\SFK echo -spat Done\x21 Logo is [red]disabled[def]\x21&pause
		if %logo%==logo_on tools\SFK replace -quiet tools\cfg\settings.ini "/logo_on/logo_off/" -yes&echo.&tools\SFK echo -spat Done\x21 Logo is disabled\x21&pause
		del /f /q tools\logo.mr
		goto PRINT_TITLE

	:DOOMER
		if %doomer%==dummy_on tools\SFK replace -quiet tools\cfg\settings.ini "/dummy_on/dummy_off/" -yes &goto EXIT_DOOMER
		if %doomer%==dummy_off tools\SFK replace -quiet tools\cfg\settings.ini "/dummy_off/dummy_on/" -yes
		tools\SFK echo [cyan]DUMMY[def] [green]ON[def]
		pause
		goto PRINT_TITLE

	:EXIT_DOOMER
		tools\sfk echo [cyan]DUMMY[def] [red]OFF[def]
		pause
		goto PRINT_TITLE

	:IMAGENAME
		tools\SFK echo ENTER IMAGE NAME
		set new_imagename=BADNAME
		set /P new_imagename=   
		tools\SFK replace -quiet tools\cfg\settings.ini "/%imagename%/%new_imagename%/" -yes
		tools\SFK echo [cyan]Okey, will be called so.[def]
		echo.
		pause
		goto PRINT_TITLE

		echo.&echo ERROR^: END OF FILE&pause&exit


	:LAZ_TITLE
		cls
		tools\SFK echo [cyan]++++++++++++++++++++++++++++++[def]   [red]LAZYBOOT %LAZYVERSION%[def]   [cyan]++++++++++++++++++++++++++++++++++[def] 
		tools\SFK echo [cyan]+++++++++++++++++++++++++++++[def]   [yellow]SET YOUR SOUND[def]   [cyan]++++++++++++++++++++++++++++++++++[def] 
		tools\SFK echo [cyan]_______________________________________________________________________________[def]
		echo.
		goto :eof
	
		endlocal
		goto :eof

	:voicepack
		(for /f "delims=" %%i in (.\tools\cfg\settings.ini) do (
			set "line=%%i"
			if "!line!"=="%soundbank%" (
				echo %replace%
			) else (
				echo !line!
			)
		)) > .\tools\cfg\settings_new.txt

		move /y .\tools\cfg\settings_new.txt .\tools\cfg\settings.ini>nul
		goto :eof
