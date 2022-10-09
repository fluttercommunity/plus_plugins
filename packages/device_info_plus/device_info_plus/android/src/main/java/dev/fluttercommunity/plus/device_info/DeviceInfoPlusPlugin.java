// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.device_info;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.view.WindowManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

/**
 * DeviceInfoPlusPlugin
 */
public class DeviceInfoPlusPlugin implements FlutterPlugin, ActivityAware {

    MethodChannel channel;
    Activity activity;

    @Override
    public void onAttachedToEngine(FlutterPlugin.FlutterPluginBinding binding) {
        setupMethodChannel(binding.getBinaryMessenger(), binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        tearDownChannel();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    private void setupMethodChannel(BinaryMessenger messenger, Context context) {
        channel = new MethodChannel(messenger, "dev.fluttercommunity.plus/device_info");
        final PackageManager packageManager = context.getPackageManager();
        final WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        final MethodCallHandlerImpl handler =
                new MethodCallHandlerImpl(packageManager, windowManager);
        channel.setMethodCallHandler(handler);
    }

    private void tearDownChannel() {
        channel.setMethodCallHandler(null);
        channel = null;
    }
}
