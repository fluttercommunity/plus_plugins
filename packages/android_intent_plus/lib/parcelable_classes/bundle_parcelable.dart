import 'package:android_intent_plus/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bundle_parcelable.g.dart';

@JsonSerializable()
class BundleParcelable extends ParcelableBase {
  factory BundleParcelable.create({
    required List<PutBase> values,
  }) =>
      BundleParcelable(
        javaClass: 'BundleParcelable',
        values: values,
      );

  BundleParcelable({
    required String javaClass,
    required this.values,
  }) : super(
          javaClass: javaClass,
        );

  final List<PutBase> values;

  factory BundleParcelable.fromJson(Map<String, dynamic> json) =>
      _$BundleParcelableFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BundleParcelableToJson(this);
}
