// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_bool_array.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutBoolArray _$PutBoolArrayFromJson(Map<String, dynamic> json) => PutBoolArray(
      key: json['key'] as String,
      javaClass: json['javaClass'] as String,
      values: (json['values'] as List<dynamic>).map((e) => e as bool).toList(),
    );

Map<String, dynamic> _$PutBoolArrayToJson(PutBoolArray instance) =>
    <String, dynamic>{
      'key': instance.key,
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
