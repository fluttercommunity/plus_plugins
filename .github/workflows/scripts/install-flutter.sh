#!/bin/bash

# BRANCH=$1
# Temporal fix for https://github.com/fluttercommunity/plus_plugins/pull/3479
# Update when https://github.com/flutter/flutter/issues/163198 has a resolution
BRANCH="3.27.4"

git clone https://github.com/flutter/flutter.git --depth 1 -b $BRANCH _flutter
echo "$GITHUB_WORKSPACE/_flutter/bin" >> $GITHUB_PATH
