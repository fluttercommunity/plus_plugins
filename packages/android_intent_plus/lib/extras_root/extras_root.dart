import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'extras_root.g.dart';

@JsonSerializable()
class ExtrasRoot {
  ExtrasRoot({
    required this.extras,
  });

  final List<PutBase> extras;

  factory ExtrasRoot.fromJson(Map<String, dynamic> json) =>
      _$ExtrasRootFromJson(json);

  Map<String, dynamic> toJson() => _$ExtrasRootToJson(this);
}
