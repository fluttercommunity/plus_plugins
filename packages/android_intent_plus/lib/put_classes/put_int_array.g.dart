// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_int_array.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutIntArray _$PutIntArrayFromJson(Map<String, dynamic> json) => PutIntArray(
      key: json['key'] as String,
      javaClass: json['javaClass'] as String,
      values: (json['values'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PutIntArrayToJson(PutIntArray instance) =>
    <String, dynamic>{
      'key': instance.key,
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
