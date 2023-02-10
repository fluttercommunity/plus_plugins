import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_int.g.dart';

@JsonSerializable()
class PutInt extends PutBase {
  factory PutInt.create({
    required String key,
    required int value,
  }) =>
      PutInt(
        key: key,
        javaClass: 'PutInt',
        value: value,
      );

  PutInt({
    required String key,
    required String javaClass,
    required this.value,
  }) : super(
          key: key,
          javaClass: javaClass,
        );
  final int value;

  factory PutInt.fromJson(Map<String, dynamic> json) => _$PutIntFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutIntToJson(this);
}
