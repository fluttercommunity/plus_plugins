import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutStringArrayList extends PutBase<List<String>> {
  PutStringArrayList({required String key, required List<String> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutStringArrayList';

  factory PutStringArrayList.fromJson({
    required String key,
    required dynamic value,
  }) {
    return PutStringArrayList(key: key, value: List<String>.from(value));
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
