import 'package:json_annotation/json_annotation.dart';

part 'parcelable_base.g.dart';

@JsonSerializable(createFactory: false)
abstract class ParcelableBase {
  String get javaClass;

  Map<String, dynamic> toJson() => _$ParcelableBaseToJson(this);
}
