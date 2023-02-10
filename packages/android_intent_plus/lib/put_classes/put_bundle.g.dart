// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutBundle _$PutBundleFromJson(Map<String, dynamic> json) => PutBundle(
      key: json['key'] as String,
      javaClass: json['javaClass'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => PutBase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PutBundleToJson(PutBundle instance) => <String, dynamic>{
      'key': instance.key,
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
