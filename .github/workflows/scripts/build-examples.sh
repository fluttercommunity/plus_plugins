#!/bin/bash

DEFAULT_TARGET="./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart"

ACTION=$1
TARGET_FILE=${2:-$DEFAULT_TARGET}

melos bootstrap --scope="$PLUGIN_SCOPE"

if [ "$ACTION" == "android" ]
then
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build apk $FLUTTER_COMMAND_FLAGS --debug --target="$TARGET_FILE" --dart-define=CI=true --no-android-gradle-daemon
  MELOS_EXIT_CODE=$?
  pkill dart || true
  pkill java || true
  exit $MELOS_EXIT_CODE
fi

if [ "$ACTION" == "ios" ]
then
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build ios $FLUTTER_COMMAND_FLAGS --no-codesign --simulator --debug --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "macos" ]
then
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build macos $FLUTTER_COMMAND_FLAGS --debug --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "linux" ]
then
  sudo apt-get install ninja-build
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build linux $FLUTTER_COMMAND_FLAGS --debug --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "windows" ]
then
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build windows $FLUTTER_COMMAND_FLAGS --debug --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "web" ]
then
  melos exec -c 1 --scope="$PLUGIN_EXAMPLE_SCOPE" \
    -- flutter build web $FLUTTER_COMMAND_FLAGS --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi
