// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.connectivity;

import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Build;

/** Reports connectivity related information such as connectivity type and wifi information. */
public class Connectivity {
  static final String CONNECTIVITY_NONE = "none";
  static final String CONNECTIVITY_WIFI = "wifi";
  static final String CONNECTIVITY_MOBILE = "mobile";
  static final String CONNECTIVITY_ETHERNET = "ethernet";
  private ConnectivityManager connectivityManager;

  public Connectivity(ConnectivityManager connectivityManager) {
    this.connectivityManager = connectivityManager;
  }

  String getNetworkType() {
    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      Network network = connectivityManager.getActiveNetwork();
      NetworkCapabilities capabilities = connectivityManager.getNetworkCapabilities(network);
      if (capabilities == null) {
        return CONNECTIVITY_NONE;
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
        return CONNECTIVITY_WIFI;
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
        return CONNECTIVITY_ETHERNET;
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
        return CONNECTIVITY_MOBILE;
      }
    }

    return getNetworkTypeLegacy();
  }

  @SuppressWarnings("deprecation")
  private String getNetworkTypeLegacy() {
    // handle type for Android versions less than Android 9
    android.net.NetworkInfo info = connectivityManager.getActiveNetworkInfo();
    if (info == null || !info.isConnected()) {
      return "none";
    }
    int type = info.getType();
    switch (type) {
      case ConnectivityManager.TYPE_ETHERNET:
        return "ethernet";
      case ConnectivityManager.TYPE_WIFI:
      case ConnectivityManager.TYPE_WIMAX:
        return "wifi";
      case ConnectivityManager.TYPE_MOBILE:
      case ConnectivityManager.TYPE_MOBILE_DUN:
      case ConnectivityManager.TYPE_MOBILE_HIPRI:
        return "mobile";
      default:
        return "none";
    }
  }

  public ConnectivityManager getConnectivityManager() {
    return connectivityManager;
  }
}
