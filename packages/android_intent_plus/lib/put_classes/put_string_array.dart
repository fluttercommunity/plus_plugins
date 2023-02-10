import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_string_array.g.dart';

@JsonSerializable()
class PutStringArray extends PutBase {
  factory PutStringArray.create({
    required String key,
    required List<String> values,
  }) =>
      PutStringArray(
        key: key,
        javaClass: 'PutStringArray',
        values: values,
      );

  PutStringArray({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<String> values;

  factory PutStringArray.fromJson(Map<String, dynamic> json) =>
      _$PutStringArrayFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutStringArrayToJson(this);
}
