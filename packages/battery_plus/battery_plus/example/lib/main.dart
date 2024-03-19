// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Battery _battery = Battery();

  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    try {
      _battery.batteryState.then(
        _updateBatteryState,
        onError: (e) {
          _showError('onError: batteryState: $e');
          _updateBatteryState(BatteryState.unknown);
        },
      );
      _batteryStateSubscription = _battery.onBatteryStateChanged.listen(
        _updateBatteryState,
        onError: (e) {
          _showError('onError: onBatteryStateChanged: $e');
          _updateBatteryState(BatteryState.unknown);
        },
      );
    } on Error catch (e) {
      _showError('catch: batteryState: $e');
    }
  }

  void _updateBatteryState(BatteryState state) {
    if (_batteryState == state) return;
    setState(() {
      _batteryState = state;
    });
  }

  void _showError(String message) {
    // see https://github.com/fluttercommunity/plus_plugins/pull/2720
    // The exception may not be caught in the package and an exception may occur in the caller, so use try-catch as needed.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery plus example app'),
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Current battery state:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              '${_batteryState?.name}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                try {
                  _battery.batteryLevel.then(
                    (batteryLevel) {
                      showDialog<void>(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Text('Battery: $batteryLevel%'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    },
                    onError: (e) {
                      _showError('onError: batteryLevel: $e');
                    },
                  );
                } on Error catch (e) {
                  _showError('catch: batteryLevel: $e');
                }
              },
              child: const Text('Get battery level'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                try {
                  _battery.isInBatterySaveMode.then(
                    (isInPowerSaveMode) {
                      showDialog<void>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                            'Is in Battery Save mode?',
                            style: TextStyle(fontSize: 20),
                          ),
                          content: Text(
                            "$isInPowerSaveMode",
                            style: const TextStyle(fontSize: 18),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            )
                          ],
                        ),
                      );
                    },
                    onError: (e) {
                      _showError('onError: isInBatterySaveMode: $e');
                    },
                  );
                } on Error catch (e) {
                  _showError('catch: isInBatterySaveMode: $e');
                }
              },
              child: const Text('Is in Battery Save mode?'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }
}
