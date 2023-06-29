import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutByteArray extends PutBase<List<int>> {
  PutByteArray({required String key, required List<int> value})
      : super(key: key, value: value) {
    for (final byte in value) {
      if (byte < -128 || byte > 127) {
        throw RangeError.value(
          byte,
          "value must be between -128 and 127, inclusive.",
        );
      }
    }
  }

  @override
  String get javaClass => 'PutByteArray';

  factory PutByteArray.fromJson({required String key, required dynamic value}) {
    return PutByteArray(key: key, value: List<int>.from(value));
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
