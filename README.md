# Project Zomboid game autosave patch script

This is a configurable windows batch script that automatically saves any singleplayer games of the whitelisted game modes you start.

https://github.com/Synida/project-zomboid-backup-script

### Requirements
Basically nothing. The script uses PowerShell at some point, which is by default part of most Windows environments.
You migth experience difficulties with your anti-virus or win UAC upon downloading it, but the script is really open source with mostly commented lines,
so you can check that there aren't any nasty things in the code itself.

### Installation
1. Download the script - from Releases section(the ZIP file - last version)
2. Unzip the .bat file
3. Run the .bat file to start the game and the autosave at once
4. Enjoy.

You can also open up your favorite text editor like notepad, notepad++, sublime, whatever - and just copy the code from the bat file that you can find on GitHub.

### How does this work?
If you execute the .bat file a command line terminal will show up where the script will be running.
The script will check for PZ installation and save directories in your system.
If all of them are fine, and Steam is running, then it will start the game for you.
As you play the script will automatically detect if any of the games that you played before has any change in them.
If there is, it will create a save file, that you can use to reload your character to a previous part of his/her life.
This means that both wounds and the position of your character will revert to a previous state.
If the zombies eat your brain and the game would try to force you to start everything over, you can reload your game and continue it with all the experiences,
tools, equipment, wounds, that you have in that previous state of your life,
but you will be able to find your dead or zombified body at the last position where you died as well.

The script will automatically save every 2 minutes, which you can change in the script.
The game will store up to 15 save folders, and delete the older ones as it creates newer ones.
This can be changed in the script with a text editor as well to your liking.

### How to reload the save?
PZ game save location by default is: `%USERPROFILE%\Zomboid\Saves`.
You can access this easily by pressing `WIN + R` buttons at once, copy it there and pressing enter.
Here you can find your games and a folder named `Backup`. The `Backup` folder is only generated if you played with the script before.
Here you can find save folders for each game you played before, and each of these save folders will contain sub folders with date time names.
You find the game you want to reload here, and copy the content - `players.db`, `reanimated.bin`, `thumb.png` - back to the game's main save folder, overwriting the current files in the process.

### Known issues
- `!` character in the game name is not to the script's liking
- if you installed the Steam to an other partition the C, then you will have to change the driver letter in the script configuration section manually.