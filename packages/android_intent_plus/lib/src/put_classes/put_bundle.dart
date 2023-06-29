import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutBundle extends PutBase<List<PutBase>> {
  PutBundle({required String key, required List<PutBase> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutBundle';
}
