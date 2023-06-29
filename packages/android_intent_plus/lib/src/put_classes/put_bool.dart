import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutBool extends PutBase<bool> {
  PutBool({required String key, required bool value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutBool';
}
