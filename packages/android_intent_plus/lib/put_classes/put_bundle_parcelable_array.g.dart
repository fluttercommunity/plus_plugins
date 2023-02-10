// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_bundle_parcelable_array.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutBundleParcelableArray _$PutBundleParcelableArrayFromJson(
        Map<String, dynamic> json) =>
    PutBundleParcelableArray(
      key: json['key'] as String,
      javaClass: json['javaClass'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => PutBase.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$PutBundleParcelableArrayToJson(
        PutBundleParcelableArray instance) =>
    <String, dynamic>{
      'key': instance.key,
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
