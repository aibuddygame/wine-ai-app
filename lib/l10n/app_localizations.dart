import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Wine AI'**
  String get appName;

  /// Context tab label
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get tabContext;

  /// Scan tab label
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get tabScan;

  /// Vault tab label
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get tabVault;

  /// Context screen title
  ///
  /// In en, this message translates to:
  /// **'Your Context'**
  String get contextTitle;

  /// Context screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Help us tailor wine recommendations for your business dinners'**
  String get contextSubtitle;

  /// Occupation input label
  ///
  /// In en, this message translates to:
  /// **'Your Occupation / Industry'**
  String get occupationLabel;

  /// Occupation input hint
  ///
  /// In en, this message translates to:
  /// **'e.g., ESG Consultant, Investment Banking'**
  String get occupationHint;

  /// Budget selection label
  ///
  /// In en, this message translates to:
  /// **'Typical Bottle Budget (HKD)'**
  String get budgetLabel;

  /// Save context button
  ///
  /// In en, this message translates to:
  /// **'Save Context'**
  String get saveContextButton;

  /// Edit context button
  ///
  /// In en, this message translates to:
  /// **'Edit Context'**
  String get editContext;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Scanner screen title
  ///
  /// In en, this message translates to:
  /// **'Scan Wine'**
  String get scannerTitle;

  /// Scanner screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the wine label or menu'**
  String get scannerSubtitle;

  /// Capture button
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get captureButton;

  /// Gallery button
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get galleryButton;

  /// Analyzing loading text
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzingLabel;

  /// Analyzing subtitle
  ///
  /// In en, this message translates to:
  /// **'Our AI Sommelier is analyzing your wine'**
  String get analyzingSubtitle;

  /// Position label hint
  ///
  /// In en, this message translates to:
  /// **'Position wine label\nwithin frame'**
  String get positionLabel;

  /// API key not configured warning
  ///
  /// In en, this message translates to:
  /// **'API key not configured. Set KIMI_API_KEY to enable scanning.'**
  String get apiKeyWarning;

  /// Results screen title
  ///
  /// In en, this message translates to:
  /// **'Wine Analysis'**
  String get resultsTitle;

  /// Region and style section
  ///
  /// In en, this message translates to:
  /// **'Region & Style'**
  String get regionStyle;

  /// Price and benchmarks section
  ///
  /// In en, this message translates to:
  /// **'Price & Benchmarks'**
  String get priceBenchmarks;

  /// Average price label
  ///
  /// In en, this message translates to:
  /// **'Average Price'**
  String get averagePrice;

  /// Global ranking label
  ///
  /// In en, this message translates to:
  /// **'Global Ranking'**
  String get globalRanking;

  /// Regional ranking label
  ///
  /// In en, this message translates to:
  /// **'Regional Ranking'**
  String get regionalRanking;

  /// Top percentage text
  ///
  /// In en, this message translates to:
  /// **'Top {percent}% in {scope}'**
  String topPercent(int percent, String scope);

  /// Taste profile section
  ///
  /// In en, this message translates to:
  /// **'Taste Profile'**
  String get tasteProfile;

  /// Body taste characteristic
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// Tannin taste characteristic
  ///
  /// In en, this message translates to:
  /// **'Tannin'**
  String get tannin;

  /// Sweetness taste characteristic
  ///
  /// In en, this message translates to:
  /// **'Sweetness'**
  String get sweetness;

  /// Acidity taste characteristic
  ///
  /// In en, this message translates to:
  /// **'Acidity'**
  String get acidity;

  /// Light descriptor
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Bold descriptor
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// Smooth descriptor
  ///
  /// In en, this message translates to:
  /// **'Smooth'**
  String get smooth;

  /// Tannic descriptor
  ///
  /// In en, this message translates to:
  /// **'Tannic'**
  String get tannic;

  /// Dry descriptor
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get dry;

  /// Sweet descriptor
  ///
  /// In en, this message translates to:
  /// **'Sweet'**
  String get sweet;

  /// Soft descriptor
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get soft;

  /// Acidic descriptor
  ///
  /// In en, this message translates to:
  /// **'Acidic'**
  String get acidic;

  /// Flavors section
  ///
  /// In en, this message translates to:
  /// **'Flavors'**
  String get flavors;

  /// Primary aromas
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// Secondary aromas
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondary;

  /// Tertiary aromas
  ///
  /// In en, this message translates to:
  /// **'Tertiary (with age)'**
  String get tertiary;

  /// Community mentions section
  ///
  /// In en, this message translates to:
  /// **'Community Mentions'**
  String get communityMentions;

  /// Social scripts section
  ///
  /// In en, this message translates to:
  /// **'Social Scripts'**
  String get socialScripts;

  /// The Hook script
  ///
  /// In en, this message translates to:
  /// **'The Hook'**
  String get theHook;

  /// The Observation script
  ///
  /// In en, this message translates to:
  /// **'The Observation'**
  String get theObservation;

  /// The Question script
  ///
  /// In en, this message translates to:
  /// **'The Question'**
  String get theQuestion;

  /// Serving section
  ///
  /// In en, this message translates to:
  /// **'Serving'**
  String get serving;

  /// Temperature label
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// Decanting label
  ///
  /// In en, this message translates to:
  /// **'Decanting'**
  String get decanting;

  /// Glass label
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get glass;

  /// Pro tip label
  ///
  /// In en, this message translates to:
  /// **'Pro Tip'**
  String get proTip;

  /// Grapes section
  ///
  /// In en, this message translates to:
  /// **'Grapes'**
  String get grapes;

  /// About the grapes section
  ///
  /// In en, this message translates to:
  /// **'About the Grapes'**
  String get aboutGrapes;

  /// Pairing section
  ///
  /// In en, this message translates to:
  /// **'Pairing'**
  String get pairing;

  /// Match score label
  ///
  /// In en, this message translates to:
  /// **'Match Score'**
  String get matchScore;

  /// Goes well with label
  ///
  /// In en, this message translates to:
  /// **'Goes well with:'**
  String get goesWellWith;

  /// Avoid label
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get avoid;

  /// Ranking section
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// World scope
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get world;

  /// Community section
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// Reviews section
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// Ratings count
  ///
  /// In en, this message translates to:
  /// **'ratings'**
  String get ratings;

  /// Save to vault button
  ///
  /// In en, this message translates to:
  /// **'SAVE TO VAULT'**
  String get saveToVault;

  /// Face earned label
  ///
  /// In en, this message translates to:
  /// **'Face Earned'**
  String get faceEarned;

  /// Points label
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// Saved confirmation
  ///
  /// In en, this message translates to:
  /// **'Saved to Vault!'**
  String get saved;

  /// Vault screen title
  ///
  /// In en, this message translates to:
  /// **'Your Vault'**
  String get vaultTitle;

  /// Vault screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Your wine journey and achievements'**
  String get vaultSubtitle;

  /// Total face earned stat
  ///
  /// In en, this message translates to:
  /// **'Total Face Earned'**
  String get totalFaceEarned;

  /// Total scanned value stat
  ///
  /// In en, this message translates to:
  /// **'Total Scanned Value'**
  String get totalScannedValue;

  /// Wines scanned stat
  ///
  /// In en, this message translates to:
  /// **'Wines Scanned'**
  String get winesScanned;

  /// Your tier stat
  ///
  /// In en, this message translates to:
  /// **'Your Tier'**
  String get yourTier;

  /// Favorite cuisine label
  ///
  /// In en, this message translates to:
  /// **'Favorite Cuisine'**
  String get favoriteCuisine;

  /// Scan history section
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistory;

  /// Refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Empty vault message
  ///
  /// In en, this message translates to:
  /// **'No wines scanned yet. Start building your vault!'**
  String get emptyVault;

  /// Start scanning button
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get startScanning;

  /// Climate label
  ///
  /// In en, this message translates to:
  /// **'Climate'**
  String get climate;

  /// Profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Traditional Chinese language
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get traditionalChinese;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
