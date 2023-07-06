// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:platform/platform.dart';

void main() {
  runApp(const MyApp());
}

/// A sample app for launching intents.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        ExplicitIntentsWidget.routeName: (BuildContext context) =>
            const ExplicitIntentsWidget()
      },
    );
  }
}

/// Holds the different intent widgets.
class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  void _createAlarmUsingArguments() {
    const intent = AndroidIntent(
      action: 'android.intent.action.SET_ALARM',
      arguments: <String, dynamic>{
        'android.intent.extra.alarm.DAYS': <int>[2, 3, 4, 5, 6],
        'android.intent.extra.alarm.HOUR': 21,
        'android.intent.extra.alarm.MINUTES': 30,
        'android.intent.extra.alarm.SKIP_UI': true,
        'android.intent.extra.alarm.MESSAGE': 'Create a Flutter app',
      },
    );
    intent.launch();
  }

  void _createAlarmUsingExtras() {
    final intent = AndroidIntent(
      action: 'android.intent.action.SET_ALARM',
      extras: Bundles(
        bundles: [
          Bundle(
            value: [
              PutIntegerArrayList(
                key: 'android.intent.extra.alarm.DAYS',
                value: [2, 3, 4, 5, 6],
              ),
              PutInt(key: 'android.intent.extra.alarm.HOUR', value: 22),
              PutInt(key: 'android.intent.extra.alarm.MINUTES', value: 30),
              PutBool(key: 'android.intent.extra.alarm.SKIP_UI', value: true),
              PutString(
                  key: 'android.intent.extra.alarm.MESSAGE',
                  value: 'Create another Flutter app'),
            ],
          ),
        ],
      ),
    );
    intent.launch();
  }

  void _openExplicitIntentsView(BuildContext context) {
    Navigator.of(context).pushNamed(ExplicitIntentsWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (const LocalPlatform().isAndroid) {
      body = Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: _createAlarmUsingArguments,
              child: const Text(
                  'Tap here to set an alarm\non weekdays at 9:30pm, using arguments and array arguments'),
            ),
            ElevatedButton(
              onPressed: _createAlarmUsingExtras,
              child: const Text(
                  'Tap here to set an alarm\non weekdays at 10:30pm, using extras'),
            ),
            ElevatedButton(
              onPressed: _openChooser,
              child: const Text('Tap here to launch Intent with Chooser'),
            ),
            ElevatedButton(
              onPressed: _sendBroadcast,
              child: const Text('Tap here to send Intent as broadcast'),
            ),
            ElevatedButton(
              onPressed: () => _sendBroadCastCreateProfile(context),
              child: const Text('Create datawedge profile on Zebra devices'),
            ),
            ElevatedButton(
              onPressed: () => _openExplicitIntentsView(context),
              child: const Text('Tap here to test explicit intents.'),
            ),
          ],
        ),
      );
    } else {
      body = const Text('This plugin only works with Android');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Android intent plus example app'),
        elevation: 4,
      ),
      body: Center(child: body),
    );
  }

  void _openChooser() {
    const intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      type: 'plain/text',
      data: 'text example',
    );
    intent.launchChooser('Chose an app');
  }

  void _sendBroadcast() {
    const intent = AndroidIntent(
      action: 'com.example.broadcast',
    );
    intent.sendBroadcast();
  }

  void _sendBroadCastCreateProfile(BuildContext context) {
    final intent = AndroidIntent(
      action: 'com.symbol.datawedge.api.ACTION',
      extras: Bundles(
        bundles: [
          Bundle(
            value: [
              PutBundle(
                key: 'com.symbol.datawedge.api.SET_CONFIG',
                value: [
                  PutString(
                    key: 'PROFILE_NAME',
                    value: 'io.flutter.plugins.androidintentexample',
                  ),
                  PutString(
                    key: 'PROFILE_ENABLED',
                    value: 'true',
                  ),
                  PutString(
                    key: 'CONFIG_MODE',
                    value: 'CREATE_IF_NOT_EXIST',
                  ),
                  PutParcelableArray(
                    key: 'APP_LIST',
                    value: [
                      _appList,
                    ],
                  ),
                  PutParcelableArrayList(
                    key: 'PLUGIN_CONFIG',
                    value: [
                      _barcodePluginConfig,
                      _intentPluginConfig,
                      _keystrokePluginConfig,
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
    intent.sendBroadcast();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Check datawedge on Zebra devices if the profile is created. (Zebra devices only)'),
      ),
    );
  }

  final _appList = Bundle(
    value: [
      PutString(
        key: 'PACKAGE_NAME',
        value: 'io.flutter.plugins.androidintentexample',
      ),
      PutStringArray(
        key: 'ACTIVITY_LIST',
        value: ['*'],
      ),
    ],
  );

  final _barcodePluginConfig = Bundle(
    value: [
      PutString(
        key: 'PLUGIN_NAME',
        value: 'BARCODE',
      ),
      PutString(
        key: 'RESET_CONFIG',
        value: 'true',
      ),
      PutBundle(
        key: 'PARAM_LIST',
        value: [
          PutString(
            key: 'scanner_selection',
            value: 'auto',
          ),
          PutString(
            key: 'picklist',
            value: "1",
          ),
        ],
      ),
    ],
  );

  final _intentPluginConfig = Bundle(
    value: [
      PutString(
        key: 'PLUGIN_NAME',
        value: 'INTENT',
      ),
      PutString(
        key: 'RESET_CONFIG',
        value: 'true',
      ),
      PutBundle(
        key: 'PARAM_LIST',
        value: [
          PutString(
            key: 'intent_output_enabled',
            value: 'true',
          ),
          PutString(
            key: 'intent_action',
            value: 'io.flutter.plugins.androidintentexample.ACTION',
          ),
          PutString(
            key: 'intent_delivery',
            value: '2',
          ),
        ],
      ),
    ],
  );

  final _keystrokePluginConfig = Bundle(
    value: [
      PutString(
        key: 'PLUGIN_NAME',
        value: 'KEYSTROKE',
      ),
      PutString(
        key: 'RESET_CONFIG',
        value: 'true',
      ),
      PutBundle(
        key: 'PARAM_LIST',
        value: [
          PutString(
            key: 'keystroke_output_enabled',
            value: 'false',
          ),
        ],
      ),
    ],
  );
}

/// Launches intents to specific Android activities.
class ExplicitIntentsWidget extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ExplicitIntentsWidget(); // ignore: public_member_api_docs

  // ignore: public_member_api_docs
  static const String routeName = '/explicitIntents';

  void _openGoogleMapsStreetView() {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('google.streetview:cbll=46.414382,10.013988'),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  void _displayMapInGoogleMaps({int zoomLevel = 12}) {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('geo:37.7749,-122.4194?z=$zoomLevel'),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  void _launchTurnByTurnNavigationInGoogleMaps() {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull(
            'google.navigation:q=Taronga+Zoo,+Sydney+Australia&avoid=tf'),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  void _openLinkInGoogleChrome() {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('https://flutter.dev'),
        package: 'com.android.chrome');
    intent.launch();
  }

  void _startActivityInNewTask() {
    final intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull('https://flutter.dev'),
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  void _testExplicitIntentFallback() {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('https://flutter.dev'),
        package: 'com.android.chrome.implicit.fallback');
    intent.launch();
  }

  void _openLocationSettingsConfiguration() {
    const AndroidIntent intent = AndroidIntent(
      action: 'action_location_source_settings',
    );
    intent.launch();
  }

  void _openApplicationDetails() {
    const intent = AndroidIntent(
      action: 'action_application_details_settings',
      data: 'package:io.flutter.plugins.androidintentexample',
    );
    intent.launch();
  }

  void _openGmailUsingArgumentsAndArrayArguments() {
    const intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      arguments: {'android.intent.extra.SUBJECT': 'I am the subject'},
      arrayArguments: {
        'android.intent.extra.EMAIL': ['eidac@me.com', 'overbom@mac.com'],
        'android.intent.extra.CC': ['john@app.com', 'user@app.com'],
        'android.intent.extra.BCC': ['liam@me.abc', 'abel@me.com'],
      },
      package: 'com.google.android.gm',
      type: 'message/rfc822',
    );
    intent.launch();
  }

  void _openGmailUsingExtras() {
    final intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      extras: Bundles(bundles: [
        Bundle(value: [
          PutString(
              key: 'android.intent.extra.SUBJECT', value: 'I am the subject'),
          PutStringArray(
            key: 'android.intent.extra.EMAIL',
            value: ['eidac@me.com', 'overbom@mac.com'],
          ),
          PutStringArray(
            key: 'android.intent.extra.CC',
            value: ['john@app.com', 'user@app.com'],
          ),
          PutStringArray(
            key: 'android.intent.extra.BCC',
            value: ['liam@me.abc', 'abel@me.com'],
          ),
        ])
      ]),
      package: 'com.google.android.gm',
      type: 'message/rfc822',
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test explicit intents'),
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: _openGoogleMapsStreetView,
                child: const Text(
                    'Tap here to display panorama\nimagery in Google Street View.'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _displayMapInGoogleMaps,
                child: const Text('Tap here to display\na map in Google Maps.'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _launchTurnByTurnNavigationInGoogleMaps,
                child: const Text(
                    'Tap here to launch turn-by-turn\nnavigation in Google Maps.'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openLinkInGoogleChrome,
                child: const Text('Tap here to open link in Google Chrome.'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startActivityInNewTask,
                child: const Text('Tap here to start activity in new task.'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testExplicitIntentFallback,
                child: const Text(
                    'Tap here to test explicit intent fallback to implicit.'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openLocationSettingsConfiguration,
                child: const Text(
                  'Tap here to open Location Settings Configuration',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openApplicationDetails,
                child: const Text(
                  'Tap here to open Application Details',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openGmailUsingArgumentsAndArrayArguments,
                child: const Text(
                  'Tap here to open gmail app with details using arguments and array arguments',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openGmailUsingExtras,
                child: const Text(
                  'Tap here to open gmail app with details using extras',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
