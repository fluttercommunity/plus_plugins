// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.connectivity;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * The handler receives {@link MethodCall}s from the UIThread, gets the related information from
 * a @{@link Connectivity}, and then send the result back to the UIThread through the {@link
 * MethodChannel.Result}.
 */
class ConnectivityMethodChannelHandler implements MethodChannel.MethodCallHandler {

  private final Connectivity connectivity;

  /**
   * Construct the ConnectivityMethodChannelHandler with a {@code connectivity}. The {@code
   * connectivity} must not be null.
   */
  ConnectivityMethodChannelHandler(Connectivity connectivity) {
    assert (connectivity != null);
    this.connectivity = connectivity;
  }

  @Override
  public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
    if ("check".equals(call.method)) {
      result.success(connectivity.getNetworkType());
    } else {
      result.notImplemented();
    }
  }
}
