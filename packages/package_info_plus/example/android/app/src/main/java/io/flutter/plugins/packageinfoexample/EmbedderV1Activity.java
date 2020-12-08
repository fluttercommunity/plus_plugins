// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.packageinfoexample;

import android.os.Bundle;
import dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin;
import io.flutter.app.FlutterActivity;

public class EmbedderV1Activity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    PackageInfoPlugin.registerWith(
        registrarFor("dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin"));
  }
}
