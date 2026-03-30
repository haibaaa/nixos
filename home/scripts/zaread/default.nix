{pkgs, ...}: let
  runtimeDeps = with pkgs; [
    zathura # default reader
    file # mime-type detection
    libreoffice # soffice - office/spreadsheet/presentation converter
    calibre # ebook-convert - mobi converter
    typst # typst compiler
    # md2pdf is not in nixpkgs; use pandoc + weasyprint as a drop-in replacement
    # and override MD_CMD in ~/.config/zaread/zareadrc if needed
    pandoc
    python3Packages.weasyprint
  ];

  zaread-unwrapped = pkgs.writeShellScriptBin "zaread" ''
    ## zaread - a simple script created by paoloap.

    # Exit codes:
    #   1 - usage error, missing file, or missing dependency
    #   2 - unsupported file format
    #   3 - conversion failed

    # zaread cache path
    ZA_CACHE_DIR="''${XDG_CACHE_HOME:-"$HOME"/.cache}/zaread/"
    # zaread config path
    ZA_CONFIG="''${XDG_CONFIG_HOME:-"$HOME"/.config}/zaread/zareadrc"

    # Default reader
    READER="zathura"

    # Default converters
    MOBI_CMD="ebook-convert"
    OFFICE_CMD="soffice"
    # md2pdf is not in nixpkgs; pandoc is used as a drop-in replacement.
    # Override MD_CMD/MD_ARG in zareadrc if you prefer something else.
    MD_CMD="pandoc"
    TYPST_CMD="typst"
    TYPST_ARG="compile"
    MD_ARG="--pdf-engine=weasyprint -o"
    MOBI_ARG=""
    OFFICE_ARG=""

    # Verbose output (override with -v flag or set in config)
    VERBOSE=0

    # Override any of the above via config file
    # shellcheck disable=SC1090
    [ -f "$ZA_CONFIG" ] && . "$ZA_CONFIG"

    # Create cache dir if needed
    [ ! -d "$ZA_CACHE_DIR" ] && mkdir -p "$ZA_CACHE_DIR"

    log() {
      if [ "$VERBOSE" -eq 1 ]; then
        echo "$@"
      fi
    }

    err() {
      echo "zaread: $*" >&2
    }

    usage() {
      echo "Usage: zaread [-v] [-c] <file>" >&2
    }

    while getopts "vhc" opt; do
      case "$opt" in
      v) VERBOSE=1 ;;
      c)
        if [ -d "$ZA_CACHE_DIR" ]; then
          rm -rf "''${ZA_CACHE_DIR:?}"/*
          echo "Cache cleared: $ZA_CACHE_DIR"
        else
          echo "No cache directory found."
        fi
        exit 0
        ;;
      h) usage; exit 0 ;;
      *) usage; exit 1 ;;
      esac
    done
    shift $((OPTIND - 1))

    if [ "$#" -eq 0 ]; then
      err "no file specified"
      usage
      exit 1
    fi

    if [ "$#" -ne 1 ]; then
      err "expected one file, got $#"
      exit 1
    fi

    path="$1"

    if [ ! -f "$path" ]; then
      err "file not found: $path"
      exit 1
    fi

    if [ ! -r "$path" ]; then
      err "file not readable: $path"
      exit 1
    fi

    if ! command -v "$READER" >/dev/null; then
      err "$READER is not in PATH"
      exit 1
    fi

    log "Reader: $READER"

    ## Resolve absolute file path

    file="$(basename "$path")"
    log "File: $file"

    case "$path" in
    /*)
      directory="$(dirname "$path")"
      ;;
    *)
      directory="''${PWD}/$(dirname "$path")"
      ;;
    esac

    log "Directory: $directory"

    # Detect MIME type
    file_mt="$(file --mime-type "$directory/$file")"
    file_mt="''${file_mt#*: }"
    log "MIME type: $file_mt"

    # Cache key: CRC_BYTECOUNT_filename.pdf
    # Sanitize filename portion to avoid slashes/spaces in cache path
    pdffile="$(cksum "$directory/$file" | awk '{gsub(/[^a-zA-Z0-9._-]/, "_", $3); print $1 "_" $2 "_" $3 ".pdf"}')"
    log "Cache file: $pdffile"

    file_converter=""

    # Check for cached conversion first
    if [ -f "$ZA_CACHE_DIR/$pdffile" ]; then
      file_converter="none_converted"
    else
      case "$file_mt" in
      "application/pdf" | "image/vnd.djvu" | "application/epub+zip")
        file_converter="none_original"
        ;;
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" | \
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" | \
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" | \
        "application/msword" | \
        "application/vnd.ms-excel" | \
        "application/vnd.ms-powerpoint" | \
        "application/vnd.oasis.opendocument.text" | \
        "application/vnd.oasis.opendocument.spreadsheet" | \
        "application/vnd.oasis.opendocument.presentation" | \
        "text/rtf" | \
        "text/csv")
        file_converter="$OFFICE_CMD"
        ;;
      "application/octet-stream" | \
        "application/x-mobipocket-ebook")
        case "$file" in
        *.mobi)
          file_converter="$MOBI_CMD"
          ;;
        esac
        ;;
      # file(1) reports macro-enabled Office formats as application/zip
      "application/zip")
        case "$file" in
        *.xlsm | *.xlsb | *.docm | *.pptm | *.ppsx | *.dotx)
          file_converter="$OFFICE_CMD"
          ;;
        esac
        ;;
      # file(1) sometimes reports markdown/typst as C, ObjC, or Python source
      "text/plain" | \
        "text/x-c" | \
        "text/x-objective-c" | \
        "text/x-script.python")
        case "$file" in
        *.md)
          file_converter="$MD_CMD"
          ;;
        *.typ)
          file_converter="$TYPST_CMD"
          ;;
        esac
        ;;
      esac
    fi

    case "$file_converter" in
    "")
      err "unsupported format: $file_mt"
      exit 2
      ;;
    "none_original")
      log "Opening directly"
      "$READER" "$directory/$file"
      ;;
    "none_converted")
      log "Opening from cache"
      "$READER" "$ZA_CACHE_DIR/$pdffile"
      ;;
    *)
      if ! command -v "$file_converter" >/dev/null; then
        err "$file_converter is not in PATH (needed to convert $file)"
        exit 1
      fi
      log "Converting $file with $file_converter"
      case "$file_converter" in
      "$OFFICE_CMD")
        # OFFICE_ARG intentionally unquoted to allow multi-word values
        # shellcheck disable=SC2086
        if ! "$OFFICE_CMD" $OFFICE_ARG --convert-to pdf "$directory/$file" --outdir "$ZA_CACHE_DIR"; then
          err "conversion failed: $OFFICE_CMD $file"
          exit 3
        fi
        # soffice names output by replacing/appending .pdf;
        # handle dotfiles with and without extensions
        case "$file" in
        .*.*)
          tmpfile="''${file%.*}.pdf"
          ;;
        .*)
          tmpfile="$file.pdf"
          ;;
        *)
          tmpfile="''${file%.*}.pdf"
          ;;
        esac
        mv "$ZA_CACHE_DIR/$tmpfile" "$ZA_CACHE_DIR/$pdffile"
        ;;
      "$MOBI_CMD")
        # MOBI_ARG intentionally unquoted
        # shellcheck disable=SC2086
        if ! "$MOBI_CMD" $MOBI_ARG "$directory/$file" "$ZA_CACHE_DIR/$pdffile"; then
          err "conversion failed: $MOBI_CMD $file"
          exit 3
        fi
        ;;
      "$MD_CMD")
        # MD_ARG intentionally unquoted; pandoc usage: pandoc input --pdf-engine=x -o output
        # shellcheck disable=SC2086
        if ! "$MD_CMD" "$directory/$file" $MD_ARG "$ZA_CACHE_DIR/$pdffile"; then
          err "conversion failed: $MD_CMD $file"
          exit 3
        fi
        ;;
      "$TYPST_CMD")
        # shellcheck disable=SC2086
        if ! "$TYPST_CMD" $TYPST_ARG "$directory/$file" "$ZA_CACHE_DIR/$pdffile"; then
          err "conversion failed: $TYPST_CMD $file"
          exit 3
        fi
        log "Opening converted typst file"
        "$READER" "$ZA_CACHE_DIR/$pdffile"
        ;;
      esac
      log "Opening converted file"
      "$READER" "$ZA_CACHE_DIR/$pdffile"
      ;;
    esac
  '';
in {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "zaread";
      paths = [zaread-unwrapped];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/zaread \
          --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps}
      '';
    })
  ];
}
