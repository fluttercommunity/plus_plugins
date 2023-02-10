// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_parcelable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleParcelable _$BundleParcelableFromJson(Map<String, dynamic> json) =>
    BundleParcelable(
      javaClass: json['javaClass'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => PutBase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BundleParcelableToJson(BundleParcelable instance) =>
    <String, dynamic>{
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
