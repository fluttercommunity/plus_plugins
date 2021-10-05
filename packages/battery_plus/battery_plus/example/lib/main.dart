// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Battery _battery = Battery();

  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('$_batteryState'),
            ),
            ListTile(
              onTap: () async {
                final isBatteryPresent = await _battery.isBatteryPresent;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery Present: $isBatteryPresent'),
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
              title: const Text('Is battery present'),
            ),
            ListTile(
              onTap: () async {
                final batteryLevel = await _battery.batteryLevel;
                // ignore: unawaited_futures
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
              title: const Text('Get battery level'),
            ),
            ListTile(
              onTap: () async {
                final batteryHealth = await _battery.batteryHealth;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery Health: $batteryHealth'),
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
              title: const Text('Get battery Health'),
            ),
            ListTile(
              onTap: () async {
                final batteryPluggedType = await _battery.batteryPluggedType;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery Health: $batteryPluggedType'),
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
              title: const Text('Get battery charging type'),
            ),
            ListTile(
              onTap: () async {
                final batteryCapacity = await _battery.batteryCapacity;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery Capacity: $batteryCapacity'),
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
              title: const Text('Get battery capacity'),
            ),
            ListTile(
              onTap: () async {
                final batteryTechnology = await _battery.batteryTechnology;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery Technology: $batteryTechnology'),
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
              title: const Text('Get battery technology'),
            ),
            ListTile(
              onTap: () async {
                final batteryTemperature = await _battery.batteryTemperature;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery Temperature: $batteryTemperature'),
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
              title: const Text('Get battery temperature'),
            ),
            ListTile(
              onTap: () async {
                final batteryVoltage = await _battery.batteryVoltage;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery Voltage: $batteryVoltage'),
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
              title: const Text('Get battery voltage'),
            ),
            ListTile(
              onTap: () async {
                final batteryCurrentAverage =
                    await _battery.batteryCurrentAverage;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content:
                        Text('Battery Current Average: $batteryCurrentAverage'),
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
              title: const Text('Get battery current average'),
            ),
            ListTile(
              onTap: () async {
                final batteryCurrent = await _battery.batteryCurrent;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery Current: $batteryCurrent'),
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
              title: const Text('Get battery current'),
            ),
            ListTile(
              onTap: () async {
                final batteryRemainingCapacity =
                    await _battery.batteryRemainingCapacity;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text(
                        'Remaining Battery Capacity: $batteryRemainingCapacity'),
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
              title: const Text('Get remaining battery capacity'),
            ),
            ListTile(
              onTap: () async {
                final batteryScale = await _battery.batteryScale;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery Scale: $batteryScale'),
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
              title: const Text('Get battery scale'),
            ),
            ListTile(
              onTap: () async {
                final batteryChargeTimeRemaining =
                    await _battery.batteryChargeTimeRemaining;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text(
                        'Battery Charge Time Remaining: $batteryChargeTimeRemaining'),
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
              title: const Text('Get battery Charge Time Remaining'),
            ),
            ListTile(
                onTap: () async {
                  final isInPowerSaveMode = await _battery.isInBatterySaveMode;
                  // ignore: unawaited_futures
                  showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text('Is on low power mode: $isInPowerSaveMode'),
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
                title: const Text('Is on low power mode'))
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
