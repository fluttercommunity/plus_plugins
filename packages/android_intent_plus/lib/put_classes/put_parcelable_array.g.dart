// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_parcelable_array.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutParcelableArray _$PutParcelableArrayFromJson(Map<String, dynamic> json) =>
    PutParcelableArray(
      key: json['key'] as String,
      javaClass: json['javaClass'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => ParcelableBase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PutParcelableArrayToJson(PutParcelableArray instance) =>
    <String, dynamic>{
      'key': instance.key,
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
