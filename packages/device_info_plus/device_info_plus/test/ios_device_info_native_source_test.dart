import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('guards iOS vision process info selector before invocation', () {
    final source = File(
      'ios/device_info_plus/Sources/device_info_plus/FPPDeviceInfoPlusPlugin.m',
    ).readAsStringSync();

    final guardIndex = source.indexOf(
      'respondsToSelector:@selector(isiOSAppOnVision)',
    );
    final invocationIndex = source.indexOf('[info isiOSAppOnVision]');

    expect(guardIndex, isNonNegative);
    expect(invocationIndex, isNonNegative);
    expect(guardIndex, lessThan(invocationIndex));
  });
}
