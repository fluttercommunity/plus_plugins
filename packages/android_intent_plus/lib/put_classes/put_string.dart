import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_string.g.dart';

@JsonSerializable()
class PutString extends PutBase {
  factory PutString.create({
    required String key,
    required String value,
  }) =>
      PutString(
        key: key,
        javaClass: 'PutString',
        value: value,
      );

  PutString({
    required String key,
    required String javaClass,
    required this.value,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final String value;

  factory PutString.fromJson(Map<String, dynamic> json) =>
      _$PutStringFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutStringToJson(this);
}
