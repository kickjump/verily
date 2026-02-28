// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the list of wallets for the authenticated user.

@ProviderFor(userWallets)
final userWalletsProvider = UserWalletsProvider._();

/// Provides the list of wallets for the authenticated user.

final class UserWalletsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SolanaWallet>>,
          List<SolanaWallet>,
          FutureOr<List<SolanaWallet>>
        >
    with
        $FutureModifier<List<SolanaWallet>>,
        $FutureProvider<List<SolanaWallet>> {
  /// Provides the list of wallets for the authenticated user.
  UserWalletsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userWalletsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userWalletsHash();

  @$internal
  @override
  $FutureProviderElement<List<SolanaWallet>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SolanaWallet>> create(Ref ref) {
    return userWallets(ref);
  }
}

String _$userWalletsHash() => r'a5d0069a13b74a3c38d6e14dd7e0884c308f62fe';

/// Provides the SOL balance of the user's default wallet.

@ProviderFor(walletBalance)
final walletBalanceProvider = WalletBalanceProvider._();

/// Provides the SOL balance of the user's default wallet.

final class WalletBalanceProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Provides the SOL balance of the user's default wallet.
  WalletBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletBalanceHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return walletBalance(ref);
  }
}

String _$walletBalanceHash() => r'49c4355396b480d4d23f84d90cc59cf7612bc8c4';

/// Manages wallet creation and linking.

@ProviderFor(WalletManager)
final walletManagerProvider = WalletManagerProvider._();

/// Manages wallet creation and linking.
final class WalletManagerProvider
    extends $NotifierProvider<WalletManager, AsyncValue<SolanaWallet?>> {
  /// Manages wallet creation and linking.
  WalletManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletManagerHash();

  @$internal
  @override
  WalletManager create() => WalletManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SolanaWallet?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SolanaWallet?>>(value),
    );
  }
}

String _$walletManagerHash() => r'5432f0b51b6f9064c9994dc43aeb272c315e9a7e';

/// Manages wallet creation and linking.

abstract class _$WalletManager extends $Notifier<AsyncValue<SolanaWallet?>> {
  AsyncValue<SolanaWallet?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SolanaWallet?>, AsyncValue<SolanaWallet?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SolanaWallet?>, AsyncValue<SolanaWallet?>>,
              AsyncValue<SolanaWallet?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
