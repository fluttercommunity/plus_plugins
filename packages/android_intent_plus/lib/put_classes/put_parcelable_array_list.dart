import 'package:android_intent_plus/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_parcelable_array_list.g.dart';

@JsonSerializable()
class PutParcelableArrayList extends PutBase {
  factory PutParcelableArrayList.create({
    required String key,
    required List<ParcelableBase> values,
  }) =>
      PutParcelableArrayList(
        key: key,
        javaClass: 'PutParcelableArrayList',
        values: values,
      );

  PutParcelableArrayList({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<ParcelableBase> values;

  factory PutParcelableArrayList.fromJson(Map<String, dynamic> json) =>
      _$PutParcelableArrayListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutParcelableArrayListToJson(this);
}
