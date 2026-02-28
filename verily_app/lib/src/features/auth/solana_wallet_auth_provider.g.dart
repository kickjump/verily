// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solana_wallet_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides wallet authentication state and operations via Mobile Wallet
/// Adapter on Android.

@ProviderFor(WalletAuth)
final walletAuthProvider = WalletAuthProvider._();

/// Provides wallet authentication state and operations via Mobile Wallet
/// Adapter on Android.
final class WalletAuthProvider
    extends $NotifierProvider<WalletAuth, WalletAuthState> {
  /// Provides wallet authentication state and operations via Mobile Wallet
  /// Adapter on Android.
  WalletAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletAuthHash();

  @$internal
  @override
  WalletAuth create() => WalletAuth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletAuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletAuthState>(value),
    );
  }
}

String _$walletAuthHash() => r'27319b4efbb240e8122ecf6b866e0eae32578598';

/// Provides wallet authentication state and operations via Mobile Wallet
/// Adapter on Android.

abstract class _$WalletAuth extends $Notifier<WalletAuthState> {
  WalletAuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WalletAuthState, WalletAuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WalletAuthState, WalletAuthState>,
              WalletAuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
