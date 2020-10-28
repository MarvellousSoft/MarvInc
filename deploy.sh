#!/bin/bash

NULL=255
LOVE_RELEASE='love-release -a MarvellousSoft -t Marvellous_Inc -u https://github.com/marvelloussoft/marvinc'

function exit_with_error {
  echo "Error at [${BASH_SOURCE[1]##*/}]->${FUNCNAME[1]}:${BASH_LINENO[0]}"
  exit 1
}

# Returns whether an array contains an element.
# Arguments: array element
# Returns: 1 if found, 0 otherwise.
function contains {
  local -n b=$1
  local e=$2
  local i=0
  for f in "${b[@]}"; do
    if [ "$f" == "$e" ]; then
      return $i
    fi
    i=$(( i+1 ))
  done
  return $NULL
}

# Returns whether an array contains any of the two elements.
# Arguments: array e1 e2
# Returns: 1 if found, 0 otherwise.
function any_contains {
  contains "$1" "$2"
  local r1=$?
  if [ "$r1" -ne $NULL ]; then
    return $r1
  fi
  contains "$1" "$3"
  local r2=$?
  if [ "$r2" -ne $NULL ]; then
    return $r2
  fi
  return $NULL
}

args=( "$@" )

any_contains args "--help" "-h"
rval=$?
if [ "${#args[@]}" -eq 0 ] || [ "$rval" -ne $NULL ]; then
  printf "Usage: %s [--help | -h] [--release <platform>| -r <platform>] [--all | -a] [--clear | -c] [--steam | -s]\n" "$0"
  printf "Automagically deploys release binaries for different platforms.\n\n"
  printf "  --release,  -r   specifies the platform: M for Mac OS X, W32 and W64 for Windows 32 and 64, L for Love, A for AppImage, and F for Flatpak.\n"
  printf "  --all,      -a   deploys for all platforms, ignoring the -r option.\n"
  printf "  --clean,    -c   removes output files (use with care!). Ignores all tags above if used.\n"
  printf "  --steam,    -s   builds the steam version of the binaries. Please have the sdk unzipped in this directory.\n"
  printf "  --help,     -h   display this help and exit\n"
  printf "  --prefix,   -p   changes love-release prefix (for old version compatibility)\n\n"
  printf "Examples:\n"
  printf "  %s --release A     Generates a Mac OS X binary in the build dir.\n" "$0"
  printf "  %s -h              Outputs this help text.\n" "$0"
  printf "  %s --clean         Removes the build directory and AppImage debris.\n" "$0"
  exit
fi

# Check for prefix.
any_contains args "--prefix" "-p"
rval=$?
if [ "$rval" -ne $NULL ]; then
  p=${args[$(( rval+1 ))]}
  printf "Prefix: %s\n" "$p"
  LOVE_RELEASE=$p/$LOVE_RELEASE
  printf "LOVE_RELEASE: %s" "$LOVE_RELEASE"
fi

# Clear.
any_contains args "--clean" "-c"
rval=$?
if [ "$rval" -ne $NULL ]; then
  rm ./build/ -rf
  rm /tmp/MarvInc_deploy/ -rf
  exit
fi

any_contains args "--steam" "-s"
STEAM=$?

if [ "$STEAM" -ne $NULL ] && [ ! -d ./sdk ]; then
  printf "Missing SteamWorks SDK on a Steam build. Please unzip it in this directory.\n"
  exit 1
fi

# Platforms.
declare -A PLATFORMS=( ["M"]=0 ["W32"]=1 ["W64"]=2 ["L"]=3 )
PLATFORM_CMD=("-M" "-W 32" "-W 64" " ")

# Build for some platform (except AppImage).
function build_platform {
  q=${PLATFORMS[$1]}
  if [ -z "$q" ]; then
    printf "Invalid platform. Try:\n"
    printf "  %s --help\n" "$0"
    return 2
  fi
  printf "Building release for platform %s...\n" "$1"
  cd ./marv/ || exit 1
  if [ "$1" == "L" ]; then
    $LOVE_RELEASE . || exit_with_error
  else
    $LOVE_RELEASE . "${PLATFORM_CMD[$q]}" || exit_with_error
  fi
  cd ..
  printf "Done!\n"
  return 0
}

# retuns latest release of given git repository
get_latest_release() {
  curl --fail --silent "https://api.github.com/repos/$1/releases/latest" |  # Get latest release from GitHub api
  grep '"tag_name":' |                                                      # Get tag line
  sed -E 's/.*"([^"]+)".*/\1/' || exit_with_error                           # Pluck JSON value
}

# Downloads correct luasteam lib for platform $1 into file $2
download_luasteam() {
  luasteam_v="v1.0.3"
  printf "LuaSteam version: %s\n" "${luasteam_v}"
  curl --fail -L "https://github.com/uspgamedev/luasteam/releases/download/${luasteam_v}/$1_$2" -o "$2" || exit_with_error
}

# Post-build.
function post_build_platform {
  _plt="$1"
  TMP_PATH="/tmp/MarvInc_deploy/"
  printf "Post-build for %s.\n" "${_plt}"
  if [ "${_plt}" == "W32" ] || [ "${_plt}" == "W64" ]; then
    if [ "${_plt}" == "W64" ]; then
      WIN=win64
    else
      WIN=win32
    fi
    printf "Adding custom icon to %s build.\n" "$WIN"
    pushd .
    mkdir -p $TMP_PATH/win || exit_with_error
    cp ./build/Marvellous_Inc-$WIN.zip $TMP_PATH/win/ || exit_with_error
    cp ./Marvellous_Inc.ico $TMP_PATH/win/ || exit_with_error
    if [ "$STEAM" -ne $NULL ]; then
      if [ "${_plt}" == "W64" ]; then
        SAPI_NAME=steam_api64.dll
        cp ./sdk/redistributable_bin/win64/$SAPI_NAME $TMP_PATH/win || exit_with_error
      else
        SAPI_NAME=steam_api.dll
        cp ./sdk/redistributable_bin/$SAPI_NAME $TMP_PATH/win || exit_with_error
      fi
    fi
    cd $TMP_PATH/win || exit_with_error
    rm -rf ./Marvellous_Inc-$WIN/ || exit_with_error
    unzip Marvellous_Inc-$WIN.zip || exit_with_error
    cp ./Marvellous_Inc.ico ./Marvellous_Inc-$WIN/game.ico || exit_with_error
    if [ "$STEAM" -ne $NULL ]; then
      download_luasteam "$WIN" "luasteam.dll" || exit_with_error
      printf "Copying luasteam.dll and %s to %s zip...\n" "$SAPI_NAME" "$WIN"
      cp ./$SAPI_NAME ./Marvellous_Inc-$WIN/ || exit_with_error
      cp ./luasteam.dll ./Marvellous_Inc-$WIN/ || exit_with_error
    fi
    rm ./Marvellous_Inc-$WIN.zip || exit_with_error
    zip Marvellous_Inc-$WIN.zip ./Marvellous_Inc-$WIN/ -r || exit_with_error
    popd || exit_with_error
    rm ./build/Marvellous_Inc-$WIN.zip
    cp $TMP_PATH/win/Marvellous_Inc-$WIN.zip ./build/ || exit_with_error
  elif [ "${_plt}" == "M" ]; then
    printf "Adding custom icon to MAC OS X build.\n"
    pushd .
    mkdir -p $TMP_PATH/mac
    if [ "$STEAM" -ne $NULL ]; then
      cp ./sdk/redistributable_bin/osx/libsteam_api.dylib $TMP_PATH/mac/ || exit_with_error
    fi
    cp ./build/Marvellous_Inc-macos.zip $TMP_PATH/mac/ || exit_with_error
    cp ./Marvellous_Inc.icns $TMP_PATH/mac/ || exit_with_error
    cd $TMP_PATH/mac || exit_with_error
    rm -rf ./Marvellous_Inc.app
    unzip Marvellous_Inc-macos.zip || exit_with_error
    cp ./Marvellous_Inc.icns ./Marvellous_Inc.app/Contents/Resources/GameIcon.icns || exit_with_error
    cp ./Marvellous_Inc.icns ./Marvellous_Inc.app/Contents/Resources/OS\ X\ AppIcon.icns || exit_with_error
    rm Marvellous_Inc-macos.zip
    if [ "$STEAM" -ne $NULL ]; then
      download_luasteam "osx" "luasteam.so"
      printf "Copying luasteam.so and libsteam_apy.dylib with MacOS App...\n"
      zip Marvellous_Inc-macos.zip -r ./Marvellous_Inc.app libsteam_api.dylib luasteam.so || exit_with_error
    else
      zip Marvellous_Inc-macos.zip -r ./Marvellous_Inc.app || exit_with_error
    fi
    popd || exit_with_error
    rm ./build/Marvellous_Inc-macos.zip
    cp $TMP_PATH/mac/Marvellous_Inc-macos.zip ./build/ || exit_with_error
  fi

  printf "Finished post-build.\n"
}

# Build AppImage.
function build_appimage {
  v=$(get_latest_release "MarvellousSoft/MarvInc")
  printf "Last version: %s\n" "$v"
  LAST_URL="https://github.com/MarvellousSoft/MarvInc/releases/download/${v}/Marvellous_Inc-x86_64.AppImage"
  APP_NAME="Marvellous_Inc-x86_64.AppImage"
  TMP_PATH="/tmp/MarvInc_deploy/AppImage/"
  BUILD_NAME="Marvellous_Inc-x86_64.AppImage"
  printf "Creating temporary path at \"%s\"...\n" "$TMP_PATH"
  mkdir -p "$TMP_PATH"
  if [ "$STEAM" -ne $NULL ]; then
    cp ./sdk/redistributable_bin/linux64/libsteam_api.so "${TMP_PATH}" || exit_with_error
  fi
  pushd .
  printf "Copying .love build to temp dir...\n"
  cp "./build/Marvellous_Inc.love" "$TMP_PATH"
  cd "$TMP_PATH" || exit_with_error
  printf "Downloading last built AppImage from repo...\n"
  curl --fail -L "$LAST_URL" -o "$APP_NAME" || exit_with_error
  printf "Adding run permission to AppImage...\n"
  chmod +x "$APP_NAME" || exit_with_error
  printf "Extracting AppImage...\n"
  ./"$APP_NAME" --appimage-extract || exit_with_error
  printf "Replacing old .love with new .love...\n"
  cp "./Marvellous_Inc.love" "./squashfs-root/MarvInc.love" || exit_with_error
  printf "Adding run permission to AppRun...\n"
  chmod +x ./squashfs-root/AppRun || exit_with_error
  if [ "$STEAM" -ne $NULL ]; then
    download_luasteam "linux64" "luasteam.so"
    printf "Copying luasteam.so and libsteam_api.so to AppImage...\n"
    cp ./libsteam_api.so "./squashfs-root/usr/lib/" || exit_with_error
    cp ./luasteam.so "./squashfs-root/" || exit_with_error
  fi
  printf "Downloading latest AppImage Tool...\n"
  APP_TOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
  APP_TOOL_NAME="appimagetool-x86_64.AppImage"
  curl --fail -L "$APP_TOOL_URL" -o "$APP_TOOL_NAME" || exit_with_error
  chmod +x "$APP_TOOL_NAME" || exit_with_error
  printf "Creating new AppImage...\n"
  ./"$APP_TOOL_NAME" squashfs-root || exit_with_error
  mv "Marvellous_Inc.-x86_64.AppImage" "$BUILD_NAME" || exit_with_error
  popd || exit_with_error
  cp "${TMP_PATH}${BUILD_NAME}" ./build/"$BUILD_NAME"
  printf "Done!\n"
  return 0
}

function build_flatpak {
  APP="io.itch.marvellous-inc"
  FLATPAK_ROOT="dist/flatpak"
  FLATPAK_BUILDDIR="/tmp/MarvInc_deploy/flatpak"
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" 

  # Make sure flathub is available so Freedesktop SDK can be installed
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || exit_with_error

  mkdir -p "${FLATPAK_BUILDDIR}"

  # https://docs.flatpak.org/de/latest/flatpak-builder-command-reference.html
  flatpak-builder --user \
                  --install-deps-from=flathub \
                  --state-dir="${FLATPAK_BUILDDIR}/.flatpak-builder" \
                  --force-clean \
                  "${FLATPAK_BUILDDIR}/_build" \
                  --repo="${FLATPAK_BUILDDIR}/_repo" \
                  "${SCRIPT_DIR}/dist/flatpak/${APP}.yml" || exit_with_error

  mkdir -p ./build

  flatpak build-bundle \
          --arch=x86_64 \
          "${FLATPAK_BUILDDIR}/_repo" \
          "build/Marvellous_Inc-x86_64.flatpak" \
          "${APP}" \
          stable || exit_with_error

  printf "Done!\n"
  return 0
}

# Build all.
any_contains args "--all" "-a"
rval=$?
if [ "$rval" -ne $NULL ]; then
  for q in "${!PLATFORMS[@]}"; do
    _plt="$q"
    build_platform "${_plt}"
    post_build_platform "${_plt}"
    rval=$?
    if [ "$rval" -ne 0 ]; then
      printf "Error: %s\n" "$rval"
      exit $rval
    fi
  done
  build_appimage
  build_flatpak
  rval=$?
  if [ "$rval" -ne 0 ]; then
    printf "Error: %s\n" "$rval"
    exit $rval
  fi
  exit 0
fi


# Build a particular platform release.
any_contains args "--release" "-r"
rval=$?
if [ "$rval" -eq $NULL ]; then
  printf "You must specify a platform. Try:\n"
  printf "  %s --help\n" "$0"
  exit 1
fi

# Extract platform.
p=${args[$(( rval+1 ))]}

# AppImage.
if [ "$p" == "A" ]; then
  build_platform "L"
  build_appimage
  rval=$?
  exit $rval
elif [ "$p" == "F" ]; then
  build_flatpak
# Any other.
else
  build_platform "$p"
  post_build_platform "$p"
  rval=$?
  exit $rval
fi
