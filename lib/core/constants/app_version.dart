/// App version constants
/// Update this file when releasing new versions
class AppVersion {
  static const String version = '1.1.0';
  static const int buildNumber = 2;
  static const String fullVersion = 'v$version+$buildNumber';
  
  static const String lastUpdated = '2025-03-29';
  static const String releaseNotes = '''
v1.1.0 (Build 2) - March 29, 2025
- Added scanned wine image display on results page
- Fixed database debug screen to use Hive
- Added cache expiration (30 days)
- Added version number display
- Fixed compilation errors

v1.0.0 (Build 1) - Initial Release
- Wine scanning with Kimi AI
- Social scripts generation
- Vault with gamification
- Traditional Chinese localization
''';
}
