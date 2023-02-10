// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_string_array_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutStringArrayList _$PutStringArrayListFromJson(Map<String, dynamic> json) =>
    PutStringArrayList(
      key: json['key'] as String,
      javaClass: json['javaClass'] as String,
      values:
          (json['values'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PutStringArrayListToJson(PutStringArrayList instance) =>
    <String, dynamic>{
      'key': instance.key,
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
