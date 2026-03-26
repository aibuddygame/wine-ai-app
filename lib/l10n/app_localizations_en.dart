// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Wine AI';

  @override
  String get tabContext => 'Context';

  @override
  String get tabScan => 'Scan';

  @override
  String get tabVault => 'Vault';

  @override
  String get contextTitle => 'Your Context';

  @override
  String get contextSubtitle =>
      'Help us tailor wine recommendations for your business dinners';

  @override
  String get occupationLabel => 'Your Occupation / Industry';

  @override
  String get occupationHint => 'e.g., ESG Consultant, Investment Banking';

  @override
  String get budgetLabel => 'Typical Bottle Budget (HKD)';

  @override
  String get saveContextButton => 'Save Context';

  @override
  String get editContext => 'Edit Context';

  @override
  String get cancel => 'Cancel';

  @override
  String get scannerTitle => 'Scan Wine';

  @override
  String get scannerSubtitle => 'Take a photo of the wine label or menu';

  @override
  String get captureButton => 'Capture';

  @override
  String get galleryButton => 'Choose from Gallery';

  @override
  String get analyzingLabel => 'Analyzing...';

  @override
  String get analyzingSubtitle => 'Our AI Sommelier is analyzing your wine';

  @override
  String get positionLabel => 'Position wine label\nwithin frame';

  @override
  String get apiKeyWarning =>
      'API key not configured. Set KIMI_API_KEY to enable scanning.';

  @override
  String get resultsTitle => 'Wine Analysis';

  @override
  String get regionStyle => 'Region & Style';

  @override
  String get priceBenchmarks => 'Price & Benchmarks';

  @override
  String get averagePrice => 'Average Price';

  @override
  String get globalRanking => 'Global Ranking';

  @override
  String get regionalRanking => 'Regional Ranking';

  @override
  String topPercent(int percent, String scope) {
    return 'Top $percent% in $scope';
  }

  @override
  String get tasteProfile => 'Taste Profile';

  @override
  String get body => 'Body';

  @override
  String get tannin => 'Tannin';

  @override
  String get sweetness => 'Sweetness';

  @override
  String get acidity => 'Acidity';

  @override
  String get light => 'Light';

  @override
  String get bold => 'Bold';

  @override
  String get smooth => 'Smooth';

  @override
  String get tannic => 'Tannic';

  @override
  String get dry => 'Dry';

  @override
  String get sweet => 'Sweet';

  @override
  String get soft => 'Soft';

  @override
  String get acidic => 'Acidic';

  @override
  String get flavors => 'Flavors';

  @override
  String get primary => 'Primary';

  @override
  String get secondary => 'Secondary';

  @override
  String get tertiary => 'Tertiary (with age)';

  @override
  String get communityMentions => 'Community Mentions';

  @override
  String get socialScripts => 'Social Scripts';

  @override
  String get theHook => 'The Hook';

  @override
  String get theObservation => 'The Observation';

  @override
  String get theQuestion => 'The Question';

  @override
  String get serving => 'Serving';

  @override
  String get temperature => 'Temperature';

  @override
  String get decanting => 'Decanting';

  @override
  String get glass => 'Glass';

  @override
  String get proTip => 'Pro Tip';

  @override
  String get grapes => 'Grapes';

  @override
  String get aboutGrapes => 'About the Grapes';

  @override
  String get pairing => 'Pairing';

  @override
  String get matchScore => 'Match Score';

  @override
  String get goesWellWith => 'Goes well with:';

  @override
  String get avoid => 'Avoid';

  @override
  String get ranking => 'Ranking';

  @override
  String get world => 'World';

  @override
  String get community => 'Community';

  @override
  String get reviews => 'Reviews';

  @override
  String get ratings => 'ratings';

  @override
  String get saveToVault => 'SAVE TO VAULT';

  @override
  String get faceEarned => 'Face Earned';

  @override
  String get points => 'points';

  @override
  String get saved => 'Saved to Vault!';

  @override
  String get vaultTitle => 'Your Vault';

  @override
  String get vaultSubtitle => 'Your wine journey and achievements';

  @override
  String get totalFaceEarned => 'Total Face Earned';

  @override
  String get totalScannedValue => 'Total Scanned Value';

  @override
  String get winesScanned => 'Wines Scanned';

  @override
  String get yourTier => 'Your Tier';

  @override
  String get favoriteCuisine => 'Favorite Cuisine';

  @override
  String get scanHistory => 'Scan History';

  @override
  String get refresh => 'Refresh';

  @override
  String get emptyVault => 'No wines scanned yet. Start building your vault!';

  @override
  String get startScanning => 'Start Scanning';

  @override
  String get climate => 'Climate';

  @override
  String get profile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get traditionalChinese => '繁體中文';
}
