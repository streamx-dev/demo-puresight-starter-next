#!/bin/bash

source ./utils.sh
source ./convert.sh

USAGE="Usage: $0 <source_directory>"
EXPECTED=1
INTRO=$#
if [[ $INTRO -ne $EXPECTED ]]; then
    log "ERROR" "Wrong number of arguments: $INTRO found, $EXPECTED expected"
    log "INFO" "$USAGE"
    exit 1
fi

SIZES=(
  "976:650"
  "805:536"
  "704:469"
  "635:423"
  "430:430"
  "575:863"
  "340:510"
  "332:498"
  "276:414"
  "268:402"
  "204:306"
  "96:96"
  "48:48"
  "36:36"
)

EXTENSIONS=("webp")

SOURCE_DIRECTORY="$1"
if [ -d SOURCE_DIRECTORY ]; then
  log "ERROR" "Source directory $SOURCE_DIRECTORY does not exits";
  exit 1;
fi

for EXTENSION in "${EXTENSIONS[@]}" ; do
  for SIZE in "${SIZES[@]}" ; do
    WIDTH=${SIZE%%:*}
    HEIGHT=${SIZE#*:}

    convert "$SOURCE_DIRECTORY" "$EXTENSION" "$WIDTH" "$HEIGHT"

  done
done
