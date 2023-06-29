import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutIntArray extends PutBase<List<int>> {
  PutIntArray({required String key, required List<int> value})
      : super(key: key, value: value) {
    {
      for (final intValue in value) {
        if (intValue < -2147483648 || intValue > 2147483647) {
          throw RangeError.value(
            intValue,
            "value must be between -2147483648 and 2147483647, inclusive.",
          );
        }
      }
    }
  }

  @override
  String get javaClass => 'PutIntArray';

  factory PutIntArray.fromJson({required String key, required dynamic value}) {
    return PutIntArray(key: key, value: List<int>.from(value));
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
