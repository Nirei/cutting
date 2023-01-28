#!/bin/bash

for x in screen-*.png; do
  convert "$x" -define webp:lossless=true "$x.webp"
done
frames=( )
for f in screen-0*.webp; do
  frames+=( -frame "$f" +16+0+0+0+b )
done
webpmux "${frames[@]}" -o "animation-$(find -name 'animation-*.webp' | wc -l).webp"
rm *.png
rm *.png.webp