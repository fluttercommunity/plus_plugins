import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_bool_array.g.dart';

@JsonSerializable(createFactory: false)
class PutBoolArray extends PutBase {
  PutBoolArray({required String key, required this.values}) : super(key: key);

  final List<bool> values;

  @override
  String get javaClass => 'PutBoolArray';

  @override
  Map<String, dynamic> toJson() => _$PutBoolArrayToJson(this);
}
