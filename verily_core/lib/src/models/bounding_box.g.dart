// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bounding_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BoundingBox _$BoundingBoxFromJson(Map<String, dynamic> json) => _BoundingBox(
  southLat: (json['southLat'] as num).toDouble(),
  westLng: (json['westLng'] as num).toDouble(),
  northLat: (json['northLat'] as num).toDouble(),
  eastLng: (json['eastLng'] as num).toDouble(),
);

Map<String, dynamic> _$BoundingBoxToJson(_BoundingBox instance) =>
    <String, dynamic>{
      'southLat': instance.southLat,
      'westLng': instance.westLng,
      'northLat': instance.northLat,
      'eastLng': instance.eastLng,
    };
