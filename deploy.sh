#!/bin/bash

NULL=255
LOVE_RELEASE='love-release -a MarvellousSoft -t Marvellous_Inc -u https://github.com/marvelloussoft/marvinc'

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
    let i=i+1
  done
  return $NULL
}

# Returns whether an array contains any of the two elements.
# Arguments: array e1 e2
# Returns: 1 if found, 0 otherwise.
function any_contains {
  contains $1 $2
  local r1=$?
  if [ "$r1" -ne $NULL ]; then
    return $r1
  fi
  contains $1 $3
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
  printf "Usage: $0 [--help | -h] [--release <platform>| -r <platform>] [--all | -a] [--clear | -c] [--steam | -s]\n"
  printf "Automagically deploys release binaries for different platforms.\n\n"
  printf "  --release,  -r   specifies the platform: M for Mac OS X, W32 and W64 for Windows 32 and 64, L for Love and A for AppImage.\n"
  printf "  --all,      -a   deploys for all platforms, ignoring the -r option.\n"
  printf "  --clean,    -c   removes output files (use with care!). Ignores all tags above if used.\n"
  printf "  --steam,    -s   builds the steam version of the binaries. Please have the sdk unzipped in this directory.\n"
  printf "  --help,     -h   display this help and exit\n\n"
  printf "Examples:\n"
  printf "  $0 --release A     Generates a Mac OS X binary in the build dir.\n"
  printf "  $0 -h              Outputs this help text.\n"
  printf "  $0 --clean         Removes the build directory and AppImage debris.\n"
  exit
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
    printf "  $0 --help\n"
    return 2
  fi
  printf "Building release for platform $1...\n"
  cd ./marv/
  if [ "$1" == "L" ]; then
    $LOVE_RELEASE .
  else
    $LOVE_RELEASE . ${PLATFORM_CMD[$q]}
  fi
  cd ..
  printf "Done!\n"
  return 0
}

# retuns latest release of given git repository
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
  grep '"tag_name":' |                                            # Get tag line
  sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Downloads correct luasteam lib for platform $1 into file $2
download_luasteam() {
  luasteam_v="v1.0.0"
  printf "LuaSteam version: ${luasteam_v}\n"
  curl -L "https://github.com/uspgamedev/luasteam/releases/download/${luasteam_v}/$1_$2" -o "$2"
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
    printf "Adding custom icon to $WIN build.\n"
    pushd .
    mkdir -p $TMP_PATH/win
    cp ./build/Marvellous_Inc-$WIN.zip $TMP_PATH/win/
    cp ./Marvellous_Inc.ico $TMP_PATH/win/
    if [ "$STEAM" -ne $NULL ]; then
      if [ "${_plt}" == "W64" ]; then
        SAPI_NAME=steam_api64.dll
        cp ./sdk/redistributable_bin/win64/$SAPI_NAME $TMP_PATH/win
      else
        SAPI_NAME=steam_api.dll
        cp ./sdk/redistributable_bin/$SAPI_NAME $TMP_PATH/win
      fi
    fi
    cd $TMP_PATH/win
    rm -rf ./Marvellous_Inc-$WIN/
    unzip Marvellous_Inc-$WIN.zip
    cp ./Marvellous_Inc.ico ./Marvellous_Inc-$WIN/game.ico
    if [ "$STEAM" -ne $NULL ]; then
      download_luasteam "$WIN" "luasteam.dll"
      printf "Copying luasteam.dll and $SAPI_NAME to $WIN zip...\n"
      cp ./$SAPI_NAME ./Marvellous_Inc-$WIN/
      cp ./luasteam.dll ./Marvellous_Inc-$WIN/
    fi
    rm ./Marvellous_Inc-$WIN.zip
    zip Marvellous_Inc-$WIN.zip ./Marvellous_Inc-$WIN/ -r
    popd
    rm ./build/Marvellous_Inc-$WIN.zip
    cp $TMP_PATH/win/Marvellous_Inc-$WIN.zip ./build/
  elif [ "${_plt}" == "M" ]; then
    if [ "$STEAM" -ne $NULL ]; then
      cp ./sdk/redistributable_bin/osx32/libsteam_api.dylib $TMP_PATH/mac/
    fi
    printf "Adding custom icon to MAC OS X build.\n"
    pushd .
    mkdir -p $TMP_PATH/mac
    cp ./build/Marvellous_Inc-macosx.zip $TMP_PATH/mac/
    cp ./Marvellous_Inc.icns $TMP_PATH/mac/
    cd $TMP_PATH/mac
    rm -rf ./Marvellous_Inc.app
    unzip Marvellous_Inc-macosx.zip
    cp ./Marvellous_Inc.icns ./Marvellous_Inc.app/Contents/Resources/GameIcon.icns
    cp ./Marvellous_Inc.icns ./Marvellous_Inc.app/Contents/Resources/OS\ X\ AppIcon.icns
    rm Marvellous_Inc-macosx.zip
    if [ "$STEAM" -ne $NULL ]; then
      download_luasteam "osx" "luasteam.so"
      printf "Copying luasteam.so and libsteam_apy.dylib with MacOS App...\n"
      zip Marvellous_Inc-macosx.zip -r ./Marvellous_Inc.app libsteam_api.dylib luasteam.so
    else
      zip Marvellous_Inc-macosx.zip -r ./Marvellous_Inc.app
    fi
    popd
    rm ./build/Marvellous_Inc-macosx.zip
    cp $TMP_PATH/mac/Marvellous_Inc-macosx.zip ./build/
  fi

  printf "Finished post-build.\n"
}

# Build AppImage.
function build_appimage {
  v=`get_latest_release "MarvellousSoft/MarvInc"`
  printf "Last version: $v\n"
  LAST_URL="https://github.com/MarvellousSoft/MarvInc/releases/download/${v}/Marvellous_Inc-x86_64.AppImage"
  APP_NAME="Marvellous_Inc-x86_64.AppImage"
  TMP_PATH="/tmp/MarvInc_deploy/AppImage/"
  BUILD_NAME="Marvellous_Inc-x86_64.AppImage"
  printf "Creating temporary path at \"$TMP_PATH\"...\n"
  mkdir -p "$TMP_PATH"
  if [ "$STEAM" -ne $NULL ]; then
    cp ./sdk/redistributable_bin/linux64/libsteam_api.so "${TMP_PATH}"
  fi
  pushd .
  printf "Copying .love build to temp dir...\n"
  cp "./build/Marvellous_Inc.love" "$TMP_PATH"
  cd "$TMP_PATH"
  printf "Downloading last built AppImage from repo...\n"
  curl -L "$LAST_URL" -o "$APP_NAME"
  printf "Adding run permission to AppImage...\n"
  chmod +x "$APP_NAME"
  printf "Extracting AppImage...\n"
  ./"$APP_NAME" --appimage-extract
  printf "Replacing old .love with new .love...\n"
  cp "./Marvellous_Inc.love" "./squashfs-root/MarvInc.love"
  printf "Adding run permission to AppRun...\n"
  chmod +x ./squashfs-root/AppRun
  if [ "$STEAM" -ne $NULL ]; then
    download_luasteam "linux64" "luasteam.so"
    printf "Copying luasteam.so and libsteam_api.so to AppImage...\n"
    cp ./libsteam_api.so "./squashfs-root/usr/lib/"
    cp ./luasteam.so "./squashfs-root/"
    BUILD_NAME="Marvellous_Inc-x86_64-Steam.AppImage"
  fi
  printf "Downloading latest AppImage Tool...\n"
  APP_TOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
  APP_TOOL_NAME="appimagetool-x86_64.AppImage"
  curl -L "$APP_TOOL_URL" -o "$APP_TOOL_NAME"
  chmod +x "$APP_TOOL_NAME"
  printf "Creating new AppImage...\n"
  ./"$APP_TOOL_NAME" squashfs-root
  mv "Marvellous_Inc.-x86_64.AppImage" "$BUILD_NAME"
  popd
  cp "${TMP_PATH}${BUILD_NAME}" ./build/"$BUILD_NAME"
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
      printf "Error: $rval\n"
      exit $rval
    fi
  done
  build_appimage
  rval=$?
  if [ "$rval" -ne 0 ]; then
    printf "Error: $rval\n"
    exit $rval
  fi
  exit 0
fi


# Build a particular platform release.
any_contains args "--release" "-r"
rval=$?
if [ "$rval" -eq $NULL ]; then
  printf "You must specify a platform. Try:\n"
  printf "  $0 --help\n"
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
# Any other.
else
  build_platform "$p"
  post_build_platform "$p"
  rval=$?
  exit $rval
fi
