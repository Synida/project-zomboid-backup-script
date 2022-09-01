# Project Zomboid backup script

This is a configurable basic script to help you to generate automated backups from the game save.
It will start the game upon execution - if you are logged into steam - then start producing copies of your selected game world with the configured frequency.
Mind that it can't save the game more frequently then as the game saves the world status itself.
Since the game save folder can be quite big, producing the copies can take quite the time as well.
The script will also limit the copies being made to the specified amount, and delete the older backup folder - over the backup limit u wish to keep.

The backup frequency actually defines the time between two backup from the previous backup's completion to the start of the new backup.
Meaning that if creating a backup takes 5 minutes and you set your backup frequency to 15 minutes, then the next backup will be created 20 minutes later.

To restore a backup you need to copy the backup folder back to the save folder - and rename there if you wish.
Do not rename the folder names in the backup folder, because the backup limit deletion is based on the folder names.

Mind that UAC(windows' user account control) prevent you from executing the script, if you download it from the internet.

### Known issue
- If the game save happens in the same time with the backup generation, it is possible that some of the files will have the older version stored

### Future improvement possibility
The saving time can be greatly reduced if the backups are made only from the changed files since the last backup.