PKG_LIST=(
    gstreamer1-plugin-libav
    gstreamer1-plugins-bad-free-extras
    gstreamer1-plugins-bad-freeworld
    gstreamer1-plugins-ugly
    gstreamer1-vaapi
    rpmfusion-nonfree-release-tainted
)

sudo dnf install -y --skip-broken "${PKG_LIST[@]}"
