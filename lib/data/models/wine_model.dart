import 'dart:convert';
import 'package:crypto/crypto.dart';

class WineIdentity {
  final String fullName;
  final String vintage;
  final String producer;
  final String region;
  final String subRegion;
  final List<String> grapes;

  const WineIdentity({
    required this.fullName,
    required this.vintage,
    required this.producer,
    required this.region,
    required this.subRegion,
    required this.grapes,
  });

  factory WineIdentity.fromJson(Map<String, dynamic> json) {
    return WineIdentity(
      fullName: (json['full_name'] as String?) ?? '',
      vintage: (json['vintage'] as String?) ?? '',
      producer: (json['producer'] as String?) ?? '',
      region: (json['region'] as String?) ?? '',
      subRegion: (json['sub_region'] as String?) ?? '',
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

  const DynamicPairing({
    required this.cuisine,
    required this.pairingRationale,
    required this.dishRecommendations,
    required this.pairingScore,
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
    );
  }

  Map<String, dynamic> toJson() => {
        'cuisine': cuisine,
        'pairing_rationale': pairingRationale,
        'dish_recommendations': dishRecommendations,
        'pairing_score': pairingScore,
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
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      };

  static String generateFingerprint(WineIdentity identity) {
    final data =
        '${identity.producer}|${identity.vintage}|${identity.region}'.toLowerCase();
    return md5.convert(utf8.encode(data)).toString();
  }
}
