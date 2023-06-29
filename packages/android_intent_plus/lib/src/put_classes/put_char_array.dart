import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutCharArray extends PutBase<List<String>> {
  PutCharArray({required String key, required List<String> value})
      : super(key: key, value: value) {
    for (final char in value) {
      final length = char.length;
      if (length != 1) {
        throw RangeError.value(
          length,
          "value.length must be 1.",
        );
      }
    }
  }

  @override
  String get javaClass => 'PutCharArray';

  factory PutCharArray.fromJson({required String key, required dynamic value}) {
    return PutCharArray(key: key, value: List<String>.from(value));
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
