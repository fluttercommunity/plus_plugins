#!/bin/bash

set -e

DEFAULT_TARGET="./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart"

ACTION=$1
TARGET_FILE=${2:-$DEFAULT_TARGET}

if [ "$ACTION" == "android" ]
then
  melos bootstrap --scope="$PLUGIN_SCOPE"
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build apk $FLUTTER_COMMAND_FLAGS --debug --target="$TARGET_FILE" --dart-define=CI=true --no-android-gradle-daemon
  MELOS_EXIT_CODE=$?
  pkill dart || true
  pkill java || true
  exit $MELOS_EXIT_CODE
fi

if [ "$ACTION" == "ios" ]
then
  melos bootstrap --scope="$PLUGIN_SCOPE"
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build ios $FLUTTER_COMMAND_FLAGS --no-codesign --simulator --debug --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "macos" ]
then
  melos bootstrap --scope="$PLUGIN_SCOPE"
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build macos $FLUTTER_COMMAND_FLAGS --debug --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "linux" ]
then
  melos bootstrap --scope="$PLUGIN_SCOPE"
  sudo apt-get update
  sudo apt-get install ninja-build libgtk-3-dev
  flutter doctor -v
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build linux $FLUTTER_COMMAND_FLAGS --debug --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "windows" ]
then
  melos.bat bootstrap --scope="$PLUGIN_SCOPE"
  melos.bat exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build windows $FLUTTER_COMMAND_FLAGS --debug --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "web" ]
then
  melos bootstrap --scope="$PLUGIN_SCOPE"
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build web $FLUTTER_COMMAND_FLAGS --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi
