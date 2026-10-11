#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/AZO234/NP2kai/5939e0c6d5985c4c08fc70f289a83290e5d3e6f7/misc/np2.svg
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/wxnp21kai /usr/bin/sdlnp21kai

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
