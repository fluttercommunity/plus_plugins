import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_string_array.g.dart';

@JsonSerializable(createFactory: false)
class PutStringArray extends PutBase {
  PutStringArray({required String key, required this.values}) : super(key: key);

  final List<String> values;

  @override
  String get javaClass => 'PutStringArray';

  @override
  Map<String, dynamic> toJson() => _$PutStringArrayToJson(this);
}
