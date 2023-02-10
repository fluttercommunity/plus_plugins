import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_bundle_parcelable_array.g.dart';

@JsonSerializable()
class PutBundleParcelableArray extends PutBase {
  factory PutBundleParcelableArray.create({
    required String key,
    required List<List<PutBase>> values,
  }) =>
      PutBundleParcelableArray(
        key: key,
        javaClass: 'PutBundleParcelableArray',
        values: values,
      );

  PutBundleParcelableArray({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<List<PutBase>> values;

  factory PutBundleParcelableArray.fromJson(Map<String, dynamic> json) =>
      _$PutBundleParcelableArrayFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutBundleParcelableArrayToJson(this);
}
