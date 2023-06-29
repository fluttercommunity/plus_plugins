import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutFloat extends PutBase<double> {
  PutFloat({required String key, required double value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutFloat';

  factory PutFloat.fromJson({required String key, required dynamic value}) {
    return PutFloat(key: key, value: value as double);
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
