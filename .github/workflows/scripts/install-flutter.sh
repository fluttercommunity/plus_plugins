#!/bin/bash

BRANCH=$1

git clone https://github.com/flutter/flutter.git --depth 1 -b $BRANCH _flutter
echo "$GITHUB_WORKSPACE/_flutter/bin" >> "$GITHUB_PATH"

echo "Installed Flutter to $GITHUB_WORKSPACE/_flutter"
echo "Path: $GITHUB_PATH"

echo "Flutter version:"
flutter --version
