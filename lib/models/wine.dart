import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'taste_profile.dart';
import 'cuisine_pairing.dart';

class BilingualText {
  final String zh;
  final String en;

  const BilingualText({required this.zh, required this.en});

  factory BilingualText.fromJson(Map<String, dynamic> json) {
    return BilingualText(
      zh: (json['zh'] as String?) ?? '',
      en: (json['en'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'zh': zh, 'en': en};
}

class SocialSurvivalScript {
  final BilingualText theHook;      // Point 1: Prestige fact
  final BilingualText theGrape;     // Point 2: Grape character
  final BilingualText theRegion;    // Point 3: Terroir impact
  final BilingualText theVintage;   // Point 4: Vintage insight
  final BilingualText theTaste;     // Point 5: Sensory trip

  const SocialSurvivalScript({
    required this.theHook,
    required this.theGrape,
    required this.theRegion,
    required this.theVintage,
    required this.theTaste,
  });

  factory SocialSurvivalScript.fromJson(Map<String, dynamic> json) {
    return SocialSurvivalScript(
      theHook: BilingualText.fromJson(
          (json['the_hook'] as Map<String, dynamic>?) ?? {}),
      theGrape: BilingualText.fromJson(
          (json['the_grape'] as Map<String, dynamic>?) ?? {}),
      theRegion: BilingualText.fromJson(
          (json['the_region'] as Map<String, dynamic>?) ?? {}),
      theVintage: BilingualText.fromJson(
          (json['the_vintage'] as Map<String, dynamic>?) ?? {}),
      theTaste: BilingualText.fromJson(
          (json['the_taste'] as Map<String, dynamic>?) ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'the_hook': theHook.toJson(),
        'the_grape': theGrape.toJson(),
        'the_region': theRegion.toJson(),
        'the_vintage': theVintage.toJson(),
        'the_taste': theTaste.toJson(),
      };
}

class RecommendedDish {
  final String dish;
  final String zh;
  final String why;

  const RecommendedDish({
    required this.dish,
    required this.zh,
    required this.why,
  });

  factory RecommendedDish.fromJson(Map<String, dynamic> json) {
    return RecommendedDish(
      dish: (json['dish'] as String?) ?? '',
      zh: (json['zh'] as String?) ?? '',
      why: (json['why'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'dish': dish, 'zh': zh, 'why': why};
}

class Wine {
  final int? id;
  final String fingerprint;
  final String wineName;
  final String vintage;
  final String winery;
  final String region;
  final String country;
  final String grapeVariety;
  final String alcoholContent;
  final TasteProfile tasteProfile;
  final int worldPercentile;
  final int regionPercentile;
  final String? rawResponseJson;
  final DateTime? createdAt;
  final DateTime? lastAccessed;

  const Wine({
    this.id,
    required this.fingerprint,
    required this.wineName,
    required this.vintage,
    required this.winery,
    required this.region,
    required this.country,
    required this.grapeVariety,
    required this.alcoholContent,
    required this.tasteProfile,
    required this.worldPercentile,
    required this.regionPercentile,
    this.rawResponseJson,
    this.createdAt,
    this.lastAccessed,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(
      id: json['id'] as int?,
      fingerprint: (json['fingerprint'] as String?) ?? '',
      wineName: (json['wine_name'] as String?) ?? '',
      vintage: (json['vintage'] as String?) ?? '',
      winery: (json['winery'] as String?) ?? '',
      region: (json['region'] as String?) ?? '',
      country: (json['country'] as String?) ?? '',
      grapeVariety: (json['grape_variety'] as String?) ?? '',
      alcoholContent: (json['alcohol_content'] as String?) ?? '',
      tasteProfile: TasteProfile.fromJson(
          (json['taste_profile'] as Map<String, dynamic>?) ?? {}),
      worldPercentile:
          (json['rankings']?['world_percentile'] as num?)?.toInt() ?? 0,
      regionPercentile:
          (json['rankings']?['region_percentile'] as num?)?.toInt() ?? 0,
      rawResponseJson: json['raw_response_json'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      lastAccessed: json['last_accessed'] != null
          ? DateTime.tryParse(json['last_accessed'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'fingerprint': fingerprint,
        'wine_name': wineName,
        'vintage': vintage,
        'winery': winery,
        'region': region,
        'country': country,
        'grape_variety': grapeVariety,
        'alcohol_content': alcoholContent,
        'taste_profile': tasteProfile.toJson(),
        'rankings': {
          'world_percentile': worldPercentile,
          'region_percentile': regionPercentile,
        },
        if (rawResponseJson != null) 'raw_response_json': rawResponseJson,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (lastAccessed != null)
          'last_accessed': lastAccessed!.toIso8601String(),
      };

  static String generateFingerprint(String wineName, String vintage) {
    final data = '${wineName.toLowerCase()}|${vintage.toLowerCase()}';
    return md5.convert(utf8.encode(data)).toString();
  }

  /// Parse full LLM response JSON into Wine + CuisinePairing
  static ({Wine wine, CuisinePairing pairing}) fromLlmResponse(
    Map<String, dynamic> json,
    String selectedCuisine,
  ) {
    final wineName = (json['wine_name'] as String?) ?? '';
    final vintage = (json['vintage'] as String?) ?? '';
    final fingerprint = generateFingerprint(wineName, vintage);

    final wine = Wine(
      fingerprint: fingerprint,
      wineName: wineName,
      vintage: vintage,
      winery: (json['winery'] as String?) ?? '',
      region: (json['region'] as String?) ?? '',
      country: (json['country'] as String?) ?? '',
      grapeVariety: (json['grape_variety'] as String?) ?? '',
      alcoholContent: (json['alcohol_content'] as String?) ?? '',
      tasteProfile: TasteProfile.fromJson(
          (json['taste_profile'] as Map<String, dynamic>?) ?? {}),
      worldPercentile:
          (json['rankings']?['world_percentile'] as num?)?.toInt() ?? 0,
      regionPercentile:
          (json['rankings']?['region_percentile'] as num?)?.toInt() ?? 0,
      rawResponseJson: jsonEncode(json),
    );

    final compatJson =
        (json['compatibility'] as Map<String, dynamic>?) ?? {};
    // Support both old 'social_survival_script' and new 'social_scripts' field names
    final socialJson =
        (json['social_scripts'] as Map<String, dynamic>?) ??
        (json['social_survival_script'] as Map<String, dynamic>?) ??
        {};
    final dishesJson =
        (json['recommended_dishes'] as List<dynamic>?) ?? [];

    final pairing = CuisinePairing(
      cuisine: selectedCuisine,
      compatibilityScore:
          (compatJson['score'] as num?)?.toInt() ?? 0,
      socialScript: SocialSurvivalScript.fromJson(socialJson),
      recommendedDishes: dishesJson
          .map((d) =>
              RecommendedDish.fromJson(d as Map<String, dynamic>))
          .toList(),
    );

    return (wine: wine, pairing: pairing);
  }
}
