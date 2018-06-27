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
  printf "Usage: $0 [--help | -h] [--release <platform>| -r <platform>] [--all | -a] [--clear | -c]\n"
  printf "Automagically deploys release binaries for different platforms.\n\n"
  printf "  --release,  -r   specifies the platform: M for Mac OS X, W32 and W64 for Windows 32 and 64, L for Love and A for AppImage.\n"
  printf "  --lversion, -lv  if building an AppImage, you need to specify the last (not current) version of the game.\n"
  printf "  --all,      -a   deploys for all platforms, ignoring the -r option.\n"
  printf "  --clean,    -c   removes output files (use with care!). Ignores all tags above if used.\n"
  printf "  --help,     -h   display this help and exit\n\n"
  printf "Examples:\n"
  printf "  $0 --release A     Generates a Mac OS X binary in the build dir.\n"
  printf "  $0 -h              Outputs this help text.\n"
  printf "  $0 --clean         Removes the build directory and AppImage debris.\n"
  printf "  $0 -a -lv \"1.2.1\"  Generates binaries for all platforms inside the build dir.\n"
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
    $LOVE_RELEASE . "${PLATFORM_CMD[$q]}"
  fi
  cd ..
  printf "Done!\n"
  return 0
}

# Post-build.
function post_build_platform {
  _plt="$1"
  TMP_PATH="/tmp/MarvInc_deploy/"
  printf "Post-build for %s.\n" "${_plt}"
  if [ "${_plt}" == "W32" ]; then
    printf "Adding custom icon to Win32 build.\n"
    pushd .
    mkdir -p $TMP_PATH/win
    cp ./build/Marvellous_Inc-win32.zip $TMP_PATH/win/
    cp ./Marvellous_Inc.ico $TMP_PATH/win/
    cd $TMP_PATH/win
    unzip Marvellous_Inc-win32.zip
    cp ./Marvellous_Inc.ico ./Marvellous_Inc-win32/game.ico
    rm ./Marvellous_Inc-win32.zip
    zip Marvellous_Inc-win32.zip ./Marvellous_Inc-win32/ -r
    popd
    rm ./build/Marvellous_Inc-win32.zip
    cp $TMP_PATH/win/Marvellous_Inc-win32.zip ./build/
  elif [ "${_plt}" == "W64" ]; then
    printf "Adding custom icon to Win64 build.\n"
    pushd .
    mkdir -p $TMP_PATH/win
    cp ./build/Marvellous_Inc-win64.zip $TMP_PATH/win/
    cp ./Marvellous_Inc.ico $TMP_PATH/win/
    cd $TMP_PATH/win
    unzip Marvellous_Inc-win64.zip
    cp ./Marvellous_Inc.ico ./Marvellous_Inc-win64/game.ico
    rm Marvellous_Inc-win64.zip
    zip Marvellous_Inc-win64.zip ./Marvellous_Inc-win64/ -r
    popd
    rm ./build/Marvellous_Inc-win64.zip
    cp $TMP_PATH/win/Marvellous_Inc-win64.zip ./build/
  elif [ "${_plt}" == "M" ]; then
    printf "Adding custom icon to MAC OS X build.\n"
    pushd .
    mkdir -p $TMP_PATH/mac
    cp ./build/Marvellous_Inc-macos.zip $TMP_PATH/mac/
    cp ./Marvellous_Inc.icns $TMP_PATH/mac/
    cd $TMP_PATH/mac
    unzip Marvellous_Inc-macos.zip
    cp ./Marvellous_Inc.icns ./Marvellous_Inc.app/Contents/Resources/GameIcon.icns
    cp ./Marvellous_Inc.icns ./Marvellous_Inc.app/Contents/Resources/OS\ X\ AppIcon.icns
    rm Marvellous_Inc-macos.zip
    zip Marvellous_Inc-macos.zip ./Marvellous_Inc.app -r
    popd
    rm ./build/Marvellous_Inc-macos.zip
    cp $TMP_PATH/mac/Marvellous_Inc-macos.zip ./build/
  fi
  printf "Finished post-build.\n"
}

# Build AppImage.
function build_appimage {
  any_contains args "--lversion" "-lv"
  rval=$?
  if [ "$rval" -eq $NULL ]; then
    printf "You must specify the last (not current) game version when building an AppImage. Try:\n"
    printf "  $0 --help\n"
    return 3
  fi
  v=${args[$(( rval+1 ))]}
  printf "Last version: $v\n"
  LAST_URL="https://github.com/MarvellousSoft/MarvInc/releases/download/v${v}/Marvellous_Inc-x86_64.AppImage"
  APP_NAME="Marvellous_Inc-x86_64.AppImage"
  TMP_PATH="/tmp/MarvInc_deploy/AppImage/"
  printf "Creating temporary path at \"$TMP_PATH\"...\n"
  mkdir -p "$TMP_PATH"
  pushd .
  printf "Copying .love build to temp dir..."
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
  printf "Downloading latest AppImage Tool...\n"
  APP_TOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
  APP_TOOL_NAME="appimagetool-x86_64.AppImage"
  curl -L "$APP_TOOL_URL" -o "$APP_TOOL_NAME"
  chmod +x "$APP_TOOL_NAME"
  printf "Creating new AppImage...\n"
  ./"$APP_TOOL_NAME" squashfs-root
  BUILD_NAME="Marvellous_Inc-x86_64.AppImage"
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
