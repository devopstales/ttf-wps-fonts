#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

if [[ $(id -u) -ne 0 ]] ; then
  echo "This script requires sudo privileges"
  exit 1
fi

HOME_FONT="$HOME/.fonts"
MOST_DISTROS="/usr/share/fonts"
RHL5="/usr/X11R6/lib/X11/fonts"
RHL6="/usr/X11R6/lib/X11/fonts"

if test -e $MOST_DISTROS ; then
        FONT_PATH=$MOST_DISTROS
elif test -e $RHL5 ; then
        FONT_PATH=$RHL5
elif test -e $RHL6 ; then
        FONT_PATH=$RHL6
else
        FONT_PATH=$HOME_FONT
fi

FONT_PATH=$FONT_PATH"/wps-fonts"

if [ -d "$FONT_PATH" ]; then
  # flush stdin
  while read -r -t 0; do read -r; done 
  read -p "Font Directory already exists, continue? [y/N] " -n 1 -r 

  if [[ $REPLY == "" ]]; then
    exit 0
  elif [[ $REPLY =~ ^[Nn]$ ]]; then
    exit 0
  fi
fi

echo -e "\nFonts will be installed in: "$FONT_PATH
read -p "Continue with installation? [Y/n] " -n 1 -r

if [[ $REPLY =~ ^[Nn]$ ]]; then
  exit 0
fi

if [ ! -d "$FONT_PATH" ]; then
  echo "Creating Font Directory..."
  mkdir $FONT_PATH
fi

echo "Installing Fonts..."
cp *.ttf $FONT_PATH
cp *.TTF $FONT_PATH

sudo dnf install -y ipa-gothic-fonts ipa-pgothic-fonts ipa-mincho-fonts ipa-pmincho-fonts
sudo dnf install -y thai-scalable-garuda-fonts
sudo dnf install -y dejavu-sans-fonts

cd /tmp
wget http://download.savannah.nongnu.org/releases/freebangfont/MuktiNarrow-0.94.tar.bz2
tar -xjf MuktiNarrow-0.94.tar.bz2
sudo mv MuktiNarrow0.94/MuktiNarrow.ttf /usr/share/fonts/truetype/ttf-indic-fonts-core/
rm MuktiNarrow-0.94.tar.bz2
rm -r MuktiNarrow0.94/

sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

echo "Fixing Permissions..."
chmod 644 $FONT_PATH/*
echo "Rebuilding Font Cache..."
fc-cache -vfs
echo "Installation Finished."

exit 0
