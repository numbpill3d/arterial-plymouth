#!/usr/bin/env bash
# Render all Arterial Plymouth PNG assets from SVG/text. Re-runnable.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; cd "$HERE"
W=1920; H=1080
EDGE="#b30000"; HOT="#e01b1b"; BLOOD="#8b0000"; GHOST="#ece6e6"; DIM="#6a6060"
FONT="$(fc-match -f '%{file}' 'Noto Sans Mono')"

# background: near-black with a radial red vignette + faint baked sigil
magick -size ${W}x${H} radial-gradient:'#120000'-'#040404' \
  \( _svg/sigil.svg -resize 820x820 -channel A -evaluate multiply 0.10 +channel \) \
  -gravity center -compose over -composite background.png

# centre sigil (bright)
rsvg-convert -w 360 -h 360 _svg/sigil.svg -o sigil.png

# wordmark + subtitle (pre-baked so no initramfs font dependency)
magick -background none -fill "$GHOST" -font "$FONT" -pointsize 64 -kerning 18 \
  label:'ARTERIAL' -trim +repage wordmark.png
magick -background none -fill "$DIM" -font "$FONT" -pointsize 20 -kerning 6 \
  label:'entering the system' -trim +repage subtitle.png

# progress track + fill
magick -size 620x6 xc:'#0a0000' -bordercolor "$EDGE" -border 1 progress_box.png
magick -size 620x4 gradient:"$BLOOD"-"$HOT" progress_bar.png

# password prompt bits
magick -background none -fill "$HOT" -font "$FONT" -pointsize 28 label:'†' -trim +repage lock.png
magick -size 10x10 xc:none -fill "$HOT" -draw 'circle 5,5 5,1' bullet.png
magick -size 360x40 xc:'#0a0000' -bordercolor "$EDGE" -border 1 entry.png
echo "assets rendered in $HERE"
