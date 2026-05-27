import 'package:connectivity_plus_platform_interface/src/enums.dart';
import 'package:test/test.dart';

void main() {
  group('List<$ConnectivityResult>.hasConnectivity', () {
    test('returns false when only none is present', () {
      final result = [ConnectivityResult.none];
      expect(result.hasConnectivity, false, reason: 'list: $result');
    });

    test('returns true when wifi is present', () {
      final result = [ConnectivityResult.wifi];
      expect(result.hasConnectivity, true, reason: 'list: $result');
    });

    test('returns true when multiple connections exist', () {
      final result = ConnectivityResult.values.toList()
        ..removeWhere((e) => e == ConnectivityResult.none);
      expect(result.hasConnectivity, true, reason: 'list: $result');
    });
  });
}
