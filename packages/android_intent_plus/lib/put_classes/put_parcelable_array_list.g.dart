// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_parcelable_array_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutParcelableArrayList _$PutParcelableArrayListFromJson(
        Map<String, dynamic> json) =>
    PutParcelableArrayList(
      key: json['key'] as String,
      javaClass: json['javaClass'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => ParcelableBase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PutParcelableArrayListToJson(
        PutParcelableArrayList instance) =>
    <String, dynamic>{
      'key': instance.key,
      'javaClass': instance.javaClass,
      'values': instance.values,
    };
