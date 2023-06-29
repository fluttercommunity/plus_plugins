import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutBundle extends PutBase<List<PutBase>> {
  PutBundle({required String key, required List<PutBase> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutBundle';

  factory PutBundle.fromJson({required String key, required dynamic value}) {
    return PutBundle(key: key, value: Bundle.fromJson(value).value);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'javaClass': javaClass,
      'value': value.map((e) => e.toJson()).toList(),
    };
  }
}
