// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extras_root.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtrasRoot _$ExtrasRootFromJson(Map<String, dynamic> json) => ExtrasRoot(
      extras: (json['extras'] as List<dynamic>)
          .map((e) => PutBase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExtrasRootToJson(ExtrasRoot instance) =>
    <String, dynamic>{
      'extras': instance.extras,
    };
