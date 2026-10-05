class Env {
  // Use --dart-define=API_BASE_URL=... to override
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000', // Default for Android Emulator
  );

  // Use --dart-define=EYE_TRACKING_URL=... to override
  static const String eyeTrackingUrl = String.fromEnvironment(
    'EYE_TRACKING_URL',
    defaultValue: 'http://10.0.2.2:8000', // Default for Android Emulator
  );
}
