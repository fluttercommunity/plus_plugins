// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:async/async.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBatteryPlatform
    with MockPlatformInterfaceMixin
    implements BatteryPlatform {
  @override
  Future<int> get batteryLevel => Future.value(42);

  @override
  Future<BatteryState> get batteryState => Future.value(BatteryState.charging);

  @override
  Stream<BatteryState> get onBatteryStateChanged => Stream.fromIterable([
        BatteryState.unknown,
        BatteryState.charging,
        BatteryState.full,
        BatteryState.discharging
      ]);

  @override
  Future<bool> get isInBatterySaveMode => Future.value(true);
}

void main() {
  late Battery battery;
  late MockBatteryPlatform fakePlatform;

  setUpAll(() {
    fakePlatform = MockBatteryPlatform();
    BatteryPlatform.instance = fakePlatform;
    battery = Battery();
  });

  test('batteryLevel', () async {
    expect(await battery.batteryLevel, 42);
  });

  test('isInBatterySaveMode', () async {
    expect(await battery.isInBatterySaveMode, true);
  });

  test('current state of the battery', () async {
    expect(await battery.batteryState, BatteryState.charging);
  });

  test('receiving events of the battery state', () async {
    final queue = StreamQueue<BatteryState>(battery.onBatteryStateChanged);

    expect(await queue.next, BatteryState.unknown);
    expect(await queue.next, BatteryState.charging);
    expect(await queue.next, BatteryState.full);
    expect(await queue.next, BatteryState.discharging);

    expect(await queue.hasNext, false);
  });
}
