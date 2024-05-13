#!/usr/bin/env bash

sed -i 's/#BROWSERS=()/BROWSERS(brave)/g' "$XDG_CONFIG_HOME"/psd/psd.conf

sudo tee /usr/share/psd/browsers/brave <<EOF
DIRArr[0]="$XDG_CONFIG_HOME/BraveSoftware/Brave-Browser"
PSNAME="brave"
EOF

systemctl --user enable psd.service
systemctl --user start psd.service
systemctl --user status psd.service
psd preview
