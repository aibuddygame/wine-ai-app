import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/wine_model.dart';
import '../../core/constants/app_constants.dart';

/// Kimi LLM Service for Wine Vision Analysis
class KimiService {
  final String apiKey;
  final String apiUrl;
  final String model;

  KimiService({
    required this.apiKey,
    this.apiUrl = AppConstants.kimiApiUrl,
    this.model = AppConstants.kimiModel,
  });

  /// Analyze wine image and return structured data
  Future<Wine> analyzeWineImage(
    Uint8List imageBytes, {
    String? occupation,
    int? budget,
    String? cuisine,
  }) async {
    final base64Image = base64Encode(imageBytes);
    
    final prompt = _buildPrompt(
      occupation: occupation,
      budget: budget,
      cuisine: cuisine,
    );

    final response = await http.post(
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
            'content': 'You are a Senior Sommelier and Wine Data Analyst. Your task is to analyze wine images and provide structured data for a wine app. Always respond with valid JSON only.',
          },
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': prompt,
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
        'max_tokens': 2000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      
      // Parse JSON from content (handle potential markdown code blocks)
      final jsonString = _extractJson(content);
      final wineData = jsonDecode(jsonString);
      
      // Generate fingerprint and create Wine object
      final identity = WineIdentity.fromJson(wineData['wine_identity'] ?? {});
      final fingerprint = Wine.generateFingerprint(identity);
      
      return Wine.fromJson({
        ...wineData,
        'fingerprint': fingerprint,
      });
    } else {
      throw Exception('Kimi API Error: ${response.statusCode} - ${response.body}');
    }
  }

  /// Build the analysis prompt with context
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
    "the_hook": "Interesting historical fact or unique story about this wine",
    "the_observation": "A sophisticated tasting note that sounds knowledgeable",
    "the_question": "An engaging question to ask the sommelier or host"
  },
  "dynamic_pairing": {
    "Western": {
      "cuisine": "Western",
      "pairing_rationale": "Why this wine works with Western cuisine",
      "dish_recommendations": ["Dish 1", "Dish 2", "Dish 3"],
      "pairing_score": 85
    },
    "Cantonese": {
      "cuisine": "Cantonese",
      "pairing_rationale": "Why this wine works with Cantonese food",
      "dish_recommendations": ["Dish 1", "Dish 2", "Dish 3"],
      "pairing_score": 80
    },
    "Sichuan": {
      "cuisine": "Sichuan",
      "pairing_rationale": "Why this wine works with Sichuan cuisine",
      "dish_recommendations": ["Dish 1", "Dish 2", "Dish 3"],
      "pairing_score": 75
    },
    "Japanese": {
      "cuisine": "Japanese",
      "pairing_rationale": "Why this wine works with Japanese cuisine",
      "dish_recommendations": ["Dish 1", "Dish 2", "Dish 3"],
      "pairing_score": 82
    },
    "Italian": {
      "cuisine": "Italian",
      "pairing_rationale": "Why this wine works with Italian cuisine",
      "dish_recommendations": ["Dish 1", "Dish 2", "Dish 3"],
      "pairing_score": 88
    },
    "French": {
      "cuisine": "French",
      "pairing_rationale": "Why this wine works with French cuisine",
      "dish_recommendations": ["Dish 1", "Dish 2", "Dish 3"],
      "pairing_score": 90
    },
    "Thai": {
      "cuisine": "Thai",
      "pairing_rationale": "Why this wine works with Thai cuisine",
      "dish_recommendations": ["Dish 1", "Dish 2", "Dish 3"],
      "pairing_score": 70
    }
  }
}

IMPORTANT:
- Return ONLY valid JSON, no markdown formatting, no explanations
- All numeric values for taste_profile sliders must be 0-100
- All pairing_score values must be 0-100
- Include ALL cuisine types listed above
- If image quality is poor, use conservative estimates and set benchmarks accordingly''';  }

  /// Extract JSON from potentially markdown-wrapped content
  String _extractJson(String content) {
    // Remove markdown code blocks if present
    var cleaned = content.trim();
    
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    
    return cleaned.trim();
  }
}
