# sync-drg

## How To Run
1. Download zip or clone this repo.
2. Navigate to root of repo in File Explorer. Right click on `Sync-Drg.ps1` and press _Run with PowerShell_.

You should see something like this:

```
Greetings, miner. I discovered the following saves:

Store         FileName                         LastSaveTime          Directory
-----         --------                         ------------          ---------
Steam         76561198264588508_Player.sav     4/21/2022 9:22:50 PM  F:\SteamLibrary\steamapps\common\Deep Rock Gala...
Windows Store 94537F038D9640E7ADB644C2AC1EFF16 1/20/2022 10:34:54 PM C:\Users\Youn\AppData\Local\Packages\CoffeeStai...



Command  Description
-------  -----------
stm->win Transfer save from Steam to Windows Store
win->stm Transfer save from Windows Store to Steam
latest   Transfer save that was most recently saved (stm->win)
exit     Close the window


Enter one command from above:
```

Choose a command and run. Happy mining!