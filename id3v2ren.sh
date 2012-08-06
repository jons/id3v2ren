#!/bin/bash
#
# examples:
#   find path/to/uncategorized -type f -exec id3v2ren.sh '{}' \;
#   find path/to/uncategorized -name \*mp3 | xargs -n1 id3v2ren.sh
#

MODE="cp"

SRC="$1"

if [ -z "$SRC" ]; then
  echo "usage: $0 [-m] file.mp3"
  exit 1
fi

if [ ! -f "$SRC" ]; then
  echo "Not found: $SRC"
  exit 1
fi

DEST=`id3v2 -R "$SRC" | awk ' /^TP1/ { a=$2 } /^TAL/ { b=$2 } /^TT2/ { t=$2 } /^TCO/ { c=$2 } \
                              /^TPE1/ { a=$2 } /^TALB/ { b=$2 } /^TRCK/ { n="$2-" } /^TIT2/ { t=$2 } \
                              END { printf "%s/%s/%s%s.mp3", a, b, n, t }'`

mkdir -p "$(dirname "$DEST")"

touch "$DEST"

if [ -f "$DEST" ]; then
  # TODO: if -m specified, use mv instead of cp
  cp "$SRC" "$DEST"
fi

