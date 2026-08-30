#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q np2kai-git | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/np2.svg
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/xnp21kai_sdl2 /usr/bin/xnp2kai_sdl2 /usr/bin/xnp21kai_HAXM_sdl2

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
