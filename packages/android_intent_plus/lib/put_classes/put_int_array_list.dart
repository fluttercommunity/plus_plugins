import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_int_array_list.g.dart';

@JsonSerializable()
class PutIntArrayList extends PutBase {
  factory PutIntArrayList.create({
    required String key,
    required List<int> values,
  }) =>
      PutIntArrayList(
        key: key,
        javaClass: 'PutIntArrayList',
        values: values,
      );

  PutIntArrayList({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<int> values;

  factory PutIntArrayList.fromJson(Map<String, dynamic> json) =>
      _$PutIntArrayListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutIntArrayListToJson(this);
}
