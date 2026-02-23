import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

/// Abstract email sender for authentication flows.
abstract class EmailSender {
  void sendVerificationCode(
    Session session, {
    required String email,
    required String code,
  });

  void sendPasswordResetCode(
    Session session, {
    required String email,
    required String code,
  });
}

/// Logs verification codes to the console (development only).
class ConsoleEmailSender implements EmailSender {
  final _log = VLogger('ConsoleEmailSender');

  @override
  void sendVerificationCode(
    Session session, {
    required String email,
    required String code,
  }) {
    _log.info('Verification code for $email: $code');
  }

  @override
  void sendPasswordResetCode(
    Session session, {
    required String email,
    required String code,
  }) {
    _log.info('Password reset code for $email: $code');
  }
}
