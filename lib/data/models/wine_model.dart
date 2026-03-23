/// Wine Identity Data Model
class WineIdentity {
  final String fullName;
  final String vintage;
  final String producer;
  final String region;
  final String subRegion;
  final List<String> grapes;
  final String? imageUrl;

  WineIdentity({
    required this.fullName,
    required this.vintage,
    required this.producer,
    required this.region,
    required this.subRegion,
    required this.grapes,
    this.imageUrl,
  });

  factory WineIdentity.fromJson(Map<String, dynamic> json) {
    return WineIdentity(
      fullName: json['full_name'] ?? '',
      vintage: json['vintage'] ?? '',
      producer: json['producer'] ?? '',
      region: json['region'] ?? '',
      subRegion: json['sub_region'] ?? '',
      grapes: List<String>.from(json['grapes'] ?? []),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'vintage': vintage,
      'producer': producer,
      'region': region,
      'sub_region': subRegion,
      'grapes': grapes,
      'image_url': imageUrl,
    };
  }
}

/// Wine Benchmarks Data Model
class WineBenchmarks {
  final int globalTopPercent;
  final int regionalTopPercent;
  final double averagePrice;
  final String priceCurrency;
  final double? criticScore;

  WineBenchmarks({
    required this.globalTopPercent,
    required this.regionalTopPercent,
    required this.averagePrice,
    required this.priceCurrency,
    this.criticScore,
  });

  factory WineBenchmarks.fromJson(Map<String, dynamic> json) {
    return WineBenchmarks(
      globalTopPercent: json['global_top_percent'] ?? 0,
      regionalTopPercent: json['regional_top_percent'] ?? 0,
      averagePrice: (json['average_price'] ?? 0).toDouble(),
      priceCurrency: json['price_currency'] ?? 'HKD',
      criticScore: json['critic_score']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'global_top_percent': globalTopPercent,
      'regional_top_percent': regionalTopPercent,
      'average_price': averagePrice,
      'price_currency': priceCurrency,
      'critic_score': criticScore,
    };
  }
}

/// Taste Profile Data Model
class TasteProfile {
  final int lightBold; // 0-100
  final int smoothTannic; // 0-100
  final int drySweet; // 0-100
  final int softAcidic; // 0-100
  final Map<String, List<String>> aromaGroups;

  TasteProfile({
    required this.lightBold,
    required this.smoothTannic,
    required this.drySweet,
    required this.softAcidic,
    required this.aromaGroups,
  });

  factory TasteProfile.fromJson(Map<String, dynamic> json) {
    return TasteProfile(
      lightBold: json['light_bold'] ?? 50,
      smoothTannic: json['smooth_tannic'] ?? 50,
      drySweet: json['dry_sweet'] ?? 50,
      softAcidic: json['soft_acidic'] ?? 50,
      aromaGroups: Map<String, List<String>>.from(
        (json['aroma_groups'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'light_bold': lightBold,
      'smooth_tannic': smoothTannic,
      'dry_sweet': drySweet,
      'soft_acidic': softAcidic,
      'aroma_groups': aromaGroups,
    };
  }
}

/// Serving Intel Data Model
class ServingIntel {
  final double temperatureC;
  final String servingTip;
  final String decantingRecommendation;
  final String glasswareRecommendation;

  ServingIntel({
    required this.temperatureC,
    required this.servingTip,
    required this.decantingRecommendation,
    required this.glasswareRecommendation,
  });

  factory ServingIntel.fromJson(Map<String, dynamic> json) {
    return ServingIntel(
      temperatureC: (json['temperature_c'] ?? 16).toDouble(),
      servingTip: json['serving_tip'] ?? '',
      decantingRecommendation: json['decanting_recommendation'] ?? '',
      glasswareRecommendation: json['glassware_recommendation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature_c': temperatureC,
      'serving_tip': servingTip,
      'decanting_recommendation': decantingRecommendation,
      'glassware_recommendation': glasswareRecommendation,
    };
  }
}

/// Social Scripts Data Model
class SocialScripts {
  final String theHook; // Historical/interesting fact
  final String theObservation; // Taste observation
  final String theQuestion; // Engagement question

  SocialScripts({
    required this.theHook,
    required this.theObservation,
    required this.theQuestion,
  });

  factory SocialScripts.fromJson(Map<String, dynamic> json) {
    return SocialScripts(
      theHook: json['the_hook'] ?? '',
      theObservation: json['the_observation'] ?? '',
      theQuestion: json['the_question'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'the_hook': theHook,
      'the_observation': theObservation,
      'the_question': theQuestion,
    };
  }
}

/// Dynamic Pairing Data Model
class DynamicPairing {
  final String cuisine;
  final String pairingRationale;
  final List<String> dishRecommendations;
  final int pairingScore; // 0-100

  DynamicPairing({
    required this.cuisine,
    required this.pairingRationale,
    required this.dishRecommendations,
    required this.pairingScore,
  });

  factory DynamicPairing.fromJson(Map<String, dynamic> json) {
    return DynamicPairing(
      cuisine: json['cuisine'] ?? '',
      pairingRationale: json['pairing_rationale'] ?? '',
      dishRecommendations: List<String>.from(json['dish_recommendations'] ?? []),
      pairingScore: json['pairing_score'] ?? 70,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cuisine': cuisine,
      'pairing_rationale': pairingRationale,
      'dish_recommendations': dishRecommendations,
      'pairing_score': pairingScore,
    };
  }
}

/// Complete Wine Data Model
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

  Wine({
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
    return Wine(
      id: json['id']?.toString(),
      fingerprint: json['fingerprint'] ?? '',
      identity: WineIdentity.fromJson(json['wine_identity'] ?? {}),
      benchmarks: WineBenchmarks.fromJson(json['benchmarks'] ?? {}),
      tasteProfile: TasteProfile.fromJson(json['taste_profile'] ?? {}),
      servingIntel: ServingIntel.fromJson(json['serving_intel'] ?? {}),
      socialScripts: SocialScripts.fromJson(json['social_scripts'] ?? {}),
      pairings: Map<String, DynamicPairing>.from(
        (json['dynamic_pairing'] ?? {}).map(
          (key, value) => MapEntry(key, DynamicPairing.fromJson(value)),
        ),
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fingerprint': fingerprint,
      'wine_identity': identity.toJson(),
      'benchmarks': benchmarks.toJson(),
      'taste_profile': tasteProfile.toJson(),
      'serving_intel': servingIntel.toJson(),
      'social_scripts': socialScripts.toJson(),
      'dynamic_pairing': pairings.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Generate fingerprint from wine identity
  static String generateFingerprint(WineIdentity identity) {
    final data = '${identity.producer}_${identity.vintage}_${identity.region}';
    return data.toLowerCase().replaceAll(' ', '_');
  }
}
