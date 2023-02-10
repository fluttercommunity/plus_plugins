import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_int_array.g.dart';

@JsonSerializable()
class PutIntArray extends PutBase {
  factory PutIntArray.create({
    required String key,
    required List<int> values,
  }) =>
      PutIntArray(
        key: key,
        javaClass: 'PutIntArray',
        values: values,
      );

  PutIntArray({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<int> values;

  factory PutIntArray.fromJson(Map<String, dynamic> json) =>
      _$PutIntArrayFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutIntArrayToJson(this);
}
