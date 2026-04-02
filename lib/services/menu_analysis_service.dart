import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';

/// Result of analyzing a menu against a wine
class MenuPairingResult {
  final List<DishPairing> pairings;
  final String overallVerdict;
  final String? suggestion;
  final String? wineRecommendation;

  const MenuPairingResult({
    required this.pairings,
    required this.overallVerdict,
    this.suggestion,
    this.wineRecommendation,
  });

  factory MenuPairingResult.fromJson(Map<String, dynamic> json) {
    final pairingsList = (json['pairings'] as List<dynamic>? ?? [])
        .map((p) => DishPairing.fromJson(p as Map<String, dynamic>))
        .toList();

    return MenuPairingResult(
      pairings: pairingsList,
      overallVerdict: (json['overall_verdict'] as String?) ?? 'fair',
      suggestion: json['suggestion'] as String?,
      wineRecommendation: json['wine_recommendation'] as String?,
    );
  }

  /// Get only the good pairings (score >= 70)
  List<DishPairing> get goodPairings =>
      pairings.where((p) => p.compatibilityScore >= 70).toList();

  /// Get pairings to avoid (score < 50)
  List<DishPairing> get avoidPairings =>
      pairings.where((p) => p.compatibilityScore < 50).toList();

  /// Check if this wine is suitable for the menu
  bool get isSuitable => overallVerdict == 'excellent' || overallVerdict == 'good';
}

/// Individual dish pairing result
class DishPairing {
  final String dish;
  final int compatibilityScore;
  final String whyItWorks;
  final String recommendation;

  const DishPairing({
    required this.dish,
    required this.compatibilityScore,
    required this.whyItWorks,
    required this.recommendation,
  });

  factory DishPairing.fromJson(Map<String, dynamic> json) {
    return DishPairing(
      dish: (json['dish'] as String?) ?? 'Unknown Dish',
      compatibilityScore: (json['compatibility_score'] as num?)?.toInt() ?? 50,
      whyItWorks: (json['why_it_works'] as String?) ?? '',
      recommendation: (json['recommendation'] as String?) ?? 'neutral',
    );
  }

  bool get isRecommended => recommendation == 'strongly_recommended' || recommendation == 'recommended';
  bool get shouldAvoid => recommendation == 'avoid';
}

/// Service for analyzing menus against wines
class MenuAnalysisService {
  final String apiKey;

  MenuAnalysisService({required this.apiKey});

  /// Analyze a menu photo against the current wine
  Future<MenuPairingResult> analyzeMenu({
    required String wineProfileJson,
    required Uint8List menuImageBytes,
  }) async {
    final base64Image = base64Encode(menuImageBytes);

    final prompt = '''You are a wine pairing expert. Analyze this restaurant menu against the provided wine profile.

WINE PROFILE:
$wineProfileJson

TASK:
1. Extract all dishes from the menu image using OCR
2. For each dish, analyze compatibility with this wine (0-100 score)
3. Identify the best pairings and dishes to avoid
4. Provide an overall verdict on whether this wine suits the menu

Return JSON in this exact format:
{
  "pairings": [
    {
      "dish": "dish name",
      "compatibility_score": 85,
      "why_it_works": "brief explanation",
      "recommendation": "strongly_recommended|recommended|neutral|avoid"
    }
  ],
  "overall_verdict": "excellent|good|fair|poor",
  "suggestion": "brief advice for user",
  "wine_recommendation": "if poor match, suggest wine style that would work better"
}

Rules:
- Be honest about poor pairings
- If overall_verdict is "poor", suggest a different wine style
- Consider the wine's body, tannins, acidity, and flavor profile
- Think about cooking methods, sauces, and dominant flavors''';

    final response = await http.post(
      Uri.parse('https://api.moonshot.ai/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'model': 'moonshot-v1-8k-vision-preview',
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
              }
            ]
          }
        ],
        'temperature': 0.3,
        'response_format': {'type': 'json_object'},
      }),
    );

    if (response.statusCode != 200) {
      debugPrint('Menu Analysis Error: Status ${response.statusCode}');
      debugPrint('Menu Analysis Error: Body ${response.body}');
      throw Exception('Menu analysis failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['choices']?[0]?['message']?['content'] as String?;

    if (content == null) {
      throw Exception('No content in response');
    }

    // Parse the JSON response
    final resultJson = jsonDecode(content) as Map<String, dynamic>;
    return MenuPairingResult.fromJson(resultJson);
  }
}
