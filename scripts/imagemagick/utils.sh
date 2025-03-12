#!/bin/bash

log() {
    LEVEL=$1
    shift
    MESSAGE=$@

    if [[ $SILENT -eq 1 ]] && [[ $SHOW_ERRORS -eq 0 || $LEVEL != "ERROR" ]]; then
        return 0
    fi

    case $LEVEL in
        ERROR)
            LEVEL="\e[91mERROR\e[0m"
            ;;
        INFO)
            LEVEL=" \e[92mINFO\e[0m"
            ;;
        WARN)
            LEVEL=" \e[93mWARN\e[0m"
            ;;
        *)
            ;;
    esac

    printf "%s | $LEVEL : %b\n" "$(date)" "$MESSAGE"
}

validate_commands_installed() {
  OUTPUT=$(type ${magick} 2>&1)
  local RESULT=$?
  if [[ $RESULT -ne 0 ]]; then
    log "ERROR" "Command magick not installed. Please install it with https://imagemagick.org and try again."
    return 1
  fi
}

execute_magick_command() {
  local CMD=$1

  case $CMD in
  resize)
      local USAGE="Usage: $0 <source_file> <output_width> <output_height> <target_file>"
      local EXPECTED=5
      local INTRO=$#
      if [[ $INTRO -ne $EXPECTED ]]; then
          log "ERROR" "Wrong number of arguments: $INTRO found, $EXPECTED expected"
          log "INFO" "$USAGE"
          exit 1
      fi

      local SOURCE_FILE=$2
      local OUTPUT_WIDTH=$3
      local OUTPUT_HEIGHT=$4
      local TARGET_FILE=$5

      local TARGET_DIRECTORY=${TARGET_FILE%/*}/
      if [ -d TARGET_DIRECTORY ]; then
        mkdir -p "$TARGET_DIRECTORY";
      fi
      local SOURCE_WIDTH=$(magick "$SOURCE_FILE" -format "%[fx:(w)]" info:)
      local SOURCE_HEIGHT=$(magick "$SOURCE_FILE" -format "%[fx:(h)]" info:)

      if [ "$SOURCE_WIDTH" -gt "$SOURCE_HEIGHT" ]; then
        RESIZE_CMD="magick $SOURCE_FILE -resize ${OUTPUT_WIDTH}^x${OUTPUT_HEIGHT} $TARGET_FILE"
        log "INFO" "Executing: $RESIZE_CMD"
        $RESIZE_CMD
      else
        RESIZE_CMD="magick $SOURCE_FILE -resize ${OUTPUT_WIDTH}x${OUTPUT_HEIGHT}^ $TARGET_FILE"
        log "INFO" "Executing: $RESIZE_CMD"
        $RESIZE_CMD
      fi
      return 0;
    ;;
  *)
    return 1
    ;;
  esac

  return 0
}
