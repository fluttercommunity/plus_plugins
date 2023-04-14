#!/bin/bash

set -e

ACTION=$1
SCOPE=$2

if [ "$ACTION" == "android" ]
then
  melos exec -c 1 --scope="$SCOPE" --dir-exists="./integration_test" -- \
    "flutter test ./integration_test/MELOS_PARENT_PACKAGE_NAME_test.dart --dart-define=CI=true"
fi

if [ "$ACTION" == "linux" ]
then
  sudo apt-get update
  sudo apt-get install ninja-build libgtk-3-dev
  # Testrunner is headless. Required create virtual display for the linux tests to run.
  export DISPLAY=:99
  sudo Xvfb -ac :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &
  melos exec -c 1 --scope="$SCOPE" --dir-exists="./integration_test" -- \
  "flutter test -d linux ./integration_test/MELOS_PARENT_PACKAGE_NAME_test.dart --dart-define=CI=true"
fi

if [ "$ACTION" == "windows" ]
then
  melos.bat exec -c 1 --scope="$SCOPE" --dir-exists="./integration_test" -- \
    "flutter test -d windows ./integration_test/MELOS_PARENT_PACKAGE_NAME_test.dart --dart-define=CI=true"
fi

if [ "$ACTION" == "macos" ]
then
  melos exec -c 1 --scope="$SCOPE" --dir-exists="./integration_test" -- \
    "flutter test -d macos ./integration_test/MELOS_PARENT_PACKAGE_NAME_test.dart --dart-define=CI=true"
fi

if [ "$ACTION" == "ios" ]
then
  melos exec -c 1 --scope="$SCOPE" --dir-exists="./integration_test" -- \
    "flutter test ./integration_test/MELOS_PARENT_PACKAGE_NAME_test.dart --dart-define=CI=true"
fi

if [ "$ACTION" == "web" ]
then
  melos exec -c 1 --scope="$SCOPE" --dir-exists="./integration_test" -- \
    "flutter drive -d chrome --driver ./integration_test/driver.dart --target ./integration_test/MELOS_PARENT_PACKAGE_NAME_web_test.dart --dart-define=CI=true"
fi
