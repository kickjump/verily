// This is a placeholder file for the Serverpod generated protocol.
// Run `serverpod generate` to regenerate this file after adding models.

library protocol;

export 'package:serverpod/serverpod.dart';

class Protocol extends SerializationManagerServer {
  static final Protocol instance = Protocol();

  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    return super.getClassNameForObject(data);
  }
}
