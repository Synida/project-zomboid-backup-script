@echo off
    ::::::::::::::::::::::::::::
    :: Autosave configuration ::
    ::::::::::::::::::::::::::::

    :: Project Zomboid folder location - dont leave backslash(\) at the end
    set gamePath=C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid

    :: Project Zomboid executable name - use 32/64 version according to your OS
    set exeName=ProjectZomboid64.exe

    :: Project Zomboid default save file path
    set savePath=%USERPROFILE%\Zomboid\Saves

    :: PZ game modes - or more like the save folder names that belogs to them - whitelist
    set gameModes=Sandbox Survivor Apocalypse Builder Kingsmouth "A Really CD DA" "A Storm is Coming" "Studio" "The Descending Fog" "Winter is Coming" "You Have One Day"

    :: Backup folder location where the backups will be saved
    set backupFolder=%USERPROFILE%\Zomboid\Saves\Backup

    :: Backup frequency in seconds - basically the save script execution frequency and not the game's save frequency
    set backupFrequency=120

    :: This many of the last backups will be kept, the rest will be deleted over time to not trash your backup folders
    set keepBackups=15

    ::::::::::::::::::::::::::::
    :: Basic config validator ::
    ::::::::::::::::::::::::::::

    if not exist "%gamePath%\" (
        echo gamePath folder doesnt exists or incorrect, check the config
        pause
        exit
    )
    if not exist "%gamePath%\%exeName%" (
        echo game exe can not be found with this name, check the config
        pause
        exit
    )
    if not exist "%savePath%" (
        echo save path can not be found, check the config
        pause
        exit
    )

    echo I hope you configured your setup properly.
    echo Base path validation passed.

    ::::::::::::::::::::::::::::::
    :: Starting Project Zomboid ::
    ::::::::::::::::::::::::::::::

    start "" /D "%gamePath%\" %exeName%

    :: Initial delay
    timeout /t 60 /nobreak > nul

    :::::::::::::::::::::::::::::::::::
    :: Starting backup functionality ::
    :::::::::::::::::::::::::::::::::::

    :: Create backup folder if doesn't exist
    if not exist "%backupFolder%" mkdir "%backupFolder%"

    setlocal EnableDelayedExpansion

    :: Infinite loop running to back up the world stages in every %backupFrequency% seconds
    :loop
        :: Wait until the next scheduled backup
        timeout /t %backupFrequency% /nobreak > nul

        for %%a in (%gameModes%) do (
            if exist "%savePath%\%%~a" (
                cd "%savePath%\%%~a"

                set count=0
                for /f %%b in ('dir /b /ad "%savePath%\%%~a"') do (
                    set /A count+=1
                )

                if not !count! == 0 (
                    set n=0
                    :: Checking for game directories
                    for /d %%d in (*.*) do (
                        set games[!n!]=%%d
                        set /A n+=1
                    )

                    if not !n! == 0 (
                        set /A n-=1
                    )

                    for /L %%i in (0,1,!n!) do (
                        set saveFolder=!games[%%i]!
                        cd "%backupFolder%\%saveFolder%"

                        :: Create save folder if it doesn't exist
                        if not exist "%backupFolder%\!saveFolder!" mkdir "%backupFolder%\!saveFolder!"

                        :: get the last modification time of the game's player database
                        for /f %%j in ('PowerShell -NoProfile -NoLogo -Command "(Get-Item '%savePath%\%%~a\!saveFolder!\players.db').LastWriteTime | Get-Date -Format yyyy-MMM-dd-HH-mm-ss"') do set timestamp=%%j

                        if not exist "%backupFolder%\!saveFolder!\!timestamp!" (
                            echo Saving the world for the %%~a game: !saveFolder!
                            mkdir "%backupFolder%\!saveFolder!\!timestamp!"
                            robocopy "%savePath%\%%~a\!saveFolder!" "%backupFolder%\!saveFolder!\!timestamp!" players.db reanimated.bin thumb.png
                        ) else (
                            echo No changes has been detected in the %%~a game: !saveFolder!
                        )

                        :: Delete all old saves except last %keepBackups% - based on folder naming, not modification dates
                        for /f "skip=%keepBackups% eol=: delims=" %%F in ('dir /b /o-n /AD') do @rmdir /q /s "%%F"
                    )
                    :continue
                    echo\
                ) else (
                    echo The %%~a folder is empty. Skipping.
                )
            ) else (
                echo No %%~a game found. Skipping.
            )
        )
    goto:loop
    endlocal
exit