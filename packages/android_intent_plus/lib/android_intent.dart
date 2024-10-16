// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:platform/platform.dart';

const String _kChannelName = 'dev.fluttercommunity.plus/android_intent';

/// Flutter plugin for launching arbitrary Android Intents.
///
/// See [the official Android
/// documentation](https://developer.android.com/reference/android/content/Intent.html)
/// for more information on how to use Intents.
class AndroidIntent {
  /// Builds an Android intent with the following parameters
  /// [action] refers to the action parameter of the intent.
  /// [flags] is the list of int that will be converted to native flags.
  /// [category] refers to the category of the intent, can be null.
  /// [data] refers to the string format of the URI that will be passed to
  /// intent.
  /// [arguments] is the map that will be converted into an extras bundle and
  /// passed to the intent.
  /// [arrayArguments] is a map that will be converted into an extra bundle
  /// as in an array and passed to the intent.
  /// [package] refers to the package parameter of the intent, can be null.
  /// [componentName] refers to the component name of the intent, can be null.
  /// If not null, then [package] but also be provided.
  /// [type] refers to the type of the intent, can be null.
  const AndroidIntent({
    this.action,
    this.flags,
    this.category,
    this.data,
    this.arguments,
    this.arrayArguments,
    this.package,
    this.componentName,
    Platform? platform,
    this.type,
  })  : assert(action != null || componentName != null,
            'action or component (or both) must be specified'),
        _channel = const MethodChannel(_kChannelName),
        _platform = platform ?? const LocalPlatform();

  /// This constructor is only exposed for unit testing. Do not rely on this in
  /// app code, it may break without warning.
  @visibleForTesting
  AndroidIntent.private({
    required Platform platform,
    required MethodChannel channel,
    this.action,
    this.flags,
    this.category,
    this.data,
    this.arguments,
    this.arrayArguments,
    this.package,
    this.componentName,
    this.type,
  })  : assert(action != null || componentName != null,
            'action or component (or both) must be specified'),
        _channel = channel,
        _platform = platform;

  /// This is the general verb that the intent should attempt to do. This
  /// includes constants like `ACTION_VIEW`.
  ///
  /// See https://developer.android.com/reference/android/content/Intent.html#intent-structure.
  final String? action;

  /// Constants that can be set on an intent to tweak how it is finally handled.
  /// Some of the constants are mirrored to Dart via [Flag].
  ///
  /// See https://developer.android.com/reference/android/content/Intent.html#setFlags(int).
  final List<int>? flags;

  /// An optional additional constant qualifying the given [action].
  ///
  /// See https://developer.android.com/reference/android/content/Intent.html#intent-structure.
  final String? category;

  /// The Uri that the [action] is pointed towards.
  ///
  /// See https://developer.android.com/reference/android/content/Intent.html#intent-structure.
  final String? data;

  /// The equivalent of `extras`, a generic `Bundle` of data that the Intent can
  /// carry. This is a slot for extraneous data that the listener may use.
  ///
  /// If the argument contains a list value, then the value will be put in as an
  /// array list.
  ///
  /// See https://developer.android.com/reference/android/content/Intent.html#intent-structure.
  final Map<String, dynamic>? arguments;

  /// Similar to [arguments], but in this case the arguments are an array and
  /// will be added to the intent as in an array extra instead of of an array
  /// list.
  final Map<String, List<dynamic>>? arrayArguments;

  /// Sets the [data] to only resolve within this given package.
  ///
  /// See https://developer.android.com/reference/android/content/Intent.html#setPackage(java.lang.String).
  final String? package;

  /// Set the exact `ComponentName` that should handle the intent. If this is
  /// set [package] should also be non-null.
  ///
  /// See https://developer.android.com/reference/android/content/Intent.html#setComponent(android.content.ComponentName).
  final String? componentName;
  final MethodChannel _channel;
  final Platform _platform;

  /// Set an explicit MIME data type.
  ///
  /// See https://developer.android.com/reference/android/content/Intent.html#intent-structure.
  final String? type;

  bool _isPowerOfTwo(int x) {
    /* First x in the below expression is for the case when x is 0 */
    return x != 0 && ((x & (x - 1)) == 0);
  }

  /// This method is just visible for unit testing and should not be relied on.
  /// Its method signature may change at any time.
  @visibleForTesting
  int convertFlags(List<int> flags) {
    var finalValue = 0;
    for (var i = 0; i < flags.length; i++) {
      if (!_isPowerOfTwo(flags[i])) {
        throw ArgumentError.value(flags[i], 'flag\'s value must be power of 2');
      }
      finalValue |= flags[i];
    }
    return finalValue;
  }

  /// Launch the intent.
  ///
  /// This works only on Android platforms.
  Future<void> launch() async {
    if (!_platform.isAndroid) {
      return;
    }

    await _channel.invokeMethod<void>('launch', _buildArguments());
  }

  /// Parse and Launch the intent in format.
  ///
  /// Equivalent of native android Intent.parseUri(URI, Intent.URI_INTENT_SCHEME)
  /// This works only on Android platforms.
  static Future<void> parseAndLaunch(String uri) async {
    if (!const LocalPlatform().isAndroid) {
      return;
    }

    await const MethodChannel(_kChannelName)
        .invokeMethod<void>('parseAndLaunch', {'uri': uri});
  }

  /// Launch the intent with 'createChooser(intent, title)'.
  ///
  /// This works only on Android platforms.
  Future<void> launchChooser(String title) async {
    if (!_platform.isAndroid) {
      return;
    }

    final buildArguments = _buildArguments();
    buildArguments['chooserTitle'] = title;
    await _channel.invokeMethod<void>(
      'launchChooser',
      buildArguments,
    );
  }

  /// Sends intent as broadcast.
  ///
  /// This works only on Android platforms.
  Future<void> sendBroadcast() async {
    if (!_platform.isAndroid) {
      return;
    }

    await _channel.invokeMethod<void>(
      'sendBroadcast',
      _buildArguments(),
    );
  }

  /// Check whether the intent can be resolved to an activity.
  ///
  /// This works only on Android platforms.
  Future<bool?> canResolveActivity() async {
    if (!_platform.isAndroid) {
      return false;
    }

    return await _channel.invokeMethod<bool>(
      'canResolveActivity',
      _buildArguments(),
    );
  }

  /// Get the default activity that will resolve the intent
  ///
  /// Note: ensure the calling app's AndroidManifest contains queries that match the intent.
  /// See: https://developer.android.com/guide/topics/manifest/queries-element
  Future<ResolvedActivity?> getResolvedActivity() async {
    if (!_platform.isAndroid) {
      return null;
    }

    final result = await _channel.invokeMethod<Map<Object?, Object?>>(
      'getResolvedActivity',
      _buildArguments(),
    );

    if (result != null) {
      return ResolvedActivity(
        appName: result["appName"] as String,
        activityName: result["activityName"] as String,
        packageName: result["packageName"] as String,
      );
    }

    return null;
  }

  /// Constructs the map of arguments which is passed to the plugin.
  Map<String, dynamic> _buildArguments() {
    return {
      if (action != null) 'action': action,
      if (flags != null) 'flags': convertFlags(flags!),
      if (category != null) 'category': category,
      if (data != null) 'data': data,
      if (arguments != null) 'arguments': arguments,
      if (arrayArguments != null) 'arrayArguments': arrayArguments,
      if (package != null) ...{
        'package': package,
        if (componentName != null) 'componentName': componentName,
      },
      if (type != null) 'type': type,
    };
  }
}

class ResolvedActivity {
  final String appName;
  final String activityName;
  final String packageName;

  ResolvedActivity({
    required this.appName,
    required this.activityName,
    required this.packageName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolvedActivity &&
          runtimeType == other.runtimeType &&
          appName == other.appName &&
          activityName == other.activityName &&
          packageName == other.packageName;

  @override
  int get hashCode =>
      appName.hashCode ^ activityName.hashCode ^ packageName.hashCode;

  @override
  String toString() {
    return 'ResolvedActivity{appName: $appName, activityName: $activityName, packageName: $packageName}';
  }
}
