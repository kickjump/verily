/// Whether the app is running in demo mode.
///
/// Set via `--dart-define=DEMO_MODE=true` at build time.
/// In demo mode, authentication is bypassed, location is mocked, and
/// video submissions are simulated.
const isDemoMode = bool.fromEnvironment('DEMO_MODE');

/// Default demo latitude (Central Park, NYC).
final demoLat =
    double.tryParse(const String.fromEnvironment('DEMO_LAT')) ?? 40.7829;

/// Default demo longitude (Central Park, NYC).
final demoLng =
    double.tryParse(const String.fromEnvironment('DEMO_LNG')) ?? -73.9654;
