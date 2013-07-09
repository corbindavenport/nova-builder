N0VA Builder is a command-line tool for *nix systems (Unix, Linux, Mac OS X, Android, etc) to create modpacks for the Technic Launcher. On first run, it generates the structure of the modpack, then it requires the user to put the mods in the correct places. Here's where each type of mod goes:

/pack		mods that need to go in the .minecraft folder
/pack/bin	mods that need to go in the MC bin folder
/pack/bin/jar	mods that need to go in minecraft.jar
/pack/mods	Forge mods in .zip format

Overall, the format is exactly like the regular Minecraft folder structure (except of course the jar folder, which substitutes minecraft.jar). The latest build of Minecraft Forge is automatically downloaded, so you shouldn't download Forge manually and put it in the jar folder.

You can also edit the build script by opening it in a text editor and modifying the variables at the very top of the script. These include:

DIR		This is the folder the script is in. You shouldn't
		change this unless you know what you are doing.

FORGE		This is the online path to the Forge zip file. You
		can change this if you wish to use a custom version
		of Minecraft Forge, or another mod loader.

WGET		This is the path to the wget unix program, which is
		used to download Forge. If you are using Linux,
		just 'wget' should work. For Mac OS X use '$DIR/wget'

ZIP		This is the name of the zip file that the builder
		creates will be called. Default is 'mod.zip'. This
		must end in .zip.

