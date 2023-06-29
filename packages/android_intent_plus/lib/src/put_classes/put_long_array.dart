import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutLongArray extends PutBase<List<int>> {
  PutLongArray({required String key, required List<int> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutLongArray';

  factory PutLongArray.fromJson({required String key, required dynamic value}) {
    return PutLongArray(key: key, value: List<int>.from(value));
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
