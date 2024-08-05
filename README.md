 # ![](https://raw.githubusercontent.com/clothing-hanger/Harmoni/main/Harmoni/Images/TITLE/logo.png)

Open source rhythm game written in Love2D Lua

- Supports Quaver charts

# Known Issues

- Settings menu and Credits menu are not working correctly, Modify settings in `settings.lua`
- Keybinds are hardcoded into the source, easily changeable in main.lua

to fullscreen pressed f11

# Importing songs

To Import your own songs into Harmoni from quaver, right click on the song in Quaver's song selection menu, press export, then extract the files to a folder using an archive utility like 7zip or WinRAR (hope none of yalls registered it) drag the folder into Harmoni's music folder.

If your using an archive manager that isnt 7Zip you will have to rename the .qp to .zip to open the archive

~~maybe GNOME File Roller can do this??~~

DO NOTE if a folder has a `.` in the name, Harmoni WILL crash when trying to load it