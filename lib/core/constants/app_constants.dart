class AppConstants {
  AppConstants._();

  static const String appName = 'Wine AI';
  static const String appTagline = 'Social Survival for Business Dinners';

  // Navigation
  static const String tabContext = 'Context';
  static const String tabScan = 'Scan';
  static const String tabVault = 'Vault';

  // Context Screen
  static const String contextTitle = 'Your Context';
  static const String contextSubtitle =
      'Help us tailor wine recommendations for your business dinners';
  static const String budgetLabel = 'Typical Bottle Budget (HKD)';
  static const String occupationLabel = 'Your Occupation / Industry';
  static const String occupationHint =
      'e.g., ESG Consultant, Investment Banking';
  static const String saveContextButton = 'Save Context';

  // Scanner Screen
  static const String scannerTitle = 'Scan Wine';
  static const String scannerSubtitle =
      'Take a photo of the wine label or menu';
  static const String scanButtonLabel = 'Capture Wine Label';
  static const String analyzingLabel = 'Analyzing...';

  // Results Screen
  static const String resultsTitle = 'Wine Analysis';
  static const String identitySection = 'Wine Identity';
  static const String benchmarksSection = 'Benchmarks';
  static const String tasteSection = 'Taste Profile';
  static const String servingSection = 'Serving Intel';
  static const String scriptsSection = 'Social Scripts';
  static const String pairingSection = 'Dynamic Pairing';
  static const String selectCuisineLabel = 'Select Cuisine';

  // Vault Screen
  static const String vaultTitle = 'Your Vault';
  static const String totalFaceEarned = 'Total Face Earned';
  static const String totalScannedValue = 'Total Scanned Value';
  static const String scanHistoryLabel = 'Scan History';
  static const String emptyVaultMessage =
      'No wines scanned yet. Start building your vault!';

  // Cuisine Options
  static const List<String> cuisines = [
    'Cantonese',
    'Sichuan',
    'Japanese',
    'Western',
    'Italian',
    'French',
  ];

  // Budget Ranges (HKD)
  static const List<int> budgetOptions = [200, 500, 1000, 2000, 5000, 10000];

  // Database
  static const String dbName = 'wine_ai.db';
  static const int dbVersion = 1;

  // API
  static const String kimiApiUrl =
      'https://api.moonshot.ai/v1/chat/completions';
  static const String kimiModel = 'moonshot-v1-8k-vision-preview';

  // Timeouts & Retries
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 2;

  // Image constraints
  static const double maxImageWidth = 1200;
  static const double maxImageHeight = 1200;
  static const int imageQuality = 85;
}
