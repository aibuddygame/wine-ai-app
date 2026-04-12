/// Meal input type for pairing
enum MealInputType {
  quickPick,
  typedDish,
  menuScan,
  fallback,
}

/// Request for wine pairing advice
class PairingRequest {
  final String wineId;
  final String wineName;
  final MealInputType mealInputType;
  final String mealValue;
  final String locale;

  PairingRequest({
    required this.wineId,
    required this.wineName,
    required this.mealInputType,
    required this.mealValue,
    this.locale = 'zh-HK',
  });

  Map<String, dynamic> toJson() => {
        'wine_id': wineId,
        'wine_name': wineName,
        'meal_input_type': mealInputType.name,
        'meal_value': mealValue,
        'locale': locale,
      };
}

/// Result of wine pairing advice
class PairingResult {
  final String fit; // Great, Good, Okay, Not ideal
  final List<String> bestWith;
  final String why;
  final String sayThis;
  final List<String> lessSuitableFor;
  final double confidence;

  PairingResult({
    required this.fit,
    required this.bestWith,
    required this.why,
    required this.sayThis,
    required this.lessSuitableFor,
    required this.confidence,
  });

  factory PairingResult.fromJson(Map<String, dynamic> json) => PairingResult(
        fit: json['fit'] ?? 'Good',
        bestWith: List<String>.from(json['best_with'] ?? []),
        why: json['why'] ?? '',
        sayThis: json['say_this'] ?? '',
        lessSuitableFor: List<String>.from(json['less_suitable_for'] ?? []),
        confidence: (json['confidence'] ?? 0.8).toDouble(),
      );

  /// Get a fallback result when pairing fails or is skipped
  factory PairingResult.fallback() => PairingResult(
        fit: 'Good',
        bestWith: ['seafood', 'poultry', 'creamy dishes'],
        why: 'This wine has balanced acidity and moderate body',
        sayThis: 'This is a versatile wine that pairs well with many dishes.',
        lessSuitableFor: ['spicy hotpot', 'sweet desserts'],
        confidence: 0.7,
      );
}

/// Quick pick meal option
class QuickPickOption {
  final String id;
  final String label;
  final String labelZh;

  QuickPickOption({
    required this.id,
    required this.label,
    required this.labelZh,
  });
}

/// Get quick pick options based on locale
List<QuickPickOption> getQuickPickOptions(String locale) {
  final isZh = locale.startsWith('zh');
  return [
    QuickPickOption(id: 'cantonese_seafood', label: isZh ? '粵式海鮮' : 'Cantonese seafood', labelZh: '粵式海鮮'),
    QuickPickOption(id: 'roast_meat', label: isZh ? '燒味' : 'Roast meat', labelZh: '燒味'),
    QuickPickOption(id: 'hotpot', label: isZh ? '火鍋' : 'Hotpot', labelZh: '火鍋'),
    QuickPickOption(id: 'japanese', label: isZh ? '日本料理' : 'Japanese', labelZh: '日本料理'),
    QuickPickOption(id: 'steak', label: isZh ? '牛排' : 'Steak', labelZh: '牛排'),
    QuickPickOption(id: 'western', label: isZh ? '西餐' : 'Western', labelZh: '西餐'),
    QuickPickOption(id: 'spicy_food', label: isZh ? '辛辣食物' : 'Spicy food', labelZh: '辛辣食物'),
    QuickPickOption(id: 'dessert', label: isZh ? '甜品' : 'Dessert', labelZh: '甜品'),
  ];
}

/// Legacy export for backward compatibility
final List<QuickPickOption> quickPickOptions = getQuickPickOptions('zh');
