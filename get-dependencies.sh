#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake            \
    gdk-pixbuf2      \
    glib2            \
    libcdio-paranoia \
    nasm             \
    sdl3_ttf         \
    tomlplusplus     \
    wxwidgets-common \
    wxwidgets-gtk3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano gtk2-mini libdecor-mini

# Comment this out if you need an AUR package
#PRE_BUILD_CMDS='sed -i -e "s/patch -p1 -i \"\${srcdir}\/3d23274eefcf9c494358662539c29eebd8996cbf.patch\"/# &/" -e "s/patch -p1 -i \"\${srcdir}\/697fac371b414212526aae25e7c9774f167f4ef3.patch\"/# &/" -e "/prepare() {/a \  sed -i \"s/MID_DBSS/MID_EN_DBSS/g\" \"\${srcdir}/NP2kai/embed/menubase/menusys.c\"" ./PKGBUILD' make-aur-package np2kai-git

echo "Building NP2kai..."
echo "---------------------------------------------------------------"
REPO="https://github.com/AZO234/NP2kai"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./NP2kai
echo "$VERSION" > ~/version

cd ./NP2kai
#export NP2KAI_VERSION="$(git describe --tags --abbrev=0)"
export NP2KAI_HASH="$(git rev-parse --short HEAD)"
cmake -S ./ -B build \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_X=ON \
    -DBUILD_SDL=ON \
    -DBUILD_I286=OFF \
    -DBUILD_HAXM=ON \
    -DUSE_SDL=3 \
    -DUSE_HAXM=OFF \
    -DUSE_ASYNCCPU=ON \
    -DUSE_VST3SDK=OFF \
    -DCMAKE_C_FLAGS="-Wno-implicit-function-declaration -Wno-incompatible-pointer-types -Wno-int-conversion" \
    -DCMAKE_CXX_FLAGS="-fno-sized-deallocation"
cmake --build build -j$(nproc)
cmake --install build
