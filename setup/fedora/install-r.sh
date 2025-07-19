#!/usr/bin/env sh

# Description of the script.
sudo dnf install R --setopt=install_weak_deps=False

sudo dnf install cmake libcurl-devel harfbuzz-devel fribidi-devel freetype-devel libpng-devel freetype-devel libpng-devel libtiff-devel libjpeg-devel unixODBC-devel libarrow-devel proj-devel geos-devel gdal-devel --setopt=install_weak_deps=False
