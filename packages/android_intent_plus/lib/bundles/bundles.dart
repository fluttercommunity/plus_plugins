import 'package:android_intent_plus/parcelable_classes/bundle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bundles.g.dart';

@JsonSerializable()
class Bundles {
  Bundles({
    required this.values,
  });

  final List<Bundle> values;

  factory Bundles.fromJson(Map<String, dynamic> json) =>
      _$BundlesFromJson(json);

  Map<String, dynamic> toJson() => _$BundlesToJson(this);
}
