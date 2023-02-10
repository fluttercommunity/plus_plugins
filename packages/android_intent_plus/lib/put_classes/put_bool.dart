import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_bool.g.dart';

@JsonSerializable()
class PutBool extends PutBase {
  factory PutBool.create({
    required String key,
    required bool value,
  }) =>
      PutBool(
        key: key,
        javaClass: 'PutBool',
        value: value,
      );

  PutBool({
    required String key,
    required String javaClass,
    required this.value,
  }) : super(
          key: key,
          javaClass: javaClass,
        );
  final bool value;

  factory PutBool.fromJson(Map<String, dynamic> json) =>
      _$PutBoolFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutBoolToJson(this);
}
