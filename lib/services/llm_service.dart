import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/wine.dart';
import '../models/cuisine_pairing.dart';
import '../core/constants/app_constants.dart';

class LlmServiceException implements Exception {
  final String message;
  final int? statusCode;
  const LlmServiceException(this.message, {this.statusCode});

  @override
  String toString() => 'LlmServiceException: $message';
}

class LlmService {
  final String apiKey;
  final String apiUrl;
  final String model;
  final http.Client _client;

  LlmService({
    required this.apiKey,
    this.apiUrl = AppConstants.kimiApiUrl,
    this.model = AppConstants.kimiModel,
    http.Client? client,
  }) : _client = client ?? http.Client();

  bool get hasApiKey => apiKey.isNotEmpty;

  Future<({Wine wine, CuisinePairing pairing})> analyzeWineImage(
    Uint8List imageBytes, {
    required String cuisine,
  }) async {
    if (!hasApiKey) {
      throw const LlmServiceException(
        'API key not configured. Set KIMI_API_KEY in your .env file.',
      );
    }

    final base64Image = base64Encode(imageBytes);
    final systemPrompt = _buildSystemPrompt(cuisine);

    Exception? lastError;
    for (var attempt = 0; attempt <= AppConstants.maxRetries; attempt++) {
      try {
        return await _makeRequest(base64Image, systemPrompt, cuisine);
      } on LlmServiceException {
        rethrow;
      } on TimeoutException {
        lastError =
            const LlmServiceException('Request timed out. Please try again.');
      } on FormatException catch (e) {
        lastError =
            LlmServiceException('Failed to parse response: ${e.message}');
        break;
      } catch (e) {
        lastError = LlmServiceException('Network error: $e');
      }

      if (attempt < AppConstants.maxRetries) {
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }

    throw lastError ?? const LlmServiceException('Unknown error');
  }

  Future<({Wine wine, CuisinePairing pairing})> _makeRequest(
    String base64Image,
    String systemPrompt,
    String cuisine,
  ) async {
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
                'content': systemPrompt,
              },
              {
                'role': 'user',
                'content': [
                  {
                    'type': 'text',
                    'text':
                        'Identify this wine from the label image and provide analysis for $cuisine cuisine pairing. Return STRICT JSON only.',
                  },
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
      try {
        final err = jsonDecode(body) as Map<String, dynamic>;
        detail = (err['error']?['message'] as String?) ?? detail;
      } catch (_) {}
      throw LlmServiceException(detail, statusCode: response.statusCode);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw const LlmServiceException('Empty response from API');
    }

    final content =
        (choices[0] as Map<String, dynamic>)['message']['content'] as String;
    final jsonString = _extractJson(content);

    final Map<String, dynamic> wineData;
    try {
      wineData = jsonDecode(jsonString) as Map<String, dynamic>;
    } on FormatException {
      debugPrint('Failed to parse LLM response: $jsonString');
      throw const LlmServiceException(
        'AI returned invalid data. Please try again with a clearer image.',
      );
    }

    return Wine.fromLlmResponse(wineData, cuisine);
  }

  String _buildSystemPrompt(String cuisine) {
    return '''You are a wine expert and social wingman for Hong Kong business executives.

TASK: Identify the wine from the label image and return STRICT JSON with 5-POINT STRATEGIC SOCIAL SCRIPT:

{
  "wine_name": "string",
  "vintage": "YYYY or NV",
  "winery": "string",
  "region": "string",
  "country": "string",
  "grape_variety": "string",
  "alcohol_content": "X%",
  "taste_profile": {
    "light_bold": 0-100,
    "smooth_tannic": 0-100,
    "dry_sweet": 0-100,
    "soft_acidic": 0-100
  },
  "rankings": {
    "world_percentile": 0-100,
    "region_percentile": 0-100
  },
  "compatibility": {
    "score": 0-100,
    "cuisine": "$cuisine"
  },
  "social_scripts": {
    "the_hook": {
      "zh": "Traditional Chinese - One prestigious fact: award, famous owner, or unique history as insider secret",
      "en": "English - One prestigious fact: award, famous owner, or unique history as insider secret"
    },
    "the_grape": {
      "zh": "Traditional Chinese - Grape's role/personality: blend balance OR single varietal character",
      "en": "English - Grape's role/personality: blend balance OR single varietal character"
    },
    "the_region": {
      "zh": "Traditional Chinese - Geography impact: one environmental factor (breezes, soil, altitude) and how it affects taste",
      "en": "English - Geography impact: one environmental factor (breezes, soil, altitude) and how it affects taste"
    },
    "the_vintage": {
      "zh": "Traditional Chinese - Weather narrative: Cool= elegance/acidity OR Warm= bold fruit/power. Frame difficult years as 'triumph of quality'",
      "en": "English - Weather narrative: Cool= elegance/acidity OR Warm= bold fruit/power. Frame difficult years as 'triumph of quality'"
    },
    "the_taste": {
      "zh": "Traditional Chinese - Sensory journey: flavors up front + finish characteristic that lingers",
      "en": "English - Sensory journey: flavors up front + finish characteristic that lingers"
    }
  },
  "recommended_dishes": [
    {
      "dish": "Dish name",
      "zh": "Traditional Chinese dish name",
      "why": "Brief pairing explanation"
    }
  ]
}

CRITICAL RULES:
1. ALL 5 social script points MUST be included - no exceptions
2. Each point needs BOTH "zh" (繁體中文) and "en" fields
3. Traditional Chinese must use proper Hong Kong style characters
4. Return ONLY valid JSON, no markdown, no prose
5. The 5 points should build a narrative arc: Prestige → Grape → Region → Vintage → Taste''';
  }

  String _extractJson(String content) {
    var cleaned = content.trim();

    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }

    cleaned = cleaned.trim();

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
