// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer' as developer;
import 'dart:isolate';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

const String countKey = 'count';
const String isolateName = 'isolate';

final ReceivePort port = ReceivePort();
late final SharedPreferences prefs;

/// Entry point of the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  IsolateNameServer.registerPortWithName(port.sendPort, isolateName);
  prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(countKey)) {
    await prefs.setInt(countKey, 0);
  }

  runApp(const AlarmManagerExampleApp());
}

class AlarmManagerExampleApp extends StatelessWidget {
  const AlarmManagerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Alarm Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const AlarmHomePage(),
    );
  }
}

class AlarmHomePage extends StatefulWidget {
  const AlarmHomePage({super.key});

  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  int _counter = 0;
  PermissionStatus _exactAlarmPermissionStatus = PermissionStatus.granted;
  static SendPort? uiSendPort;

  @override
  void initState() {
    super.initState();
    AndroidAlarmManager.initialize();
    _checkExactAlarmPermission();
    port.listen((_) => _incrementCounter());
  }

  Future<void> _checkExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (!mounted) return;
    setState(() => _exactAlarmPermissionStatus = status);
  }

  Future<void> _incrementCounter() async {
    developer.log('Increment counter!', name: 'AlarmManagerExample');
    await prefs.reload();
    if (!mounted) return;
    setState(() => _counter++);
  }

  @pragma('vm:entry-point')
  static Future<void> callback() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  Future<void> _requestPermission() async {
    await Permission.scheduleExactAlarm
        .onGrantedCallback(() => setState(() => _exactAlarmPermissionStatus = PermissionStatus.granted))
        .request();
  }

  Future<void> _scheduleAlarm() async {
    await AndroidAlarmManager.oneShot(
      const Duration(seconds: 5),
      Random().nextInt(1 << 31),
      callback,
      exact: true,
      wakeup: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineMedium;
    return Scaffold(
      appBar: AppBar(title: const Text('Android Alarm Manager Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text('Alarms fired during this run: $_counter', style: textStyle, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text('Total alarms fired: ${prefs.getInt(countKey)}', style: textStyle, textAlign: TextAlign.center),
            const Spacer(),
            Text(
              _exactAlarmPermissionStatus.isDenied
                  ? 'Exact alarm permission denied. Alarms not available.'
                  : 'Exact alarm permission granted. Alarms available.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _exactAlarmPermissionStatus.isDenied ? _requestPermission : null,
              child: const Text('Request exact alarm permission'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _exactAlarmPermissionStatus.isGranted ? _scheduleAlarm : null,
              child: const Text('Schedule OneShot Alarm'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
