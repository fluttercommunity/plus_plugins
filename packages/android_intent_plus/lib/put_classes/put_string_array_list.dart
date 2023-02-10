import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_string_array_list.g.dart';

@JsonSerializable()
class PutStringArrayList extends PutBase {
  factory PutStringArrayList.create({
    required String key,
    required List<String> values,
  }) =>
      PutStringArrayList(
        key: key,
        javaClass: 'PutStringArrayList',
        values: values,
      );

  PutStringArrayList({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<String> values;

  factory PutStringArrayList.fromJson(Map<String, dynamic> json) =>
      _$PutStringArrayListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutStringArrayListToJson(this);
}
