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

import java.util.List;

import io.flutter.plugin.common.EventChannel;

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
                            // Use the provided Network object in the callback
                            sendEvent(connectivity.getCapabilitiesFromNetwork(network));
                        }

                        @Override
                        public void onCapabilitiesChanged(
                                Network network, NetworkCapabilities networkCapabilities) {
                            // Use the provided NetworkCapabilities in the callback
                            sendEvent(connectivity.getCapabilitiesList(networkCapabilities));
                        }

                        @Override
                        public void onLost(Network network) {
                            // Send NONE to ensure no network is reported when connectivity is lost
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
        // The dalay is needed because callback methods suffer from race conditions.
        // More info:
        // https://developer.android.com/develop/connectivity/network-ops/reading-network-state#listening-events
        mainHandler.postDelayed(runnable, 100);
    }
}
