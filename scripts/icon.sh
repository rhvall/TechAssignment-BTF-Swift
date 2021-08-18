#!/bin/bash

##################################################################
# Make a bunch of iOS App icons from a Master
# Given an image at least 512x512 pixels named icon.png, resize and create a
# duplicate at each specified size. Add new sizes as needed. When finished,
# copy the resulting images into your Xcode iOS project.

OUTDIR=ios/App/App/Assets.xcassets/AppIcon.appiconset

# Make sure there is an iOS directory already
if [ ! -d ./ios ]
  then
    echo Add iOS App first
    exit 1
fi

if [ ! -f icon.png ]
  then
    echo Please add a PNG image named icon.png to this folder and re-run this script.
    exit 1
fi

echo Making $OUTDIR if it does not already exist.
[ -d $OUTDIR ] || mkdir -p $OUTDIR

echo Generating Icons...

sips -z 20 20 --out $OUTDIR/AppIcon-20x20@1x.png icon.png
sips -z 40 40 --out $OUTDIR/AppIcon-20x20@2x-1.png icon.png
sips -z 40 40 --out $OUTDIR/AppIcon-20x20@2x.png icon.png
sips -z 60 60 --out $OUTDIR/AppIcon-20x20@3x.png icon.png
sips -z 29 29 --out $OUTDIR/AppIcon-29x29@1x.png icon.png
sips -z 58 58 --out $OUTDIR/AppIcon-29x29@2x-1.png icon.png
sips -z 58 58 --out $OUTDIR/AppIcon-29x29@2x.png icon.png
sips -z 87 87 --out $OUTDIR/AppIcon-29x29@3x.png icon.png
sips -z 40 40 --out $OUTDIR/AppIcon-40x40@1x.png icon.png
sips -z 80 80 --out $OUTDIR/AppIcon-40x40@2x-1.png icon.png
sips -z 80 80 --out $OUTDIR/AppIcon-40x40@2x.png icon.png
sips -z 120 120 --out $OUTDIR/AppIcon-40x40@3x.png icon.png
sips -z 512 512 --out $OUTDIR/AppIcon-512@2x.png icon.png
sips -z 120 120 --out $OUTDIR/AppIcon-60x60@2x.png icon.png
sips -z 180 180 --out $OUTDIR/AppIcon-60x60@3x.png icon.png
sips -z 76 76 --out $OUTDIR/AppIcon-76x76@1x.png icon.png
sips -z 152 152 --out $OUTDIR/AppIcon-76x76@2x.png icon.png
sips -z 167 167 --out $OUTDIR/AppIcon-83.5x83.5@2x.png icon.png
