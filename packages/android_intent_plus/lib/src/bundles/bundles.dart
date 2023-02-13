import 'package:android_intent_plus/src/parcelable_classes/bundle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bundles.g.dart';

@JsonSerializable(createFactory: false)
class Bundles {
  Bundles({required this.values});

  final List<Bundle> values;

  String get javaClass => 'Bundles';

  Map<String, dynamic> toJson() => _$BundlesToJson(this);
}
