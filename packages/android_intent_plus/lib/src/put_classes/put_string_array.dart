import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutStringArray extends PutBase<List<String>> {
  PutStringArray({required String key, required List<String> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutStringArray';

  factory PutStringArray.fromJson({
    required String key,
    required dynamic value,
  }) {
    return PutStringArray(key: key, value: List<String>.from(value));
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
