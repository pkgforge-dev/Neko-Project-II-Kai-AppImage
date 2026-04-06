#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libcdio-paranoia \
    libdecor

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package gtk2
#PRE_BUILD_CMDS='sed -i -e "s/patch -p1 -i \"\${srcdir}\/3d23274eefcf9c494358662539c29eebd8996cbf.patch\"/# &/" -e "s/patch -p1 -i \"\${srcdir}\/697fac371b414212526aae25e7c9774f167f4ef3.patch\"/# &/" ./PKGBUILD' make-aur-package np2kai-git
PRE_BUILD_CMDS='sed -i -e "s/patch -p1 -i \"\${srcdir}\/3d23274eefcf9c494358662539c29eebd8996cbf.patch\"/# &/" -e "s/patch -p1 -i \"\${srcdir}\/697fac371b414212526aae25e7c9774f167f4ef3.patch\"/# &/" -e "/prepare() {/a \  sed -i \"s/MID_DBSS/MID_EN_DBSS/g\" \"\${srcdir}/NP2kai/embed/menubase/menusys.c\"" ./PKGBUILD'

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
