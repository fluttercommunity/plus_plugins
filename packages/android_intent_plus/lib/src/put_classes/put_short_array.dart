import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutShortArray extends PutBase<List<int>> {
  PutShortArray({required String key, required List<int> value})
      : super(key: key, value: value) {
    {
      for (final intValue in value) {
        if (intValue < -32768 || intValue > 32767) {
          throw RangeError.value(
            intValue,
            "value must be between -32768 and 32767, inclusive.",
          );
        }
      }
    }
  }

  @override
  String get javaClass => 'PutShortArray';

  factory PutShortArray.fromJson(
      {required String key, required dynamic value}) {
    return PutShortArray(key: key, value: List<int>.from(value));
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
