// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bundle _$BundleFromJson(Map<String, dynamic> json) => Bundle(
      javaClass: json['javaClass'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => PutBase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BundleToJson(Bundle instance) => <String, dynamic>{
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
