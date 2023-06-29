import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutDoubleArray extends PutBase<List<double>> {
  PutDoubleArray({required String key, required List<double> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutDoubleArray';

  factory PutDoubleArray.fromJson(
      {required String key, required dynamic value}) {
    return PutDoubleArray(key: key, value: List<double>.from(value));
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
