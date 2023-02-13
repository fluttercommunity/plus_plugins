import 'package:json_annotation/json_annotation.dart';

part 'put_base.g.dart';

@JsonSerializable(createFactory: false)
abstract class PutBase {
  PutBase({required this.key});

  final String key;

  String get javaClass;

  Map<String, dynamic> toJson() => _$PutBaseToJson(this);
}
