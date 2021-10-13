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
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      routes: <String, WidgetBuilder>{
        ExplicitIntentsWidget.routeName: (BuildContext context) =>
            const ExplicitIntentsWidget()
      },
    );
  }
}

/// Holds the different intent widgets.
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  void _createAlarm() {
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
              onPressed: _createAlarm,
              child: const Text(
                  'Tap here to set an alarm\non weekdays at 9:30pm.'),
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
        title: const Text('Plugin example app'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test explicit intents'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: _openGoogleMapsStreetView,
                child: const Text(
                    'Tap here to display panorama\nimagery in Google Street View.'),
              ),
              ElevatedButton(
                onPressed: _displayMapInGoogleMaps,
                child: const Text('Tap here to display\na map in Google Maps.'),
              ),
              ElevatedButton(
                onPressed: _launchTurnByTurnNavigationInGoogleMaps,
                child: const Text(
                    'Tap here to launch turn-by-turn\nnavigation in Google Maps.'),
              ),
              ElevatedButton(
                onPressed: _openLinkInGoogleChrome,
                child: const Text('Tap here to open link in Google Chrome.'),
              ),
              ElevatedButton(
                onPressed: _startActivityInNewTask,
                child: const Text('Tap here to start activity in new task.'),
              ),
              ElevatedButton(
                onPressed: _testExplicitIntentFallback,
                child: const Text(
                    'Tap here to test explicit intent fallback to implicit.'),
              ),
              ElevatedButton(
                onPressed: _openLocationSettingsConfiguration,
                child: const Text(
                  'Tap here to open Location Settings Configuration',
                ),
              ),
              ElevatedButton(
                onPressed: _openApplicationDetails,
                child: const Text(
                  'Tap here to open Application Details',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
