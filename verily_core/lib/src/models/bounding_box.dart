import 'package:freezed_annotation/freezed_annotation.dart';

part 'bounding_box.freezed.dart';
part 'bounding_box.g.dart';

/// A geographic bounding box defined by its south-west and north-east corners.
@freezed
abstract class BoundingBox with _$BoundingBox {
  const factory BoundingBox({
    required double southLat,
    required double westLng,
    required double northLat,
    required double eastLng,
  }) = _BoundingBox;

  factory BoundingBox.fromJson(Map<String, dynamic> json) =>
      _$BoundingBoxFromJson(json);
}
