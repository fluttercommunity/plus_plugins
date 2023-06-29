import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutBool extends PutBase<bool> {
  PutBool({required String key, required bool value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutBool';

  factory PutBool.fromJson({required String key, required dynamic value}) {
    return PutBool(key: key, value: value as bool);
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
