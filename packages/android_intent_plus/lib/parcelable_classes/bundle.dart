import 'package:android_intent_plus/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bundle.g.dart';

@JsonSerializable()
class Bundle extends ParcelableBase {
  factory Bundle.create({
    required List<PutBase> values,
  }) =>
      Bundle(
        javaClass: 'Bundle',
        values: values,
      );

  Bundle({
    required String javaClass,
    required this.values,
  }) : super(
          javaClass: javaClass,
        );

  final List<PutBase> values;

  factory Bundle.fromJson(Map<String, dynamic> json) => _$BundleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BundleToJson(this);
}
