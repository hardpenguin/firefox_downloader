#!/bin/bash
set -e

# this script is meant to download latest version of Firefox for Linux
# then unpack it in the system-wide path
# to put Firefox in $PATH, alternatives system is recommended

ScriptName="$(basename $0)"
Version="0.4"

FirefoxLink="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=pl"
PackageFileName="firefox.tar.bz2"
TargetPath="/usr/lib"
FirefoxDirectory="firefox"

FirefoxPath="$TargetPath/$FirefoxDirectory"
TempPath="/tmp/firefox_update_$RANDOM"
TempPackage="$TempPath/$PackageFileName"
TempFirefoxPath="$TempPath/$FirefoxDirectory"

PackageContents=("firefox:application/x-executable"
                "browser:inode/directory")

echo "$ScriptName, version $Version"

# check if the running user is root
if [ "$(whoami)" != "root" ];
then
    echo "You are not root."
    exit 1
fi

# check for spaces in the paths used for file manipulation
Space=" "
if [ -z "${FirefoxPath##*$Space*}" ] || [ -z "${TempFirefoxPath##*$Space*}" ]
then
    echo "Spaces found in one of the paths."
    exit 1
fi

# remove existing Firefox directory if there is one
if [ -e "$FirefoxPath" ];
then
    echo "Removing previous version..."
    rm -r "$FirefoxPath"
else
    echo "No previous Firefox installation found..."
fi

# create directories required by the script
echo "Creating necessary directories..."
mkdir -p "$TempPath"

# download Firefox package to temporary path
echo "Downloading..."
wget -q "$FirefoxLink" -O "$TempPackage"

# if the downloaded file is actually a package, unpack it to a temporary path 
MimeType="$(file --mime-type -b $TempPackage)"
if [ "$MimeType" == "application/x-bzip2" ]
then
    echo "Unpacking to the temporary path..."
    tar xf "$TempPackage" -C "$TempPath"
else
    echo "The downloaded file is not a bzip2 archive."
    exit 1
fi

# check if the unpacked files contains Firefox
for Item in "${PackageContents[@]}"
do
    Name="${Item%%:*}"
    Type="${Item##*:}"
    MimeType="$(file --mime-type -b $TempFirefoxPath/$Name)"
    if [ "$MimeType" != "$Type" ]
    then
        echo "The Firefox folder is missing some of the key contents."
        exit 1
    fi
done

# move unpacked files to the desired path
mv "$TempFirefoxPath" "$FirefoxPath"

# make sure that the newly moved files are owned by root
echo "Updating ownership..."
chown -R root:root "$FirefoxPath"

echo "Done."
exit 0