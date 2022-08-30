@echo off
    ::::::::::::::::::::::::::::
    :: Autosave configuration ::
    ::::::::::::::::::::::::::::

    :: Project Zomboid folder location - dont leave backslash(\) at the end
    set gamePath=C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid

    :: Project Zomboid executable - use 32/64 version according to your OS
    set exeName=ProjectZomboid64.exe

    :: Project Zomboid save file path - you need to define Sandbox or Survival at the end, set <username> according to your environment - dont leave backslash(\) at the end
    set savePath=C:\Users\Synida\Zomboid\Saves\Sandbox

    :: World name that you would like to back up while playing Project Zomboid
    set saveFolder=15-08-2022_11-58-14

    :: Backup folder location where the backups will be saved - dont leave backslash(\) at the end
    set backupFolder=C:\Users\Synida\Zomboid\Saves\Backup

    :: Backup frequency in seconds - if u love your ssd, don't set it to something too small
    set backupFrequency=300

    :: This many of the last backups will be kept, the rest will be deleted over time to save space
    set keepBackups=15

    ::::::::::::::::::::::::::::
    :: Basic config validator ::
    ::::::::::::::::::::::::::::

    if not exist "%gamePath%\" (
        echo gamePath folder doesnt exists or incorrect, check the config
        pause
    )
    if not exist "%gamePath%\%exeName%" (
        echo game exe can not be found with this name, check the config
        pause
    )
    if not exist "%savePath%" (
        echo save path can not be found, check the config
        pause
    )
    if not exist "%savePath%\%saveFolder%" (
        echo save folder doesnt exist/was removed/incorrect, check the config
        pause
    )

    echo I hope you configured your setup properly

    ::::::::::::::::::::::::::::::
    :: Starting Project Zomboid ::
    ::::::::::::::::::::::::::::::

    start "" /D "%gamePath%\" %exeName%

    :: Initial delay
    timeout /t 30 /nobreak > nul

    :::::::::::::::::::::::::::::::::::
    :: Starting backup functionality ::
    :::::::::::::::::::::::::::::::::::

    :: Create backup folder if doesn't exist
    if not exist %backupFolder% mkdir %backupFolder%
    if not exist %backupFolder%\%saveFolder% mkdir %backupFolder%\%saveFolder%

    cd %backupFolder%\%saveFolder%
    set saveLocation=%savePath%\%saveFolder%

    :: Infinite loop running to back up the world stages in every %backupFrequency% seconds
    :loop
        :: Wait until the next scheduled backup
        timeout /t %backupFrequency% /nobreak > nul

        set subDate=%date:/=%
        set subTime=%time::=%
        set timestamp=%subDate: =_%_%subTime:.=_%
        echo %timestamp%

        echo Saving the world.
        set backupLocation=%backupFolder%\%saveFolder%\%timestamp%

        robocopy %saveLocation% %backupLocation% /E

        :: Delete all old saves except last %keepBackups% - based on file name, so don't change them
        for /f "skip=%keepBackups% eol=: delims=" %%F in ('dir /b /o-n /AD') do @rmdir /q /s "%%F"
    goto:loop
exit