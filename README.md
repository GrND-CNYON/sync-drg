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

Choose a command and run. Rock and stone!

## Error: `cannot be loaded because running scripts is disabled on this system...`
If you get the above error, you can do the following:
1. Search for "powershell" in the Windows search bar.
2. You will see PowerShell pop up. Click _Run as administrator_.
3. In the window, type in:

```powershell
Set-ExecutionPolicy remotesigned
```
4. Press enter. Enter 'A' (Yes to all).
5. Close the PowerShell window. Now try to run the script again.
