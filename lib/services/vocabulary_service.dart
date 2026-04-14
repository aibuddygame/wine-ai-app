import '../data/wine_vocabulary.dart';

/// Service for wine vocabulary lookup and content enhancement
/// Uses the bilingual wine vocabulary database
class VocabularyService {
  VocabularyService._();
  static final VocabularyService _instance = VocabularyService._();
  factory VocabularyService() => _instance;

  /// Current language preference
  String _locale = 'zh';
  
  /// Set the current locale
  void setLocale(String locale) {
    _locale = locale.startsWith('zh') ? 'zh' : 'en';
  }

  /// Get localized text
  String _getLocalized(Map<String, String> term) {
    return _locale == 'zh' 
        ? (term['zh'] ?? term['en'] ?? '')
        : (term['en'] ?? '');
  }

  /// Get sweetness level description
  Map<String, String> getSweetnessLevel(String level) {
    final data = WineVocabulary.sweetnessLevels[level];
    if (data == null) return {'name': level, 'description': ''};
    
    return {
      'name': _getLocalized(data),
      'description': _locale == 'zh' 
          ? (data['description_zh'] ?? '')
          : (data['description_en'] ?? ''),
    };
  }

  /// Get body level description
  Map<String, String> getBodyLevel(String level) {
    final data = WineVocabulary.bodyLevels[level];
    if (data == null) return {'name': level, 'description': ''};
    
    return {
      'name': _getLocalized(data),
      'description': _locale == 'zh' 
          ? (data['description_zh'] ?? '')
          : (data['description_en'] ?? ''),
    };
  }

  /// Get acidity description
  Map<String, String> getAcidityLevel(String level) {
    final data = WineVocabulary.acidityDescriptors[level];
    if (data == null) return {'name': level, 'description': ''};
    
    return {
      'name': _getLocalized(data),
      'description': _locale == 'zh' 
          ? (data['description_zh'] ?? '')
          : (data['description_en'] ?? ''),
    };
  }

  /// Get tannin description
  Map<String, String> getTanninLevel(String level) {
    final data = WineVocabulary.tanninDescriptors[level];
    if (data == null) return {'name': level, 'description': ''};
    
    return {
      'name': _getLocalized(data),
      'description': _locale == 'zh' 
          ? (data['description_zh'] ?? '')
          : (data['description_en'] ?? ''),
    };
  }

  /// Get wine region info
  Map<String, String> getRegion(String regionKey) {
    final data = WineVocabulary.wineRegions[regionKey.toLowerCase()];
    if (data == null) {
      // Try to find by name
      for (final entry in WineVocabulary.wineRegions.entries) {
        if (entry.value['en']?.toLowerCase() == regionKey.toLowerCase() ||
            entry.value['zh'] == regionKey) {
          return {
            'name': _getLocalized(entry.value),
            'country': _locale == 'zh' 
                ? (entry.value['country_zh'] ?? '')
                : (entry.value['country_en'] ?? ''),
          };
        }
      }
      return {'name': regionKey, 'country': ''};
    }
    
    return {
      'name': _getLocalized(data),
      'country': _locale == 'zh' 
          ? (data['country_zh'] ?? '')
          : (data['country_en'] ?? ''),
    };
  }

  /// Get grape variety info
  Map<String, String> getGrape(String grapeKey) {
    final data = WineVocabulary.grapeVarieties[grapeKey.toLowerCase().replaceAll(' ', '_')];
    if (data == null) {
      // Try to find by name
      for (final entry in WineVocabulary.grapeVarieties.entries) {
        if (entry.value['en']?.toLowerCase() == grapeKey.toLowerCase() ||
            entry.value['zh'] == grapeKey) {
          return {
            'name': _getLocalized(entry.value),
            'color': entry.value['color'] ?? 'unknown',
          };
        }
      }
      return {'name': grapeKey, 'color': 'unknown'};
    }
    
    return {
      'name': _getLocalized(data),
      'color': data['color'] ?? 'unknown',
    };
  }

  /// Get tasting concept description
  Map<String, String> getConcept(String conceptKey) {
    final data = WineVocabulary.tastingConcepts[conceptKey.toLowerCase()];
    if (data == null) return {'name': conceptKey, 'description': ''};
    
    return {
      'name': _getLocalized(data),
      'description': _locale == 'zh' 
          ? (data['description_zh'] ?? '')
          : (data['description_en'] ?? ''),
    };
  }

  /// Search vocabulary
  List<Map<String, String>> search(String query) {
    return WineVocabulary.search(query, language: _locale);
  }

  /// Get aroma examples for a category
  List<String> getAromaExamples(String category) {
    final data = WineVocabulary.aromaCategories[category];
    if (data == null) return [];

    final subcategories = data['subcategories'] as Map<String, dynamic>?;
    if (subcategories != null) {
      final examples = <String>[];
      for (final sub in subcategories.values) {
        final subExamples = sub['examples'] as List<dynamic>?;
        if (subExamples != null) {
          examples.addAll(subExamples.cast<String>());
        }
      }
      return examples;
    }

    final examples = data['examples'] as List<dynamic>?;
    return examples?.cast<String>() ?? [];
  }

  /// Get all aroma categories
  Map<String, Map<String, dynamic>> getAromaCategories() {
    return WineVocabulary.aromaCategories;
  }

  /// Get wine fault description
  Map<String, String> getFault(String faultKey) {
    final data = WineVocabulary.wineFaults[faultKey.toLowerCase()];
    if (data == null) return {'name': faultKey, 'description': ''};
    
    return {
      'name': _getLocalized(data),
      'description': _locale == 'zh' 
          ? (data['description_zh'] ?? '')
          : (data['description_en'] ?? ''),
    };
  }

  /// Enhance wine description with vocabulary
  /// This takes raw AI output and enriches it with proper bilingual terms
  String enhanceDescription(String description) {
    String enhanced = description;
    
    // Replace English terms with bilingual versions
    for (final entry in WineVocabulary.tastingConcepts.entries) {
      final enTerm = entry.value['en'] ?? '';
      final zhTerm = entry.value['zh'] ?? '';
      
      if (_locale == 'zh' && enTerm.isNotEmpty && zhTerm.isNotEmpty) {
        // In Chinese mode, add Chinese translations after English terms
        enhanced = enhanced.replaceAllMapped(
          RegExp(r'\b' + RegExp.escape(enTerm) + r'\b', caseSensitive: false),
          (match) => '$enTerm（$zhTerm）',
        );
      }
    }
    
    return enhanced;
  }

  /// Get quick reference for wine description
  /// Returns the 12 priority terms for HK Chinese-first MVP
  Map<String, Map<String, String>> getPriorityTerms() {
    final priorityKeys = [
      'dry',
      'sweet',
      'acidity',
      'tannin',
      'body',
      'light',
      'medium',
      'full',
      'aroma',
      'finish',
      'balance',
      'vintage',
      'appellation',
    ];

    final result = <String, Map<String, String>>{};
    
    for (final key in priorityKeys) {
      // Try different dictionaries
      if (WineVocabulary.sweetnessLevels.containsKey(key)) {
        result[key] = getSweetnessLevel(key);
      } else if (WineVocabulary.bodyLevels.containsKey(key)) {
        result[key] = getBodyLevel(key);
      } else if (WineVocabulary.acidityDescriptors.containsKey(key)) {
        result[key] = getAcidityLevel(key);
      } else if (WineVocabulary.tanninDescriptors.containsKey(key)) {
        result[key] = getTanninLevel(key);
      } else if (WineVocabulary.tastingConcepts.containsKey(key)) {
        result[key] = getConcept(key);
      }
    }
    
    return result;
  }

  /// Generate a wine description prompt for AI
  /// This helps the AI use consistent terminology
  String generatePromptInstructions() {
    if (_locale == 'zh') {
      return '''
請使用以下葡萄酒專業術語描述這款酒：

甜度：乾型（不甜）、半乾（微甜）、甜
酸度：低酸度、中等酸度、高酸度
丹寧：低丹寧、中等丹寧、高丹寧
酒體：輕盈酒體、中等酒體、飽滿酒體
香氣：果香（紅色水果、黑色水果、核果、柑橘、熱帶水果）、花香、香料、土壤感、橡木
餘味：短、中等、長
平衡：是否和諧

請用繁體中文回答，並適當使用這些術語。
''';
    } else {
      return '''
Please use the following wine terminology to describe this wine:

Sweetness: Dry, Off-Dry, Medium Sweet, Sweet
Acidity: Low, Medium, High
Tannin: Low, Medium, High
Body: Light-bodied, Medium-bodied, Full-bodied
Aroma: Fruity (red fruits, black fruits, stone fruits, citrus, tropical), Floral, Spicy, Earthy, Oak
Finish: Short, Medium, Long
Balance: Harmonious or not

Please use these terms appropriately in your description.
''';
    }
  }
}
