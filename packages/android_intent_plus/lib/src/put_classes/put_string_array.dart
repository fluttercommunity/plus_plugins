import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutStringArray extends PutBase<List<String>> {
  PutStringArray({required String key, required value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutStringArray';
}
