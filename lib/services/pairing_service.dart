import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/pairing_models.dart';
import '../constants/app_constants.dart';

/// Service for generating wine pairing advice
class PairingService {
  final String apiKey;
  
  PairingService({required this.apiKey});

  /// Generate pairing advice based on wine and meal
  Future<PairingResult> generatePairing(PairingRequest request) async {
    // For MVP, use mock data if API key is empty
    if (apiKey.isEmpty) {
      return _getMockPairingResult(request);
    }

    try {
      final prompt = _buildPairingPrompt(request);
      
      final response = await http.post(
        Uri.parse(AppConstants.kimiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': AppConstants.kimiModel,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a wine pairing expert. Provide concise, practical pairing advice in JSON format.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode != 200) {
        print('Pairing API Error: ${response.statusCode} - ${response.body}');
        return _getMockPairingResult(request);
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content = data['choices']?[0]?['message']?['content'] as String?;
      
      if (content == null) {
        return _getMockPairingResult(request);
      }

      // Parse JSON from the content
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0);
        final pairingData = jsonDecode(jsonStr!) as Map<String, dynamic>;
        return PairingResult.fromJson(pairingData);
      }

      return _getMockPairingResult(request);
    } catch (e) {
      print('Pairing generation error: $e');
      return _getMockPairingResult(request);
    }
  }

  /// Generate pairing from menu image
  Future<PairingResult> generatePairingFromMenu({
    required String wineId,
    required String wineName,
    required Uint8List menuImageBytes,
    String locale = 'zh-HK',
  }) async {
    // MVP fallback: return general pairing
    return PairingResult.fallback();
  }

  /// Build the pairing prompt
  String _buildPairingPrompt(PairingRequest request) {
    final mealType = request.mealInputType == MealInputType.quickPick
        ? 'meal type: ${request.mealValue}'
        : 'dish: ${request.mealValue}';

    return '''Wine: ${request.wineName}
$mealType

Provide wine pairing advice in this exact JSON format:
{
  "fit": "Great|Good|Okay|Not ideal",
  "best_with": ["dish1", "dish2"],
  "why": "brief explanation",
  "say_this": "what to say at dinner",
  "less_suitable_for": ["dish3"],
  "confidence": 0.85
}

Keep it concise and practical for a business dinner context.'';
  }

  /// Get mock pairing result for MVP
  PairingResult _getMockPairingResult(PairingRequest request) {
    final mealValue = request.mealValue.toLowerCase();
    
    // Quick mock responses based on meal type
    if (mealValue.contains('seafood') || mealValue.contains('fish')) {
      return PairingResult(
        fit: 'Great',
        bestWith: ['steamed fish', 'scallops', 'light Cantonese seafood'],
        why: 'The wine\'s acidity keeps the seafood fresh and balanced',
        sayThis: 'This bottle should work nicely with lighter seafood because it won\'t overpower the dish.',
        lessSuitableFor: ['heavy meat dishes', 'spicy food'],
        confidence: 0.9,
      );
    }
    
    if (mealValue.contains('steak') || mealValue.contains('meat')) {
      return PairingResult(
        fit: 'Great',
        bestWith: ['grilled ribeye', 'roast beef', 'lamb chops'],
        why: 'The wine\'s tannins complement the rich meat flavors',
        sayThis: 'This wine has enough body to stand up to the steak without being too heavy.',
        lessSuitableFor: ['delicate seafood', 'light salads'],
        confidence: 0.9,
      );
    }
    
    if (mealValue.contains('spicy') || mealValue.contains('hotpot')) {
      return PairingResult(
        fit: 'Okay',
        bestWith: ['mild spicy dishes', 'slightly sweet sauces'],
        why: 'The wine may clash with very spicy food, but works with milder spice',
        sayThis: 'This might be a bit challenging with very spicy food, but should work with milder dishes.',
        lessSuitableFor: ['very spicy Sichuan', 'hotpot'],
        confidence: 0.6,
      );
    }

    // Default fallback
    return PairingResult.fallback();
  }
}
