import 'wine.dart';

class CuisinePairing {
  final int? id;
  final int? wineId;
  final String cuisine;
  final int compatibilityScore;
  final SocialSurvivalScript socialScript;
  final List<RecommendedDish> recommendedDishes;

  const CuisinePairing({
    this.id,
    this.wineId,
    required this.cuisine,
    required this.compatibilityScore,
    required this.socialScript,
    required this.recommendedDishes,
  });

  factory CuisinePairing.fromJson(Map<String, dynamic> json) {
    final dishesRaw = json['recommended_dishes'];
    List<RecommendedDish> dishes = [];
    if (dishesRaw is List) {
      dishes = dishesRaw
          .map((d) => RecommendedDish.fromJson(d as Map<String, dynamic>))
          .toList();
    } else if (dishesRaw is String) {
      try {
        // Handle JSON string stored in DB
        final decoded = json['recommended_dishes'];
        if (decoded is List) {
          dishes = decoded
              .map((d) => RecommendedDish.fromJson(d as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {}
    }

    final socialRaw = json['social_script'] ?? json['social_survival_script'];
    SocialSurvivalScript social;
    if (socialRaw is Map<String, dynamic>) {
      social = SocialSurvivalScript.fromJson(socialRaw);
    } else {
      social = const SocialSurvivalScript(
        theHook: BilingualText(zh: '', en: ''),
        thePairingLogic: BilingualText(zh: '', en: ''),
        theChitChat: BilingualText(zh: '', en: ''),
      );
    }

    return CuisinePairing(
      id: json['id'] as int?,
      wineId: json['wine_id'] as int?,
      cuisine: (json['cuisine'] as String?) ?? '',
      compatibilityScore:
          ((json['compatibility_score'] as num?)?.toInt() ?? 0).clamp(0, 100),
      socialScript: social,
      recommendedDishes: dishes,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (wineId != null) 'wine_id': wineId,
        'cuisine': cuisine,
        'compatibility_score': compatibilityScore,
        'social_script': socialScript.toJson(),
        'recommended_dishes':
            recommendedDishes.map((d) => d.toJson()).toList(),
      };
}
