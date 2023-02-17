import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutString extends PutBase<String> {
  PutString({required String key, required value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutString';
}
