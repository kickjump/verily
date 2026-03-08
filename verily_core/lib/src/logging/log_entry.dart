import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_entry.freezed.dart';
part 'log_entry.g.dart';

/// A structured log entry that can be serialized for relay between
/// frontend and server.
///
/// Sensitive-data policy:
/// - Never log raw secrets/tokens/private keys/passwords/auth headers.
/// - Never log full emails or wallet addresses; only masked forms.
/// - Treat user-provided free text as sensitive by default.
/// - Prefer explicit, allow-listed fields over dumping payload objects.
@freezed
abstract class LogEntry with _$LogEntry {
  const factory LogEntry({
    required DateTime timestamp,
    required String level,
    required String source,
    required String message,
    required String loggerName,
    String? error,
    String? stackTrace,
    String? environment,
    String? appVersion,
  }) = _LogEntry;

  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      _$LogEntryFromJson(json);
}

/// Centralized helpers for conservative log redaction.
abstract final class LogRedaction {
  static const String redacted = '[REDACTED]';
  static const String masked = '***';

  static final RegExp _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _walletRegExp = RegExp(r'^(0x)?[0-9a-fA-F]{8,}$');

  static bool _looksLikeEmail(String value) => _emailRegExp.hasMatch(value);
  static bool _looksLikeWallet(String value) => _walletRegExp.hasMatch(value);

  static bool _isSensitiveKey(String key) {
    final normalized = key.trim().toLowerCase();
    const sensitiveFragments = <String>[
      'password',
      'secret',
      'token',
      'apikey',
      'api_key',
      'privatekey',
      'private_key',
      'authorization',
      'auth',
      'cookie',
      'session',
      'mnemonic',
      'seed',
      'jwt',
      'bearer',
      'signature',
      'email',
      'wallet',
      'address',
    ];
    return sensitiveFragments.any(normalized.contains);
  }

  static bool _looksLikeSecretValue(String value) {
    final v = value.trim();
    if (v.isEmpty) return false;
    if (v.toLowerCase().startsWith('bearer ')) return true;
    if (v.split('.').length == 3 && v.length > 20) return true; // JWT-like
    return v.length > 24;
  }

  static String redactEmail(String? email) {
    final value = email?.trim() ?? '';
    if (value.isEmpty) return redacted;

    final at = value.indexOf('@');
    if (at <= 0 || at == value.length - 1) return redacted;

    final local = value.substring(0, at);
    final domain = value.substring(at + 1);
    final maskedLocal = local.length <= 2
        ? '${local[0]}*'
        : '${local.substring(0, 2)}***';
    return '$maskedLocal@$domain';
  }

  static String redactWalletAddress(String? walletAddress) {
    final value = walletAddress?.trim() ?? '';
    if (value.isEmpty) return redacted;
    if (value.length <= 10) return masked;
    return '${value.substring(0, 6)}...${value.substring(value.length - 4)}';
  }

  static String redactFreeText(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return redacted;
    return redacted;
  }

  static String redactSecret(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return redacted;
    return masked;
  }

  static Object? redactField(
    String key,
    Object? value, {
    bool isFreeText = false,
  }) {
    if (value == null) return null;

    final stringValue = value.toString();

    if (isFreeText) {
      return redactFreeText(stringValue);
    }

    if (_isSensitiveKey(key)) {
      if (key.toLowerCase().contains('email') || _looksLikeEmail(stringValue)) {
        return redactEmail(stringValue);
      }
      if (key.toLowerCase().contains('wallet') ||
          key.toLowerCase().contains('address') ||
          _looksLikeWallet(stringValue)) {
        return redactWalletAddress(stringValue);
      }
      return redactSecret(stringValue);
    }

    if (_looksLikeEmail(stringValue)) {
      return redactEmail(stringValue);
    }

    if (_looksLikeWallet(stringValue)) {
      return redactWalletAddress(stringValue);
    }

    if (_looksLikeSecretValue(stringValue)) {
      return redactSecret(stringValue);
    }

    return value;
  }
}
