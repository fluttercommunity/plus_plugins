import 'package:json_annotation/json_annotation.dart';

part 'put_base.g.dart';

@JsonSerializable()
class PutBase {
  PutBase({
    required this.key,
    required this.javaClass,
  });

  final String key;
  final String javaClass;

  factory PutBase.fromJson(Map<String, dynamic> json) =>
      _$PutBaseFromJson(json);

  Map<String, dynamic> toJson() => _$PutBaseToJson(this);
}
