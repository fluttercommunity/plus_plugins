import 'package:android_intent_plus/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_parcelable_array.g.dart';

@JsonSerializable()
class PutParcelableArray extends PutBase {
  factory PutParcelableArray.create({
    required String key,
    required List<ParcelableBase> values,
  }) =>
      PutParcelableArray(
        key: key,
        javaClass: 'PutParcelableArray',
        values: values,
      );

  PutParcelableArray({
    required String key,
    required String javaClass,
    required this.values,
  }) : super(
          key: key,
          javaClass: javaClass,
        );

  final List<ParcelableBase> values;

  factory PutParcelableArray.fromJson(Map<String, dynamic> json) =>
      _$PutParcelableArrayFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PutParcelableArrayToJson(this);
}
