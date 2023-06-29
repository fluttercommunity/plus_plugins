import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutInt extends PutBase<int> {
  PutInt({required String key, required int value})
      : super(key: key, value: value) {
    if (value < -2147483648 || value > 2147483647) {
      throw RangeError.value(
        value,
        "value must be between -2147483648 and 2147483647, inclusive.",
      );
    }
  }

  @override
  String get javaClass => 'PutInt';

  factory PutInt.fromJson({required String key, required dynamic value}) {
    return PutInt(key: key, value: value as int);
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
