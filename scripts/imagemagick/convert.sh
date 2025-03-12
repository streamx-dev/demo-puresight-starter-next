#!/bin/bash

source ./utils.sh

convert() {
  USAGE="Usage: $0 <source_directory> <extension> <output_width> <output_height>"
  EXPECTED=4
  INTRO=$#
  if [[ $INTRO -ne $EXPECTED ]]; then
      log "ERROR" "Wrong number of arguments: $INTRO found, $EXPECTED expected"
      log "INFO" "$USAGE"
      exit 1
  fi

  validate_commands_installed
  TMP_RESULT=$?
  if [[ $TMP_RESULT -ne 0 ]]; then
    exit $TMP_RESULT
  fi

  SOURCE_DIRECTORY="$1"
  if [ -d SOURCE_DIRECTORY ]; then
    log "ERROR" "Source directory $SOURCE_DIRECTORY does not exits1";
    exit 1;
  fi

  TARGET_DIRECTORY="$1/output"
  if [ -d TARGET_DIRECTORY ]; then
    mkdir -p "$TARGET_DIRECTORY";
  else
    rm -rf "$TARGET_DIRECTORY/*"
  fi

  EXTENSION="$2"
  WIDTH="$3"
  HEIGHT="$4"

  log "INFO" "Searching for images at $SOURCE_DIRECTORY"
  IMAGES=( `find "$SOURCE_DIRECTORY" -type f -exec file {} \; | grep -v "/output" | grep -o -E '^(.*): \w+ image' | awk -F: '{print $1}'` )
  for SOURCE in "${IMAGES[@]}" ; do
    log "INFO" "Converting image $SOURCE to format $EXTENSION, size ${WIDTH}x${HEIGHT}"
    local SOURCE_FILENAME="${SOURCE%.*}"
    local SOURCE_EXTENSION="${SOURCE##*.}"

    local TARGET_FILENAME_RESIZE=$(echo "$SOURCE" | sed -e "s|${SOURCE_DIRECTORY}|${TARGET_DIRECTORY}|g" | sed -e "s|.${SOURCE_EXTENSION}|_${WIDTH}x${HEIGHT}.${EXTENSION}|g")
    log "INFO" "Target resized image $TARGET_FILENAME_RESIZE"

    execute_magick_command resize $SOURCE $WIDTH $HEIGHT $TARGET_FILENAME_RESIZE
    TMP_RESULT=$?
    if [[ $TMP_RESULT -ne 0 ]]; then
      exit $TMP_RESULT
    fi
    log "INFO" "Target resize cmd $RESIZE_CMD"
  done
}

#    for size in "${SIZES[@]}" ; do
#        w=${size%%:*}
#        h=${size#*:}
#        resizedFile="result/resized/${filename}_${w}x${h}.webp"
#        croppedFile="result/${filename}_${w}x${h}.webp"
#
#        cmd="magick $file -resize ${w}x${h}^ $resizedFile"
#        printf "Converting image %s using cmd: %s \n" "$file" "$cmd"
#        $cmd
#
#        resizedw=`magick $resizedFile -format "%[fx:(w)]" info:`
#        resizedh=`magick $resizedFile -format "%[fx:(h)]" info:`
#
#        if [ "$resizedw" != "$w" ]; then
#          cropx=`magick $resizedFile -format "%[fx:(w-${w})/2]" info:`
#          printf "Crop from left $s\n" "$cropx"
#          cmd2="magick $resizedFile -crop ${w}x+${cropx}+0 $croppedFile"
#          printf "Cropping image %s using cmd: %s \n" "$resizedFile" "$cmd2"
#          $cmd2
#        else
#          cropy=`magick $resizedFile -format "%[fx:(h-${h})/2]" info:`
#          printf "Crop from top $s\n" "$cropy"
#          cmd2="magick $resizedFile -crop ${resizedw}x${h}+0+${cropy} $croppedFile"
#          printf "Cropping image %s using cmd: %s \n" "$resizedFile" "$cmd2"
#          $cmd2
#        fi
#    done

