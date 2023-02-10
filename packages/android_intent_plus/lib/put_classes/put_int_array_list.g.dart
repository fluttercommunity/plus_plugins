// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_int_array_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutIntArrayList _$PutIntArrayListFromJson(Map<String, dynamic> json) =>
    PutIntArrayList(
      key: json['key'] as String,
      javaClass: json['javaClass'] as String,
      values: (json['values'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PutIntArrayListToJson(PutIntArrayList instance) =>
    <String, dynamic>{
      'key': instance.key,
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
