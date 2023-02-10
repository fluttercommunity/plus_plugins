import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_bool_array.g.dart';

@JsonSerializable()
class PutBoolArray extends PutBase {
  factory PutBoolArray.create({
    required String key,
    required List<bool> values,
  }) =>
      PutBoolArray(
        key: key,
        javaClass: 'PutBoolArray',
        values: values,
      );

  PutBoolArray({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<bool> values;

  factory PutBoolArray.fromJson(Map<String, dynamic> json) =>
      _$PutBoolArrayFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutBoolArrayToJson(this);
}
