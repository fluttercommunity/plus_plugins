import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_bundle_parcelable_array_list.g.dart';

@JsonSerializable()
class PutBundleParcelableArrayList extends PutBase {
  factory PutBundleParcelableArrayList.create({
    required String key,
    required List<List<PutBase>> values,
  }) =>
      PutBundleParcelableArrayList(
        key: key,
        javaClass: 'PutBundleParcelableArrayList',
        values: values,
      );

  PutBundleParcelableArrayList({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<List<PutBase>> values;

  factory PutBundleParcelableArrayList.fromJson(Map<String, dynamic> json) =>
      _$PutBundleParcelableArrayListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutBundleParcelableArrayListToJson(this);
}
