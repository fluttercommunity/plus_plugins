import 'package:data_strength_plus/data_strength_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? _mobileSignal;
  int? _wifiSignal;
  int? _wifiSpeed;
  String? _version;

  final _internetSignal = DataStrengthPlus();

  @override
  void initState() {
    super.initState();
    _getPlatformVersion();
  }

  Future<void> _getPlatformVersion() async {
    try {
      _version = await _internetSignal.getPlatformVersion();
    } on PlatformException {
      if (kDebugMode) print('Error get Android version.');
      _version = null;
    }
    setState(() {});
  }

  Future<void> _getInternetSignal() async {
    int? mobile;
    int? wifi;
    int? wifiSpeed;
    try {
      mobile = await _internetSignal.getMobileSignalStrength();
      wifi = await _internetSignal.getWifiSignalStrength();
      wifiSpeed = await _internetSignal.getWifiLinkSpeed();
    } on PlatformException {
      if (kDebugMode) print('Error get internet signal.');
    }
    setState(() {
      _mobileSignal = mobile;
      _wifiSignal = wifi;
      _wifiSpeed = wifiSpeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Internet Signal Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('On Version: $_version \n'),
              Text(
                  'Mobile signal: ${_mobileSignal ?? '--'} dBm ::${DataStrengthPlus.rangeName(_mobileSignal)}\n'),
              Text(
                  'Wifi signal: ${_wifiSignal ?? '--'} dBm :: ${DataStrengthPlus.rangeName(_wifiSignal)}\n'),
              Text('Wifi speed: ${_wifiSpeed ?? '--'} Mbps\n'),
              ElevatedButton(
                onPressed: _getInternetSignal,
                child: const Text('Get internet signal'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
