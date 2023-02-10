// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bundles _$BundlesFromJson(Map<String, dynamic> json) => Bundles(
      values: (json['values'] as List<dynamic>)
          .map((e) => Bundle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BundlesToJson(Bundles instance) => <String, dynamic>{
      'values': instance.values,
    };
