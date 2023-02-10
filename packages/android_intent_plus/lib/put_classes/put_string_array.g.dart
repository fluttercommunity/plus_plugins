// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_string_array.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutStringArray _$PutStringArrayFromJson(Map<String, dynamic> json) =>
    PutStringArray(
      key: json['key'] as String,
      javaClass: json['javaClass'] as String,
      values:
          (json['values'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PutStringArrayToJson(PutStringArray instance) =>
    <String, dynamic>{
      'key': instance.key,
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
