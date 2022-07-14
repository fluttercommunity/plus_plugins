#!/bin/bash

ACTION=$1

# At the moment, only Android integration tests run
if [ "$ACTION" == "android" ]
then
  # Sleep to allow emulator to settle.
  sleep 15
  melos exec -c 1 --dir-exists="./integration_test" -- \
    "flutter test ./integration_test/MELOS_PARENT_PACKAGE_NAME_test.dart --dart-define=CI=true"
fi
