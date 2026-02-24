/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class PlaceSearchResult implements _i1.SerializableModel {
  PlaceSearchResult._({
    required this.mapboxId,
    required this.name,
    this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.category,
  });

  factory PlaceSearchResult({
    required String mapboxId,
    required String name,
    String? fullAddress,
    required double latitude,
    required double longitude,
    String? category,
  }) = _PlaceSearchResultImpl;

  factory PlaceSearchResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlaceSearchResult(
      mapboxId: jsonSerialization['mapboxId'] as String,
      name: jsonSerialization['name'] as String,
      fullAddress: jsonSerialization['fullAddress'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      category: jsonSerialization['category'] as String?,
    );
  }

  String mapboxId;

  String name;

  String? fullAddress;

  double latitude;

  double longitude;

  String? category;

  /// Returns a shallow copy of this [PlaceSearchResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PlaceSearchResult copyWith({
    String? mapboxId,
    String? name,
    String? fullAddress,
    double? latitude,
    double? longitude,
    String? category,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlaceSearchResult',
      'mapboxId': mapboxId,
      'name': name,
      if (fullAddress != null) 'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      if (category != null) 'category': category,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlaceSearchResultImpl extends PlaceSearchResult {
  _PlaceSearchResultImpl({
    required String mapboxId,
    required String name,
    String? fullAddress,
    required double latitude,
    required double longitude,
    String? category,
  }) : super._(
         mapboxId: mapboxId,
         name: name,
         fullAddress: fullAddress,
         latitude: latitude,
         longitude: longitude,
         category: category,
       );

  /// Returns a shallow copy of this [PlaceSearchResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PlaceSearchResult copyWith({
    String? mapboxId,
    String? name,
    Object? fullAddress = _Undefined,
    double? latitude,
    double? longitude,
    Object? category = _Undefined,
  }) {
    return PlaceSearchResult(
      mapboxId: mapboxId ?? this.mapboxId,
      name: name ?? this.name,
      fullAddress: fullAddress is String? ? fullAddress : this.fullAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category is String? ? category : this.category,
    );
  }
}
