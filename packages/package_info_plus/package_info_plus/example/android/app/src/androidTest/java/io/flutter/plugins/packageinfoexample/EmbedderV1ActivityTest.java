// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.packageinfoexample;

import androidx.test.rule.ActivityTestRule;

import dev.flutter.plugins.integration_test.FlutterTestRunner;

import org.junit.Rule;
import org.junit.runner.RunWith;

@RunWith(FlutterTestRunner.class)
public class EmbedderV1ActivityTest {
    @Rule
    public ActivityTestRule<EmbedderV1Activity> rule =
            new ActivityTestRule<>(EmbedderV1Activity.class);
}
