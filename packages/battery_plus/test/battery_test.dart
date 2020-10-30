// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:async/async.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockBatteryPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements BatteryPlatform {}

void main() {
  Battery battery;
  MockBatteryPlatform fakePlatform;

  setUp(() {
    fakePlatform = MockBatteryPlatform();
    BatteryPlatform.instance = fakePlatform;
    battery = Battery();
  });

  test('batteryLevel', () async {
    when(battery.batteryLevel)
        .thenAnswer((Invocation invoke) => Future<int>.value(42));
    expect(await battery.batteryLevel, 42);
  });

  group('battery state', () {
    StreamController<BatteryState> controller;

    setUp(() {
      controller = StreamController<BatteryState>();
      when(battery.onBatteryStateChanged)
          .thenAnswer((Invocation invoke) => controller.stream);
    });

    tearDown(() {
      controller.close();
    });

    test('receive values', () async {
      final StreamQueue<BatteryState> queue =
          StreamQueue<BatteryState>(battery.onBatteryStateChanged);

      controller.add(BatteryState.full);
      expect(await queue.next, BatteryState.full);

      controller.add(BatteryState.discharging);
      expect(await queue.next, BatteryState.discharging);

      controller.add(BatteryState.charging);
      expect(await queue.next, BatteryState.charging);

      controller.add(null);
      expect(await queue.next, null);
    });
  });
}
