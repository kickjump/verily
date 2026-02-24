// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocoding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Searches for places via the server-side Mapbox geocoding proxy.

@ProviderFor(placeSearch)
final placeSearchProvider = PlaceSearchFamily._();

/// Searches for places via the server-side Mapbox geocoding proxy.

final class PlaceSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PlaceSearchResult>>,
          List<PlaceSearchResult>,
          FutureOr<List<PlaceSearchResult>>
        >
    with
        $FutureModifier<List<PlaceSearchResult>>,
        $FutureProvider<List<PlaceSearchResult>> {
  /// Searches for places via the server-side Mapbox geocoding proxy.
  PlaceSearchProvider._({
    required PlaceSearchFamily super.from,
    required (String, double?, double?) super.argument,
  }) : super(
         retry: null,
         name: r'placeSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$placeSearchHash();

  @override
  String toString() {
    return r'placeSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<PlaceSearchResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PlaceSearchResult>> create(Ref ref) {
    final argument = this.argument as (String, double?, double?);
    return placeSearch(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$placeSearchHash() => r'bc2e5d6cbf4a1d14d51757030b769954912d9203';

/// Searches for places via the server-side Mapbox geocoding proxy.

final class PlaceSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<PlaceSearchResult>>,
          (String, double?, double?)
        > {
  PlaceSearchFamily._()
    : super(
        retry: null,
        name: r'placeSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Searches for places via the server-side Mapbox geocoding proxy.

  PlaceSearchProvider call(String query, double? lat, double? lng) =>
      PlaceSearchProvider._(argument: (query, lat, lng), from: this);

  @override
  String toString() => r'placeSearchProvider';
}
