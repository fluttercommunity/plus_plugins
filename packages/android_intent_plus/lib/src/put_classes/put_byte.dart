import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

/// Adds a byte to the bundle in the two's complement binary representation
/// of the specified [value], which must fit in a single byte.
///
/// In other words, [value] must be between -128 and 127, inclusive.
class PutByte extends PutBase<int> {
  PutByte({required String key, required int value})
      : super(key: key, value: value) {
    if (value < -128 || value > 127) {
      throw RangeError.value(
        value,
        "value must be between -128 and 127, inclusive.",
      );
    }
  }

  @override
  String get javaClass => 'PutByte';

  factory PutByte.fromJson({required String key, required dynamic value}) {
    return PutByte(key: key, value: value as int);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'javaClass': javaClass,
      'value': value,
    };
  }
}
