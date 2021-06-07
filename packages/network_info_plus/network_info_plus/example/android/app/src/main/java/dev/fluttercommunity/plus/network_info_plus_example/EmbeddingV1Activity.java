// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.network_info_plus_example;

import android.os.Bundle;
import dev.fluttercommunity.plus.network_info.NetworkInfoPlusPlugin;
import io.flutter.app.FlutterActivity;

public class EmbeddingV1Activity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NetworkInfoPlusPlugin.registerWith(
        registrarFor("dev.fluttercommunity.plus.network_info.NetworkPlusPlugin"));
  }
}
