import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutInt extends PutBase<int> {
  PutInt({required String key, required int value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutInt';
}
