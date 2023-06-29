import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutStringArrayList extends PutBase<List<String>> {
  PutStringArrayList({required String key, required List<String> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutStringArrayList';
}
