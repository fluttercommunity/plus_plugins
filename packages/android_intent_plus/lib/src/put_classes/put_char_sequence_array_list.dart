import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutCharSequenceArrayList extends PutBase<List<String>> {
  PutCharSequenceArrayList({required String key, required List<String> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutCharSequenceArrayList';

  factory PutCharSequenceArrayList.fromJson(
      {required String key, required dynamic value}) {
    return PutCharSequenceArrayList(key: key, value: List<String>.from(value));
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
