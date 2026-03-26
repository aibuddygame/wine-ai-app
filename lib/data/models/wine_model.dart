import 'dart:convert';
import 'package:crypto/crypto.dart';

class WineIdentity {
  final String fullName;
  final String vintage;
  final String producer;
  final String region;
  final String subRegion;
  final String country;
  final String classification;
  final List<String> grapes;

  const WineIdentity({
    required this.fullName,
    required this.vintage,
    required this.producer,
    required this.region,
    required this.subRegion,
    this.country = '',
    this.classification = '',
    required this.grapes,
  });

  factory WineIdentity.fromJson(Map<String, dynamic> json) {
    return WineIdentity(
      fullName: (json['full_name'] as String?) ?? '',
      vintage: (json['vintage'] as String?) ?? '',
      producer: (json['producer'] as String?) ?? '',
      region: (json['region'] as String?) ?? '',
      subRegion: (json['sub_region'] as String?) ?? '',
      country: (json['country'] as String?) ?? '',
      classification: (json['classification'] as String?) ?? '',
      grapes: (json['grapes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'vintage': vintage,
        'producer': producer,
        'region': region,
        'sub_region': subRegion,
        'country': country,
        'classification': classification,
        'grapes': grapes,
      };
}

class WineBenchmarks {
  final int globalTopPercent;
  final int regionalTopPercent;
  final double averagePrice;
  final String priceCurrency;
  final double? criticScore;

  const WineBenchmarks({
    required this.globalTopPercent,
    required this.regionalTopPercent,
    required this.averagePrice,
    this.priceCurrency = 'HKD',
    this.criticScore,
  });

  factory WineBenchmarks.fromJson(Map<String, dynamic> json) {
    return WineBenchmarks(
      globalTopPercent: (json['global_top_percent'] as num?)?.toInt() ?? 0,
      regionalTopPercent: (json['regional_top_percent'] as num?)?.toInt() ?? 0,
      averagePrice: (json['average_price'] as num?)?.toDouble() ?? 0,
      priceCurrency: (json['price_currency'] as String?) ?? 'HKD',
      criticScore: (json['critic_score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'global_top_percent': globalTopPercent,
        'regional_top_percent': regionalTopPercent,
        'average_price': averagePrice,
        'price_currency': priceCurrency,
        if (criticScore != null) 'critic_score': criticScore,
      };
}

class TasteProfile {
  final int lightBold;
  final int smoothTannic;
  final int drySweet;
  final int softAcidic;
  final Map<String, List<String>> aromaGroups;

  const TasteProfile({
    required this.lightBold,
    required this.smoothTannic,
    required this.drySweet,
    required this.softAcidic,
    required this.aromaGroups,
  });

  factory TasteProfile.fromJson(Map<String, dynamic> json) {
    final rawAroma = json['aroma_groups'];
    final Map<String, List<String>> parsedAroma = {};
    if (rawAroma is Map) {
      for (final entry in rawAroma.entries) {
        final key = entry.key.toString();
        final val = entry.value;
        if (val is List) {
          parsedAroma[key] = val.map((e) => e.toString()).toList();
        }
      }
    }

    return TasteProfile(
      lightBold: ((json['light_bold'] as num?)?.toInt() ?? 50).clamp(0, 100),
      smoothTannic:
          ((json['smooth_tannic'] as num?)?.toInt() ?? 50).clamp(0, 100),
      drySweet: ((json['dry_sweet'] as num?)?.toInt() ?? 50).clamp(0, 100),
      softAcidic:
          ((json['soft_acidic'] as num?)?.toInt() ?? 50).clamp(0, 100),
      aromaGroups: parsedAroma,
    );
  }

  Map<String, dynamic> toJson() => {
        'light_bold': lightBold,
        'smooth_tannic': smoothTannic,
        'dry_sweet': drySweet,
        'soft_acidic': softAcidic,
        'aroma_groups': aromaGroups,
      };
}

class ServingIntel {
  final double temperatureC;
  final String servingTip;
  final String decantingRecommendation;
  final String glasswareRecommendation;

  const ServingIntel({
    required this.temperatureC,
    required this.servingTip,
    required this.decantingRecommendation,
    required this.glasswareRecommendation,
  });

  factory ServingIntel.fromJson(Map<String, dynamic> json) {
    return ServingIntel(
      temperatureC: (json['temperature_c'] as num?)?.toDouble() ?? 16,
      servingTip: (json['serving_tip'] as String?) ?? '',
      decantingRecommendation:
          (json['decanting_recommendation'] as String?) ?? '',
      glasswareRecommendation:
          (json['glassware_recommendation'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'temperature_c': temperatureC,
        'serving_tip': servingTip,
        'decanting_recommendation': decantingRecommendation,
        'glassware_recommendation': glasswareRecommendation,
      };
}

class SocialScripts {
  final String theHook;
  final String theObservation;
  final String theQuestion;

  const SocialScripts({
    required this.theHook,
    required this.theObservation,
    required this.theQuestion,
  });

  factory SocialScripts.fromJson(Map<String, dynamic> json) {
    return SocialScripts(
      theHook: (json['the_hook'] as String?) ?? '',
      theObservation: (json['the_observation'] as String?) ?? '',
      theQuestion: (json['the_question'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'the_hook': theHook,
        'the_observation': theObservation,
        'the_question': theQuestion,
      };
}

class DynamicPairing {
  final String cuisine;
  final String pairingRationale;
  final List<String> dishRecommendations;
  final int pairingScore;
  final List<String> avoidDishes;

  const DynamicPairing({
    required this.cuisine,
    required this.pairingRationale,
    required this.dishRecommendations,
    required this.pairingScore,
    this.avoidDishes = const [],
  });

  factory DynamicPairing.fromJson(Map<String, dynamic> json) {
    return DynamicPairing(
      cuisine: (json['cuisine'] as String?) ?? '',
      pairingRationale: (json['pairing_rationale'] as String?) ?? '',
      dishRecommendations: (json['dish_recommendations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      pairingScore:
          ((json['pairing_score'] as num?)?.toInt() ?? 70).clamp(0, 100),
      avoidDishes: (json['avoid_dishes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'cuisine': cuisine,
        'pairing_rationale': pairingRationale,
        'dish_recommendations': dishRecommendations,
        'pairing_score': pairingScore,
        'avoid_dishes': avoidDishes,
      };
}

/// Region Style Information
class RegionStyle {
  final String description;
  final String climate;
  final String typicalProfile;

  const RegionStyle({
    required this.description,
    required this.climate,
    required this.typicalProfile,
  });

  factory RegionStyle.fromJson(Map<String, dynamic> json) {
    return RegionStyle(
      description: (json['description'] as String?) ?? '',
      climate: (json['climate'] as String?) ?? '',
      typicalProfile: (json['typical_profile'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'climate': climate,
        'typical_profile': typicalProfile,
      };
}

/// Grape Education Information
class GrapeEducation {
  final String variety;
  final String percentage;
  final String description;
  final String characteristics;

  const GrapeEducation({
    required this.variety,
    required this.percentage,
    required this.description,
    required this.characteristics,
  });

  factory GrapeEducation.fromJson(Map<String, dynamic> json) {
    return GrapeEducation(
      variety: (json['variety'] as String?) ?? '',
      percentage: (json['percentage'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      characteristics: (json['characteristics'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'variety': variety,
        'percentage': percentage,
        'description': description,
        'characteristics': characteristics,
      };
}

/// Flavor Profile (What People Talk About)
class FlavorProfile {
  final List<String> primary;
  final List<String> secondary;
  final List<String> tertiary;
  final List<String> communityQuotes;

  const FlavorProfile({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.communityQuotes,
  });

  factory FlavorProfile.fromJson(Map<String, dynamic> json) {
    return FlavorProfile(
      primary: (json['primary'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      secondary: (json['secondary'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tertiary: (json['tertiary'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      communityQuotes: (json['community_quotes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'primary': primary,
        'secondary': secondary,
        'tertiary': tertiary,
        'community_quotes': communityQuotes,
      };
}

/// Community Review
class CommunityReview {
  final double rating;
  final String reviewText;
  final String source;
  final int reviewCount;

  const CommunityReview({
    required this.rating,
    required this.reviewText,
    required this.source,
    required this.reviewCount,
  });

  factory CommunityReview.fromJson(Map<String, dynamic> json) {
    return CommunityReview(
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewText: (json['review_text'] as String?) ?? '',
      source: (json['source'] as String?) ?? '',
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'review_text': reviewText,
        'source': source,
        'review_count': reviewCount,
      };
}

class Wine {
  final String? id;
  final String fingerprint;
  final WineIdentity identity;
  final WineBenchmarks benchmarks;
  final TasteProfile tasteProfile;
  final ServingIntel servingIntel;
  final SocialScripts socialScripts;
  final Map<String, DynamicPairing> pairings;
  final RegionStyle? regionStyle;
  final List<GrapeEducation> grapeEducation;
  final FlavorProfile? flavorProfile;
  final CommunityReview? communityReview;
  final DateTime? createdAt;

  const Wine({
    this.id,
    required this.fingerprint,
    required this.identity,
    required this.benchmarks,
    required this.tasteProfile,
    required this.servingIntel,
    required this.socialScripts,
    required this.pairings,
    this.regionStyle,
    this.grapeEducation = const [],
    this.flavorProfile,
    this.communityReview,
    this.createdAt,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    final rawPairings = json['dynamic_pairing'];
    final Map<String, DynamicPairing> parsedPairings = {};
    if (rawPairings is Map) {
      for (final entry in rawPairings.entries) {
        final key = entry.key.toString();
        final val = entry.value;
        if (val is Map<String, dynamic>) {
          parsedPairings[key] = DynamicPairing.fromJson(val);
        }
      }
    }

    final rawGrapeEd = json['grape_education'];
    final List<GrapeEducation> parsedGrapeEd = [];
    if (rawGrapeEd is List) {
      for (final item in rawGrapeEd) {
        if (item is Map<String, dynamic>) {
          parsedGrapeEd.add(GrapeEducation.fromJson(item));
        }
      }
    }

    return Wine(
      id: json['id']?.toString(),
      fingerprint: (json['fingerprint'] as String?) ?? '',
      identity: WineIdentity.fromJson(
          (json['wine_identity'] as Map<String, dynamic>?) ?? {}),
      benchmarks: WineBenchmarks.fromJson(
          (json['benchmarks'] as Map<String, dynamic>?) ?? {}),
      tasteProfile: TasteProfile.fromJson(
          (json['taste_profile'] as Map<String, dynamic>?) ?? {}),
      servingIntel: ServingIntel.fromJson(
          (json['serving_intel'] as Map<String, dynamic>?) ?? {}),
      socialScripts: SocialScripts.fromJson(
          (json['social_scripts'] as Map<String, dynamic>?) ?? {}),
      pairings: parsedPairings,
      regionStyle: json['region_style'] != null
          ? RegionStyle.fromJson(json['region_style'] as Map<String, dynamic>)
          : null,
      grapeEducation: parsedGrapeEd,
      flavorProfile: json['flavor_profile'] != null
          ? FlavorProfile.fromJson(json['flavor_profile'] as Map<String, dynamic>)
          : null,
      communityReview: json['community_review'] != null
          ? CommunityReview.fromJson(json['community_review'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'fingerprint': fingerprint,
        'wine_identity': identity.toJson(),
        'benchmarks': benchmarks.toJson(),
        'taste_profile': tasteProfile.toJson(),
        'serving_intel': servingIntel.toJson(),
        'social_scripts': socialScripts.toJson(),
        'dynamic_pairing':
            pairings.map((key, value) => MapEntry(key, value.toJson())),
        if (regionStyle != null) 'region_style': regionStyle!.toJson(),
        'grape_education': grapeEducation.map((e) => e.toJson()).toList(),
        if (flavorProfile != null) 'flavor_profile': flavorProfile!.toJson(),
        if (communityReview != null) 'community_review': communityReview!.toJson(),
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      };

  static String generateFingerprint(WineIdentity identity) {
    final data =
        '${identity.producer}|${identity.vintage}|${identity.region}'.toLowerCase();
    return md5.convert(utf8.encode(data)).toString();
  }
}
