import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:battery_plus_macos/battery_plus_macos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<int>(
              future: Battery().batteryLevel,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Charge at: ${snapshot.data} ');
                } else if (snapshot.hasError) {
                  return Text('Error fetching charge ');
                } else {
                  return Text('Loading ');
                }
              },
            ),
            const SizedBox(
              height: 25.0,
            ),
            StreamBuilder<BatteryState>(
              stream: Battery().onBatteryStateChanged,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Battery at: ${snapshot.data} ');
                } else if (snapshot.hasError) {
                  return Text('Error fetching battery state');
                } else {
                  return Text('Loading ');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
