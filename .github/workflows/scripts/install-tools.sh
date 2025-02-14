#!/bin/bash

set -e

echo "Path: $PATH"
ls -l "$GITHUB_WORKSPACE/_flutter/bin"

echo "Flutter version:"
flutter --version

flutter config --no-analytics
flutter pub global activate melos 6.3.2

echo $HOME
echo $GITHUB_WORKSPACE
echo $GITHUB_PATH

echo "$HOME/.pub-cache/bin" >> $GITHUB_PATH
echo "$HOME/AppData/Local/Pub/Cache/bin" >> $GITHUB_PATH
echo "$GITHUB_WORKSPACE/_flutter/.pub-cache/bin" >> $GITHUB_PATH
echo "$GITHUB_WORKSPACE/_flutter/bin/cache/dart-sdk/bin" >> $GITHUB_PATH
