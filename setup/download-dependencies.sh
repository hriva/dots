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

curl -o doc2txt.tgz https://sourceforge.net/projects/docx2txt/files/latest/download
tar -xzf doc2txt.tgz

curl -o "OneDriveGUI.AppImage" https://github.com/bpozdena/OneDriveGUI/releases/latest/download/OneDriveGUI-1.0.3_fix150-x86_64.AppImage

# CommitMono nerd font
curl -o "ComitMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CommitMono.zip
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

curl -o xsv.tar.gz https://github.com/BurntSushi/xsv/releases/latest/download/xsv-0.13.0-x86_64-unknown-linux-musl.tar.gz
tar -xzf xsv.tar.gz -C ~/.local/bin

curl https://github.com/TheZoraiz/ascii-image-converter/releases/latest/download/ascii-image-converter_Linux_amd64_64bit.tar.gz | tar -xz
chmod u+x ascii-image-converter_Linux_amd64_64bit/ascii-image-converter
mv ascii-image-converter_Linux_amd64_64bit/ascii-image-converter ~/.local/bin/
/usr/bin/rm -r ascii-image-converter_Linux_amd64_64bit

git clone https://github.com/somepaulo/MoreWaita.git
./MoreWaita/install.sh

git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

popd
