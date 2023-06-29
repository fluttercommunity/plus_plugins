import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutShort extends PutBase<int> {
  PutShort({required String key, required int value})
      : super(key: key, value: value) {
    if (value < -32768 || value > 32767) {
      throw RangeError.value(
        value,
        "value must be between -32768 and 32768, inclusive.",
      );
    }
  }

  @override
  String get javaClass => 'PutShort';

  factory PutShort.fromJson({required String key, required dynamic value}) {
    return PutShort(key: key, value: value as int);
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
