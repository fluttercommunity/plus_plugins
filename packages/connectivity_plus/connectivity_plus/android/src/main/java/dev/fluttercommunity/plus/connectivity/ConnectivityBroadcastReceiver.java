// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.connectivity;

import static dev.fluttercommunity.plus.connectivity.Connectivity.CONNECTIVITY_NONE;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import io.flutter.plugin.common.EventChannel;
import java.util.List;

/**
 * The ConnectivityBroadcastReceiver receives the connectivity updates and send them to the UIThread
 * through an {@link EventChannel.EventSink}
 *
 * <p>Use {@link
 * io.flutter.plugin.common.EventChannel#setStreamHandler(io.flutter.plugin.common.EventChannel.StreamHandler)}
 * to set up the receiver.
 */
public class ConnectivityBroadcastReceiver extends BroadcastReceiver
    implements EventChannel.StreamHandler {
  private final Context context;
  private final Connectivity connectivity;
  private EventChannel.EventSink events;
  private final Handler mainHandler = new Handler(Looper.getMainLooper());
  private ConnectivityManager.NetworkCallback networkCallback;
  public static final String CONNECTIVITY_ACTION = "android.net.conn.CONNECTIVITY_CHANGE";

  public ConnectivityBroadcastReceiver(Context context, Connectivity connectivity) {
    this.context = context;
    this.connectivity = connectivity;
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    this.events = events;
    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      networkCallback =
          new ConnectivityManager.NetworkCallback() {
            @Override
            public void onAvailable(Network network) {
              // onAvailable is called when the phone switches to a new network
              // e.g. the phone was offline and gets wifi connection
              // or the phone was on wifi and now switches to mobile.
              // The plugin sends the current capability connection to the users.
              sendEvent(connectivity.getCapabilitiesFromNetwork(network));
            }

            @Override
            public void onCapabilitiesChanged(
                Network network, NetworkCapabilities networkCapabilities) {
              // This callback is called multiple times after a call to onAvailable
              // this also causes multiple callbacks to the Flutter layer.
              sendEvent(connectivity.getCapabilitiesList(networkCapabilities));
            }

            @Override
            public void onLost(Network network) {
              // This callback is called when a capability is lost.

              // e.g. user disconnected from wifi or disabled mobile data.
              // If a user switches from wifi to mobile,
              // onLost is called (for wifi),

              // then onAvailable is called afterwards (for mobile).
              // Meaning the user receives [wifi] -> [none] -> [mobile]

              // If no other connectivity is present, onAvailable will not be called,
              // and onLost is the only event that will happen.
              // i.e. the user will only receive [wifi] -> [none]
              sendEvent(List.of(CONNECTIVITY_NONE));
            }
          };
      connectivity.getConnectivityManager().registerDefaultNetworkCallback(networkCallback);
    } else {
      context.registerReceiver(this, new IntentFilter(CONNECTIVITY_ACTION));
    }
    // Need to emit first event with connectivity types without waiting for first change in system
    // that might happen much later
    sendEvent(connectivity.getNetworkTypes());
  }

  @Override
  public void onCancel(Object arguments) {
    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      if (networkCallback != null) {
        connectivity.getConnectivityManager().unregisterNetworkCallback(networkCallback);
        networkCallback = null;
      }
    } else {
      try {
        context.unregisterReceiver(this);
      } catch (Exception e) {
        // listen never called, ignore the error
      }
    }
  }

  @Override
  public void onReceive(Context context, Intent intent) {
    if (events != null) {
      events.success(connectivity.getNetworkTypes());
    }
  }

  private void sendEvent(List<String> networkTypes) {
    Runnable runnable = () -> events.success(networkTypes);
    // Emit events on main thread
    mainHandler.post(runnable);
  }
}
