/// Per-project credentials that are NOT part of the Firebase config files
/// (those are generated separately by `flutterfire configure`).
///
/// Copy this file to `app_config.dart` in the same folder and fill in your
/// own values — `app_config.dart` is git-ignored so your credentials never
/// get committed. See the root README's "Getting Started" section for where
/// each value comes from.
class AppConfig {
  /// Google Sign-In "Web client ID" (OAuth 2.0 Client ID, type "Web
  /// application"). Firebase creates one automatically once you enable the
  /// Google sign-in provider under Authentication > Sign-in method — copy it
  /// from Google Cloud Console > APIs & Services > Credentials, or from the
  /// "Web SDK configuration" section of the Google provider settings in the
  /// Firebase Console.
  static const String googleSignInServerClientId =
      'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
}
