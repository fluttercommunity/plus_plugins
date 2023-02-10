import 'package:json_annotation/json_annotation.dart';

part 'parcelable_base.g.dart';

@JsonSerializable()
class ParcelableBase {
  ParcelableBase({
    required this.javaClass,
  });

  final String javaClass;

  factory ParcelableBase.fromJson(Map<String, dynamic> json) =>
      _$ParcelableBaseFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelableBaseToJson(this);
}
