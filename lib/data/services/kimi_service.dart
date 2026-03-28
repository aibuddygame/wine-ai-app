import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/wine_model.dart';
import '../../core/constants/app_constants.dart';

class KimiServiceException implements Exception {
  final String message;
  final int? statusCode;
  const KimiServiceException(this.message, {this.statusCode});

  @override
  String toString() => 'KimiServiceException: $message';
}

class KimiService {
  final String apiKey;
  final String apiUrl;
  final String model;
  final http.Client _client;

  KimiService({
    required this.apiKey,
    this.apiUrl = AppConstants.kimiApiUrl,
    this.model = AppConstants.kimiModel,
    http.Client? client,
  }) : _client = client ?? http.Client();

  bool get hasApiKey => apiKey.isNotEmpty;

  Future<Wine> analyzeWineImage(
    Uint8List imageBytes, {
    String? occupation,
    int? budget,
    String? cuisine,
  }) async {
    if (!hasApiKey) {
      throw const KimiServiceException(
        'API key not configured. Set KIMI_API_KEY in your .env file.',
      );
    }

    final base64Image = base64Encode(imageBytes);
    final prompt = _buildPrompt(
      occupation: occupation,
      budget: budget,
      cuisine: cuisine,
    );

    // Retry logic
    Exception? lastError;
    for (var attempt = 0; attempt <= AppConstants.maxRetries; attempt++) {
      try {
        return await _makeRequest(base64Image, prompt);
      } on KimiServiceException {
        rethrow;
      } on TimeoutException {
        lastError = const KimiServiceException('Request timed out. Please try again.');
      } on FormatException catch (e) {
        lastError = KimiServiceException('Failed to parse response: ${e.message}');
        break; // Don't retry parse errors
      } catch (e) {
        lastError = KimiServiceException('Network error: $e');
      }

      if (attempt < AppConstants.maxRetries) {
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }

    throw lastError ?? const KimiServiceException('Unknown error');
  }

  Future<Wine> _makeRequest(String base64Image, String prompt) async {
    final response = await _client
        .post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': model,
            'messages': [
              {
                'role': 'system',
                'content':
                    'You are a Senior Sommelier and Wine Data Analyst. '
                    'Analyze wine images and provide structured data. '
                    'Always respond with valid JSON only. No markdown, no prose.',
              },
              {
                'role': 'user',
                'content': [
                  {'type': 'text', 'text': prompt},
                  {
                    'type': 'image_url',
                    'image_url': {
                      'url': 'data:image/jpeg;base64,$base64Image',
                    },
                  },
                ],
              },
            ],
            'temperature': 0.3,
            'max_tokens': 3000,
          }),
        )
        .timeout(AppConstants.apiTimeout);

    if (response.statusCode != 200) {
      final body = response.body;
      String detail = 'Status ${response.statusCode}';
      debugPrint('Kimi API Error: Status ${response.statusCode}, Body: $body');
      try {
        final err = jsonDecode(body) as Map<String, dynamic>;
        detail = (err['error']?['message'] as String?) ?? detail;
      } catch (_) {}
      throw KimiServiceException(detail, statusCode: response.statusCode);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint('Kimi API Response: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...');
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw const KimiServiceException('Empty response from API');
    }

    final content =
        (choices[0] as Map<String, dynamic>)['message']['content'] as String;
    final jsonString = _extractJson(content);

    final Map<String, dynamic> wineData;
    try {
      wineData = jsonDecode(jsonString) as Map<String, dynamic>;
    } on FormatException {
      debugPrint('Failed to parse LLM response: $jsonString');
      throw const KimiServiceException(
        'AI returned invalid data. Please try again with a clearer image.',
      );
    }

    final identity =
        WineIdentity.fromJson(wineData['wine_identity'] as Map<String, dynamic>? ?? {});
    final fingerprint = Wine.generateFingerprint(identity);

    return Wine.fromJson({
      ...wineData,
      'fingerprint': fingerprint,
    });
  }

  String _buildPrompt({
    String? occupation,
    int? budget,
    String? cuisine,
  }) {
    final contextParts = <String>[];
    if (occupation != null && occupation.isNotEmpty) {
      contextParts.add('User Occupation: $occupation');
    }
    if (budget != null) {
      contextParts.add('Typical Budget: HKD $budget');
    }
    if (cuisine != null && cuisine.isNotEmpty) {
      contextParts.add('Current Cuisine Context: $cuisine');
    }

    final contextString = contextParts.isNotEmpty
        ? '\n\nUser Context:\n${contextParts.join('\n')}'
        : '';

    return '''Analyze this wine image and provide detailed information in STRICT JSON format.$contextString

Respond ONLY with a JSON object matching this exact structure:

{
  "wine_identity": {
    "full_name": "Complete wine name including producer and wine name",
    "vintage": "Year or NV for non-vintage",
    "producer": "Winery/Producer name",
    "region": "Primary wine region (e.g., Bordeaux, Napa Valley)",
    "sub_region": "Specific sub-region or appellation",
    "country": "Country of origin",
    "classification": "Wine classification (e.g., 1er Cru Classé, Grand Cru, DOC)",
    "grapes": ["Grape variety 1", "Grape variety 2"]
  },
  "benchmarks": {
    "global_top_percent": 85,
    "regional_top_percent": 80,
    "average_price": 450,
    "price_currency": "HKD",
    "critic_score": 92
  },
  "taste_profile": {
    "light_bold": 65,
    "smooth_tannic": 45,
    "dry_sweet": 15,
    "soft_acidic": 55,
    "aroma_groups": {
      "primary": ["Blackberry", "Cherry"],
      "secondary": ["Vanilla", "Toast"],
      "tertiary": ["Leather", "Tobacco"]
    }
  },
  "serving_intel": {
    "temperature_c": 16,
    "serving_tip": "Decant 30 minutes before serving",
    "decanting_recommendation": "30-45 minutes recommended",
    "glassware_recommendation": "Large Bordeaux glass"
  },
  "social_scripts": {
    "the_hook": "Point 1 - PRESTIGE: One prestigious fact about the winery (award, famous owner, unique history). Write as a confident statement sharing an insider secret. Length: 1-2 sentences, ~25-35 words.",
    "the_grape": "Point 2 - GRAPE CHARACTER: Describe the grape's personality as a statement. If blend, explain the balance. If single varietal, explain its 'personality'. Length: 1-2 sentences, ~25-35 words.",
    "the_region": "Point 3 - TERROIR: Explain geography's impact as a statement. Mention one environmental factor and how it makes the wine taste finer or bolder. Length: 1-2 sentences, ~25-35 words.",
    "the_vintage": "Point 4 - VINTAGE INSIGHT: Research the harvest year's climate as a statement. Cool/Slow = elegance/acidity, Warm/Fast = bold fruit/power. Frame difficult years as 'triumph of quality over quantity'. Length: 1-2 sentences, ~25-35 words.",
    "the_taste": "Point 5 - SENSORY TRIP: Guide through tasting as a statement. Combine flavors with texture. Use: 'You'll notice [flavors] up front, followed by a [velvety/acidic/etc] finish that lingers.' Length: 1-2 sentences, ~25-35 words."
  },
  "region_style": {
    "description": "Brief description of the region's wine style",
    "climate": "Climate description (e.g., Maritime, Continental, Mediterranean)",
    "typical_profile": "Typical characteristics of wines from this region"
  },
  "grape_education": [
    {
      "variety": "Cabernet Sauvignon",
      "percentage": "75%",
      "description": "What this grape contributes to the blend",
      "characteristics": "Key flavor and structural characteristics"
    }
  ],
  "flavor_profile": {
    "primary": ["Blackcurrant", "Cedar", "Blackberry"],
    "secondary": ["Vanilla", "Clove", "Leather"],
    "tertiary": ["Truffle", "Tobacco", "Earth"],
    "community_quotes": [
      "Quote 1 about the wine",
      "Quote 2 about the wine",
      "Quote 3 about the wine"
    ]
  },
  "community_review": {
    "rating": 4.7,
    "review_text": "Featured review text describing the wine",
    "source": "Wine Spectator or similar publication",
    "review_count": 2847
  },
  "dynamic_pairing": {
    "Chinese": {
      "cuisine": "Chinese",
      "pairing_rationale": "15 words max. Focus on Umami & Fat logic: How wine handles salt/sugar in soy-braised meats, dim sum. Example: 'Tannins cut through rich soy-glazed pork while complementing umami depth.'",
      "dish_recommendations": ["Soy-braised Pork Belly", "Dim Sum Selection", "Kung Pao Chicken"],
      "avoid_dishes": ["Very sweet desserts"],
      "pairing_score": 85
    },
    "Japanese": {
      "cuisine": "Japanese",
      "pairing_rationale": "15 words max. Focus on Cleanliness & Delicacy logic: How wine respects subtle flavors without overpowering. Example: 'High acidity mirrors wasabi heat while respecting delicate fish textures.'",
      "dish_recommendations": ["Toro Sashimi", "Tempura Selection", "Wagyu Tataki"],
      "avoid_dishes": ["Overly spicy rolls"],
      "pairing_score": 88
    },
    "Korean": {
      "cuisine": "Korean",
      "pairing_rationale": "15 words max. Focus on Fermentation & Spice logic: How wine handles high-acid/spicy ferments. Example: 'Fruit-forward profile balances kimchi acidity and BBQ spice heat.'",
      "dish_recommendations": ["Galbi BBQ", "Kimchi Stew", "Bulgogi"],
      "avoid_dishes": ["Extremely spicy dishes"],
      "pairing_score": 82
    },
    "Western": {
      "cuisine": "Western",
      "pairing_rationale": "15 words max. Focus on Protein & Cream logic: Traditional tannin/acid balancing with butter/fat. Example: 'Bold tannins structure matches marbled steak fat perfectly.'",
      "dish_recommendations": ["Ribeye Steak", "Creamy Pasta", "Roasted Lamb"],
      "avoid_dishes": ["Overly acidic salads"],
      "pairing_score": 90
    },
    "Asian": {
      "cuisine": "Asian",
      "pairing_rationale": "15 words max. Focus on Aromatics & Heat logic: How wine interacts with coconut milk and chili. Example: 'Stone fruit notes complement Thai basil and coconut cream richness.'",
      "dish_recommendations": ["Thai Green Curry", "Lemongrass Chicken", "Satay Skewers"],
      "avoid_dishes": ["Extremely hot curries"],
      "pairing_score": 78
    }
  }
}

IMPORTANT:
- Return ONLY valid JSON, no markdown formatting, no explanations
- All numeric values for taste_profile sliders must be 0-100
- All pairing_score values must be 0-100
- Include ALL fields shown in the structure above
- Make grape_education educational and informative
- If image quality is poor, use conservative estimates and set benchmarks accordingly

MULTI-CUISINE PAIRING LOGIC:
- Chinese: Umami & Fat (soy-braised meats, dim sum) - How wine handles salt/sugar
- Japanese: Cleanliness & Delicacy (sashimi, tempura) - How wine respects subtle flavors
- Korean: Fermentation & Spice (kimchi, BBQ) - How wine handles high-acid/spicy ferments
- Western: Protein & Cream (steak, pasta) - Traditional tannin/acid balancing with butter/fat
- Asian (SEA): Aromatics & Heat (Thai curry, lemongrass) - How wine interacts with coconut milk and chili

Each pairing_rationale must be MAX 15 WORDS and explain the specific logic for that cuisine type.''';
  }

  String _extractJson(String content) {
    var cleaned = content.trim();

    // Remove markdown code fences
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }

    cleaned = cleaned.trim();

    // Find first { and last } as safety net
    final start = cleaned.indexOf('{');
    final end = cleaned.lastIndexOf('}');
    if (start >= 0 && end > start) {
      cleaned = cleaned.substring(start, end + 1);
    }

    return cleaned;
  }

  void dispose() {
    _client.close();
  }
}
