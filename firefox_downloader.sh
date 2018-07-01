#!/bin/bash
set -e

# this script is meant to download latest version of Firefox for Linux
# then unpack it in the system-wide path
# to put Firefox in $PATH, alternatives system is recommended

ScriptName="$(basename $0)"
Version="0.2"

FirefoxLink="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=pl"
PackageFileName="firefox.tar.bz2"
TargetPath="/usr/lib"
FirefoxDirectory="firefox"
TempPath="/tmp/firefox_update_$RANDOM"

echo "$ScriptName, version $Version"

if [ "$(whoami)" != "root" ];
then
    echo "You are not root."
    exit 1
fi

if [ -e "$TargetPath/$FirefoxDirectory" ];
then
    echo "Removing previous version..."
    rm -r "$TargetPath/$FirefoxDirectory"
fi

echo "Creating necessary directories..."
mkdir -p "$TempPath"
mkdir -p "$TargetPath/$FirefoxDirectory"

echo "Downloading..."
wget -q "$FirefoxLink" -O "$TempPath/$PackageFileName"

echo "Unpacking..."
tar xf "$TempPath/$PackageFileName" -C "$TargetPath"

echo "Updating ownership..."
chown -R root:root "$TargetPath/$FirefoxDirectory"

echo "Done."
exit 0