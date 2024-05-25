#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

if [[ ! -d ~/Packages ]]; then
	mkdir ~/Packages
fi

if ! which git &>/dev/null; then
	echo "git is not installed. Please install it first."
	exit 1
fi

################### MV to Packages ########################
pushd ~/Packages

curl https://cht.sh/:cht.sh >cht.sh
chmod +x cht.sh
mv cht.sh ~/.local/bin/

curl -o doc2txt.zip https://sourceforge.net/projects/docx2txt/files/latest/download
unzip doc2txt.zip

curl -o "OneDriveGUI.AppImage" https://github.com/bpozdena/OneDriveGUI/releases/latest/download/OneDriveGUI-1.0.3_fix150-x86_64.AppImage

# CommitMono nerd font
curl -o "ComitMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CommitMono.zip
unzip ComitMono.zip -d CommitMono
mv CommitMono ~/.local/share/fonts/

# shellharden binary
curl -o shellharden.tar.gz \
	https://github.com/anordal/shellharden/releases/latest/download/shellharden-x86_64-unknown-linux-gnu.tar.gz
tar -xzf shellharden.tar.gz -C ~/.local/bin/

# biome binary
curl -o biome \
	https://github.com/biomejs/biome/releases/latest/download/biome-linux-x64

mv biome ~/.local/bin/

git clone https://github.com/somepaulo/MoreWaita.git
./MoreWaita/install.sh

git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

popd
