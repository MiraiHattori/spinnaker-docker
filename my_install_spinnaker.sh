#!/bin/bash

set -o errexit

# version of the software
MAJOR_VERSION=1
MINOR_VERSION=7
RELEASE_TYPE=0
RELEASE_BUILD=6
INFORMATIONAL_VERSION=1.7.0.6
RELEASE_TYPE_TEXT=Release

echo "Installing Spinnaker packages...";

sudo dpkg -i libspinvideoencoder-*.deb
sudo dpkg -i libspinnaker-*.deb
sudo dpkg -i libspinvideo-*.deb
sudo dpkg -i spinview-qt-*.deb
sudo dpkg -i spinupdate-*.deb
sudo dpkg -i spinnaker-*.deb

grpname="flirimaging"
usrname="root"

echo "Add user $usrname to group $grpname.";
echo "Is this ok?:";
groupadd -f $grpname
usermod -a -G $grpname $usrname

echo "Configuration complete. A reboot may be required on some systems for changes to take effect";
