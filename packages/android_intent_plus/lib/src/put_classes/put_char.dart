import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutChar extends PutBase<String> {
  PutChar({required String key, required String value})
      : super(key: key, value: value) {
    final length = value.length;
    if (length != 1) {
      throw RangeError.value(
        length,
        "value.length must be 1.",
      );
    }
  }

  @override
  String get javaClass => 'PutChar';

  factory PutChar.fromJson({required String key, required dynamic value}) {
    return PutChar(key: key, value: value as String);
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
