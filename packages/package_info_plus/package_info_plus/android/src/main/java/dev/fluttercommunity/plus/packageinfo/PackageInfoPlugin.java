// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.packageinfo;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

/**
 * PackageInfoPlugin
 */
public class PackageInfoPlugin implements MethodCallHandler, FlutterPlugin {
  private Context applicationContext;
  private MethodChannel methodChannel;

  /**
   * Plugin registration.
   */
  @SuppressWarnings("deprecation")
  public static void registerWith(Registrar registrar) {
    final PackageInfoPlugin instance = new PackageInfoPlugin();
    instance.onAttachedToEngine(registrar.context(), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    this.applicationContext = applicationContext;
    methodChannel = new MethodChannel(messenger, "dev.fluttercommunity.plus/package_info");
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    applicationContext = null;
    methodChannel.setMethodCallHandler(null);
    methodChannel = null;
  }

  @Override
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    try {
      if (call.method.equals("getAll")) {
        PackageManager pm = applicationContext.getPackageManager();
        PackageInfo info = pm.getPackageInfo(applicationContext.getPackageName(), 0);

        String buildSignature = getBuildSignature(pm);

        Map<String, String> map = new HashMap<>();
        map.put("appName", info.applicationInfo.loadLabel(pm).toString());
        map.put("packageName", applicationContext.getPackageName());
        map.put("version", info.versionName);
        map.put("buildNumber", String.valueOf(getLongVersionCode(info)));
        if (buildSignature != null) map.put("buildSignature", buildSignature);

        result.success(map);
      } else {
        result.notImplemented();
      }
    } catch (PackageManager.NameNotFoundException ex) {
      result.error("Name not found", ex.getMessage(), null);
    }
  }

  @SuppressWarnings("deprecation")
  private static long getLongVersionCode(PackageInfo info) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
      return info.getLongVersionCode();
    }
    return info.versionCode;
  }

  @SuppressWarnings("deprecation")
  private String getBuildSignature(PackageManager pm) {
    try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        PackageInfo packageInfo = pm.getPackageInfo(applicationContext.getPackageName(), PackageManager.GET_SIGNING_CERTIFICATES);
        if (packageInfo == null
          || packageInfo.signingInfo == null) {
          return null;
        }
        if (packageInfo.signingInfo.hasMultipleSigners()) {
          return signatureToSha1(packageInfo.signingInfo.getApkContentsSigners()[0].toByteArray());
        } else {
          return signatureToSha1(packageInfo.signingInfo.getSigningCertificateHistory()[0].toByteArray());
        }
      } else {
        @SuppressLint("PackageManagerGetSignatures") PackageInfo packageInfo =
          pm.getPackageInfo(applicationContext.getPackageName(), PackageManager.GET_SIGNATURES);
        if (packageInfo == null
          || packageInfo.signatures == null
          || packageInfo.signatures.length == 0
          || packageInfo.signatures[0] == null) {
          return null;
        }
        return signatureToSha1(packageInfo.signatures[0].toByteArray());
      }
    } catch (PackageManager.NameNotFoundException | NoSuchAlgorithmException e) {
      return null;
    }
  }

  // Credits https://gist.github.com/scottyab/b849701972d57cf9562e
  private String bytesToHex(byte[] bytes) {
    final char[] hexArray = {
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
    };
    char[] hexChars = new char[bytes.length * 2];
    int v;
    for (int j = 0; j < bytes.length; j++) {
      v = bytes[j] & 0xFF;
      hexChars[j * 2] = hexArray[v >>> 4];
      hexChars[j * 2 + 1] = hexArray[v & 0x0F];
    }
    return new String(hexChars);
  }

  // Credits https://gist.github.com/scottyab/b849701972d57cf9562e
  private String signatureToSha1(byte[] sig) throws NoSuchAlgorithmException {
    MessageDigest digest = MessageDigest.getInstance("SHA1");
    digest.update(sig);
    byte[] hashtext = digest.digest();
    return bytesToHex(hashtext);
  }
}
