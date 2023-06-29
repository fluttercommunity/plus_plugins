import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutLong extends PutBase<int> {
  PutLong({required String key, required int value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutLong';

  factory PutLong.fromJson({required String key, required dynamic value}) {
    return PutLong(key: key, value: value as int);
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
