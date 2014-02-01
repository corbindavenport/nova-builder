#!/usr/bin/env bash

# This sets $DIR to the directory the script is running from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# This is the Forge jar that is downloaded. Default is the latest release.
FORGE=http://files.minecraftforge.net/minecraftforge/minecraftforge-universal-latest.jar
# This is what the modpack zip is named when it is created. Must end in .zip.
ZIP="nova-beta.zip"
# This is the IP address that is used to check for an internet connection.
IP="8.8.8.8"

# Basic usage for N0VA Builder, displayed with -help parameter
HELP="N0VA Builder is a command-line tool for *nix systems (Unix, Linux, Mac OS X, Android, etc) to create modpacks for the Technic Launcher. On first run, it generates the structure of the modpack, then it requires the user to put the mods in the correct places. Here's where each type of mod goes:

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

ZIP		This is the name of the zip file that the builder
		creates will be called. Default is 'mod.zip'. This
		must end in .zip.

IP	       This is the IP address used to check for an internet
	       connection. The default is 8.8.8.8 (Google's DNS)"

echo "[INFO] N0VA Builder 1.0"

# Check if help parameter is used
if [ "$1" == "-help" ] ; then
	echo "$HELP"
	exit 0
fi

# Check if folders exist
cd "$DIR"
if [ ! -d "pack" ]; then
	echo "[INFO] No modpack folder found, now generating new one"
	mkdir pack
	echo "[ OK ] Pack folder created."
	cd pack
	if [ ! -d "mods" ]; then
	  mkdir mods
	fi
	echo "[ OK ] Mods folder created."
	if [ ! -d "bin" ]; then
	  mkdir bin
	fi
	echo "[ OK ] Bin folder created."
	cd bin
	if [ ! -d "jar" ]; then
	  mkdir jar
	fi
	echo "Folders created. Now place the mods in their appropriate places (use -help or the readme file for more information) and run the build again."
	read -p "Press [Enter] to exit."
	exit 0
fi

# Check if internet connection is working
echo "[INFO] Checking for internet connection, pinging Google DNS servers"
ping -c 3 $IP > result
grep 100% result > /dev/null
if [ $? = 0 ]; then
	echo "[INFO] Your internet connection is unavailable."
	echo "[INFO] Unable to download Minecraft Forge, now exiting build."
	exit 0
	else
	echo "[INFO] Internet connection detected."
fi
rm ./result

# Checking for all necessary applications
if [ ! -x /usr/bin/zip ] ; then
	echo "[INFO] No ZIP binary found, ZIP is required to run N0VA Builder."
	echo "[INFO] Now exiting builder."
	exit 0
fi
if [ ! -x /usr/bin/unzip ] ; then
	echo "[INFO] No UNZIP binary found, UNZIP is required to run N0VA Builder."
	echo "[INFO] Now exiting builder."
	exit 0
fi
if [ ! -x /usr/bin/curl ] ; then
	echo "[INFO] No CURL binary found, CURL is required to run N0VA Builder."
	echo "[INFO] Now exiting builder."
fi
echo "[ OK ] All required binaries found."

# Package modpack zip file
cd "$DIR/pack/bin"
echo "[ .. ] Downloading Minecraft Forge.."
curl -o modpack.zip "$FORGE" -LOk
echo "[ OK ] Forge downloaded."
echo "[ .. ] Unzipping Forge into /bin/modpack.."
unzip -qq modpack.zip -d modpack
echo "[ OK ] Forge unzipped."
rm modpack.zip
echo "[ OK ] Forge download files cleaned up."
echo "[ .. ] Compressing modpack.jar file.."
cp "$DIR/pack/bin/jar/*" "$DIR/pack/bin/modpack/*" 2>/dev/null || :
zip -q -j modpack.jar modpack/* -x ".*"
rm -rf "modpack/"
echo "[ OK ] modpack.jar file created."
mv "$DIR/pack/bin/jar" "$DIR/jar"
echo "[ OK ] Jar folder temporarily moved."
echo "[ .. ] Compressing modpack.."
cd "$DIR/pack"
zip -r -q "$ZIP" ./* -x ".*"
mv "$ZIP" "$DIR"
echo "[ OK ] Modpack zip file created, cleaning up now."
mv "$DIR/jar" "$DIR/pack/bin/jar"
cd "$DIR/pack/bin"
rm modpack.jar
cd "$DIR"
echo "[INFO] Finished cleaning up, now exiting build."
