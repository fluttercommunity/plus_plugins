// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.connectivity;

import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Build;
import java.util.ArrayList;
import java.util.List;

/** Reports connectivity related information such as connectivity type and wifi information. */
public class Connectivity {
  static final String CONNECTIVITY_NONE = "none";
  static final String CONNECTIVITY_WIFI = "wifi";
  static final String CONNECTIVITY_MOBILE = "mobile";
  static final String CONNECTIVITY_ETHERNET = "ethernet";
  static final String CONNECTIVITY_BLUETOOTH = "bluetooth";
  static final String CONNECTIVITY_VPN = "vpn";
  static final String CONNECTIVITY_OTHER = "other";
  private final ConnectivityManager connectivityManager;

  public Connectivity(ConnectivityManager connectivityManager) {
    this.connectivityManager = connectivityManager;
  }

  List<String> getNetworkTypes() {
    List<String> types = new ArrayList<>();
    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      Network network = connectivityManager.getActiveNetwork();
      NetworkCapabilities capabilities = connectivityManager.getNetworkCapabilities(network);
      if (capabilities == null
          || !capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)) {
        types.add(CONNECTIVITY_NONE);
        return types;
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
          || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI_AWARE)) {
        types.add(CONNECTIVITY_WIFI);
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
        types.add(CONNECTIVITY_ETHERNET);
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) {
        types.add(CONNECTIVITY_VPN);
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
        types.add(CONNECTIVITY_MOBILE);
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_BLUETOOTH)) {
        types.add(CONNECTIVITY_BLUETOOTH);
      }
      if (types.isEmpty()
          && capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)) {
        types.add(CONNECTIVITY_OTHER);
      }
      if (types.isEmpty()) {
        types.add(CONNECTIVITY_NONE);
      }
    } else {
      // For legacy versions, return a single type as before or adapt similarly if multiple types
      // need to be supported
      return getNetworkTypesLegacy();
    }

    return types;
  }

  @SuppressWarnings("deprecation")
  private List<String> getNetworkTypesLegacy() {
    // handle type for Android versions less than Android 6
    android.net.NetworkInfo info = connectivityManager.getActiveNetworkInfo();
    List<String> types = new ArrayList<>();
    if (info == null || !info.isConnected()) {
      types.add(CONNECTIVITY_NONE);
      return types;
    }
    int type = info.getType();
    switch (type) {
      case ConnectivityManager.TYPE_BLUETOOTH:
        types.add(CONNECTIVITY_BLUETOOTH);
        break;
      case ConnectivityManager.TYPE_ETHERNET:
        types.add(CONNECTIVITY_ETHERNET);
        break;
      case ConnectivityManager.TYPE_WIFI:
      case ConnectivityManager.TYPE_WIMAX:
        types.add(CONNECTIVITY_WIFI);
        break;
      case ConnectivityManager.TYPE_VPN:
        types.add(CONNECTIVITY_VPN);
        break;
      case ConnectivityManager.TYPE_MOBILE:
      case ConnectivityManager.TYPE_MOBILE_DUN:
      case ConnectivityManager.TYPE_MOBILE_HIPRI:
        types.add(CONNECTIVITY_MOBILE);
        break;
      default:
        types.add(CONNECTIVITY_OTHER);
    }
    return types;
  }

  public ConnectivityManager getConnectivityManager() {
    return connectivityManager;
  }
}
