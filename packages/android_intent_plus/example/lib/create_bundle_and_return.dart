import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';

class CreateBundleAndReturn {
  static Future<Bundles> go(Bundles bundles) async {
    const methodChannel = MethodChannel(
      'io.flutter.plugins.androidintentexample/integration_tests',
    );
    final bundleAsString = jsonEncode(bundles);
    final jsonAsString = await methodChannel.invokeMethod<String>(
      'createBundleAndReturn',
      <String, dynamic>{
        'extras': bundleAsString,
      },
    );
    final json = jsonDecode(jsonAsString!);
    final resultBundles = Bundles.fromJson(json);
    return resultBundles;
  }
}
