import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutFloatArray extends PutBase<List<double>> {
  PutFloatArray({required String key, required List<double> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutFloatArray';

  factory PutFloatArray.fromJson(
      {required String key, required dynamic value}) {
    return PutFloatArray(key: key, value: List<double>.from(value));
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
