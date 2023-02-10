import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_bundle.g.dart';

@JsonSerializable()
class PutBundle extends PutBase {
  factory PutBundle.create({
    required String key,
    required List<PutBase> values,
  }) =>
      PutBundle(
        key: key,
        javaClass: 'PutBundle',
        values: values,
      );

  PutBundle({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<PutBase> values;

  factory PutBundle.fromJson(Map<String, dynamic> json) =>
      _$PutBundleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutBundleToJson(this);
}
