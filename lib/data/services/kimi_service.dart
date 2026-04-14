import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/wine_model.dart';
import '../models/wine_quick_result.dart';
import '../../core/constants/app_constants.dart';
import '../../services/vocabulary_service.dart';

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

  /// Stage 1: Fast wine identification (lean scan)
  /// Returns quick result with basic info only - no heavy analysis
  Future<WineScanQuickResult> analyzeWineImageStage1(
    Uint8List imageBytes, {
    String? occupation,
    int? budget,
  }) async {
    if (!hasApiKey) {
      throw const KimiServiceException(
        'API key not configured. Set KIMI_API_KEY in your .env file.',
      );
    }

    final base64Image = base64Encode(imageBytes);
    final prompt = _buildStage1Prompt(
      occupation: occupation,
      budget: budget,
    );

    // Retry logic
    Exception? lastError;
    for (var attempt = 0; attempt <= AppConstants.maxRetries; attempt++) {
      try {
        return await _makeStage1Request(base64Image, prompt);
      } on KimiServiceException {
        rethrow;
      } on TimeoutException {
        lastError = const KimiServiceException('Request timed out. Please try again.');
      } on FormatException catch (e) {
        lastError = KimiServiceException('Failed to parse response: ${e.message}');
        break;
      } catch (e) {
        lastError = KimiServiceException('Network error: $e');
      }

      if (attempt < AppConstants.maxRetries) {
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }

    throw lastError ?? const KimiServiceException('Unknown error');
  }

  /// Stage 2: Enrich wine data with detailed analysis
  /// Text-only call using Stage 1 results
  Future<Wine> enrichWineData(
    WineScanQuickResult quickResult, {
    String? occupation,
    int? budget,
    String? cuisine,
  }) async {
    if (!hasApiKey) {
      throw const KimiServiceException('API key not configured.');
    }

    final prompt = _buildEnrichmentPrompt(
      quickResult: quickResult,
      occupation: occupation,
      budget: budget,
      cuisine: cuisine,
    );

    try {
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
                  'content': _enrichmentSystemPrompt,
                },
                {
                  'role': 'user',
                  'content': prompt,
                },
              ],
              'temperature': 0.3,
              'max_tokens': 2000,
              'response_format': {'type': 'json_object'},
            }),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode != 200) {
        throw KimiServiceException(
          'API error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content = data['choices']?[0]?['message']?['content'] as String;
      final enrichmentData = jsonDecode(content) as Map<String, dynamic>;

      // Merge Stage 1 and Stage 2 data
      return _mergeWineData(quickResult, enrichmentData);
    } catch (e) {
      debugPrint('Enrichment error: $e');
      // Return basic wine from Stage 1 if enrichment fails
      return _createBasicWine(quickResult);
    }
  }

  /// Stage 1: Make lean identification request
  Future<WineScanQuickResult> _makeStage1Request(String base64Image, String prompt) async {
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
                'content': _stage1SystemPrompt,
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
            'temperature': 0.2,
            'max_tokens': 700,
            'response_format': {'type': 'json_object'},
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
    String locale = 'zh',
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

    // Get vocabulary instructions
    final vocabService = VocabularyService();
    vocabService.setLocale(locale);
    final vocabInstructions = vocabService.generatePromptInstructions();

    return '''Analyze this wine image and provide detailed information in STRICT JSON format.$contextString

$vocabInstructions

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

  // ==================== STAGE 1: LEAN IDENTIFICATION ====================

  static const String _stage1SystemPrompt = '''You are a wine label recognition assistant for a mobile app.

Your job in this stage is ONLY to identify the bottle from the image and return a short beginner-friendly summary in Traditional Chinese.

Important rules:
- Focus on bottle identification first.
- Keep the response compact.
- Do not generate long tasting notes.
- Do not generate food pairing.
- Do not generate social conversation scripts.
- Do not generate rankings or critic scores.
- If uncertain, provide your best guess and lower the confidence score.
- Return valid JSON only.

The JSON fields must be:
- wine_name
- winery
- vintage
- country
- region
- wine_type
- grape
- confidence
- short_summary_zh
- tonight_fit_zh

Definitions:
- short_summary_zh = one short Traditional Chinese line for a beginner
- tonight_fit_zh = one short Traditional Chinese line about whether this bottle is generally suitable for tonight, without meal-specific pairing
- confidence = number from 0 to 1''';

  String _buildStage1Prompt({
    String? occupation,
    int? budget,
  }) {
    final contextParts = <String>[];
    if (occupation != null && occupation.isNotEmpty) {
      contextParts.add('User occupation: $occupation');
    }
    if (budget != null) {
      contextParts.add('Typical budget: HKD $budget');
    }

    final contextString = contextParts.isNotEmpty
        ? '\n\nContext: ${contextParts.join(', ')}'
        : '';

    return '''Please identify this wine bottle from the image and return only the required JSON.$contextString

If exact identification is uncertain, provide the most likely result and reflect uncertainty in the confidence field.
Use Traditional Chinese for text fields.

Return JSON in this exact format:
{
  "wine_name": "Chateau Montelena Cabernet Sauvignon",
  "winery": "Chateau Montelena",
  "vintage": "2019",
  "country": "United States",
  "region": "Napa Valley",
  "wine_type": "red",
  "grape": "Cabernet Sauvignon",
  "confidence": 0.86,
  "short_summary_zh": "這是一款偏飽滿、風格較穩重的紅酒，通常會有黑色水果與較明顯結構感。",
  "tonight_fit_zh": "如果今晚是正式晚餐或偏重口味菜式，通常會是較穩陣的選擇。"
}''';
  }

  // ==================== STAGE 2: ENRICHMENT ====================

  static const String _enrichmentSystemPrompt = '''You are a wine expert assistant.

Given basic wine information, generate detailed analysis including:
- Taste profile (sliders 0-100)
- Serving recommendations
- Social scripts (what to say)
- Food pairings
- Benchmarks and ratings

Return valid JSON only.''';

  String _buildEnrichmentPrompt({
    required WineScanQuickResult quickResult,
    String? occupation,
    int? budget,
    String? cuisine,
  }) {
    final contextParts = <String>[];
    if (occupation != null && occupation.isNotEmpty) {
      contextParts.add('User occupation: $occupation');
    }
    if (budget != null) {
      contextParts.add('Budget: HKD $budget');
    }
    if (cuisine != null && cuisine.isNotEmpty) {
      contextParts.add('Cuisine: $cuisine');
    }

    final contextString = contextParts.isNotEmpty
        ? '\nContext: ${contextParts.join(', ')}'
        : '';

    return '''Wine: ${quickResult.winery} ${quickResult.wineName} ${quickResult.vintage}
Type: ${quickResult.wineType}
Region: ${quickResult.region}, ${quickResult.country}
Grape: ${quickResult.grape}$contextString

Generate detailed analysis in JSON format with these sections:
- taste_profile (light_bold, smooth_tannic, dry_sweet, soft_acidic sliders 0-100)
- serving_intel (temperature_c, decanting, glassware)
- social_scripts (hook, observation, question)
- dynamic_pairing (Chinese, Japanese, Western cuisines)
- benchmarks (ratings, price estimate)
- flavor_profile (primary, secondary, tertiary aromas)''';
  }

  Wine _createBasicWine(WineScanQuickResult quick) {
    // Create minimal Wine object from Stage 1 result
    return Wine(
      identity: WineIdentity(
        fullName: '${quick.winery} ${quick.wineName}',
        vintage: quick.vintage,
        producer: quick.winery,
        region: quick.region,
        subRegion: quick.region,
        country: quick.country,
        wineType: quick.wineType,
        grapeVariety: quick.grape,
        classification: '',
      ),
      benchmarks: WineBenchmarks(
        globalTopPercent: 50,
        regionalTopPercent: 50,
        averagePrice: 0,
        priceCurrency: 'HKD',
        criticScore: (quick.confidence * 5).round(),
      ),
      tasteProfile: WineTasteProfile(
        lightBold: 50,
        smoothTannic: 50,
        drySweet: 50,
        softAcidic: 50,
        aromaGroups: AromaGroups(
          primary: [],
          secondary: [],
          tertiary: [],
        ),
      ),
      servingIntel: ServingIntel(
        temperatureC: 16,
        servingTip: '',
        decantingRecommendation: '',
        glasswareRecommendation: '',
      ),
      socialScripts: SocialScripts(
        theHook: quick.shortSummaryZh,
        theObservation: '',
        theQuestion: '',
      ),
      regionStyle: RegionStyle(
        description: '',
        climate: '',
        typicalProfile: '',
      ),
      grapeEducation: [],
      flavorProfile: FlavorProfile(
        primary: [],
        secondary: [],
        tertiary: [],
        communityQuotes: [],
      ),
      communityReview: CommunityReview(
        rating: quick.confidence * 5,
        reviewText: quick.tonightFitZh,
        source: 'AI Analysis',
        reviewCount: 1,
      ),
      dynamicPairing: {},
      fingerprint: '',
      scannedImageBase64: '',
    );
  }

  Wine _mergeWineData(WineScanQuickResult quick, Map<String, dynamic> enrichment) {
    // Start with basic wine and overlay enrichment data
    final basic = _createBasicWine(quick);
    
    // TODO: Parse enrichment data and merge with basic
    // This is a simplified version - full implementation would parse all fields
    
    return basic;
  }

  void dispose() {
    _client.close();
  }
}
