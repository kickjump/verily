// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serverpod_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the Serverpod [Client] used for all backend communication.
///
/// The client is initialized once and reused for the lifetime of the app.

@ProviderFor(serverpodClient)
final serverpodClientProvider = ServerpodClientProvider._();

/// Provides the Serverpod [Client] used for all backend communication.
///
/// The client is initialized once and reused for the lifetime of the app.

final class ServerpodClientProvider
    extends $FunctionalProvider<Client, Client, Client>
    with $Provider<Client> {
  /// Provides the Serverpod [Client] used for all backend communication.
  ///
  /// The client is initialized once and reused for the lifetime of the app.
  ServerpodClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverpodClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverpodClientHash();

  @$internal
  @override
  $ProviderElement<Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Client create(Ref ref) {
    return serverpodClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Client>(value),
    );
  }
}

String _$serverpodClientHash() => r'ca7d523901335953c2ea3aba7d84028b13706b87';
