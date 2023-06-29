import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutBoolArray extends PutBase<List<bool>> {
  PutBoolArray({required String key, required List<bool> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutBoolArray';

  factory PutBoolArray.fromJson({required String key, required dynamic value}) {
    return PutBoolArray(key: key, value: List<bool>.from(value));
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
