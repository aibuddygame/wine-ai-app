/// Wine Vocabulary Database
/// Bilingual (English/Traditional Chinese) terms for wine description
/// Used for content generation and user education

class WineVocabulary {
  WineVocabulary._();

  // ==================== CORE TASTING TERMS ====================
  
  /// Sweetness levels
  static const Map<String, Map<String, String>> sweetnessLevels = {
    'dry': {
      'en': 'Dry',
      'zh': '乾型',
      'description_en': 'Little or almost no residual sugar; not sweet',
      'description_zh': '幾乎沒有殘留糖分；不甜',
    },
    'off_dry': {
      'en': 'Off-Dry / Medium Dry',
      'zh': '半乾 / 微甜',
      'description_en': 'Slightly sweet with a hint of residual sugar',
      'description_zh': '微甜，帶有少許殘留糖分',
    },
    'medium_sweet': {
      'en': 'Medium Sweet / Semi-Sweet',
      'zh': '半甜',
      'description_en': 'Noticeable sweetness but not dessert-level',
      'description_zh': '明顯甜味但非甜點級別',
    },
    'sweet': {
      'en': 'Sweet',
      'zh': '甜',
      'description_en': 'Noticeable residual sugar',
      'description_zh': '明顯殘留糖分',
    },
  };

  /// Acidity descriptors
  static const Map<String, Map<String, String>> acidityDescriptors = {
    'low': {
      'en': 'Low Acidity',
      'zh': '低酸度',
      'description_en': 'Soft, rounded mouthfeel',
      'description_zh': '口感柔和圓潤',
    },
    'medium': {
      'en': 'Medium Acidity',
      'zh': '中等酸度',
      'description_en': 'Balanced freshness',
      'description_zh': '平衡的清新感',
    },
    'high': {
      'en': 'High Acidity',
      'zh': '高酸度',
      'description_en': 'Crisp, mouth-watering lift',
      'description_zh': '清爽、令人垂涎的活力',
    },
  };

  /// Tannin descriptors
  static const Map<String, Map<String, String>> tanninDescriptors = {
    'low': {
      'en': 'Low Tannin',
      'zh': '低丹寧',
      'description_en': 'Smooth, minimal grip',
      'description_zh': '順滑，幾乎沒有澀感',
    },
    'medium': {
      'en': 'Medium Tannin',
      'zh': '中等丹寧',
      'description_en': 'Gentle structure',
      'description_zh': '溫和的酒體結構',
    },
    'high': {
      'en': 'High Tannin',
      'zh': '高丹寧',
      'description_en': 'Drying, gripping feeling on tongue and gums',
      'description_zh': '舌頭和牙齦有明顯的乾澀感',
    },
  };

  /// Body levels
  static const Map<String, Map<String, String>> bodyLevels = {
    'light': {
      'en': 'Light-Bodied',
      'zh': '輕盈酒體',
      'description_en': 'Delicate, water-like weight',
      'description_zh': '精緻，如水般的輕盈',
    },
    'medium': {
      'en': 'Medium-Bodied',
      'zh': '中等酒體',
      'description_en': 'Balanced weight and texture',
      'description_zh': '平衡的質感和重量',
    },
    'full': {
      'en': 'Full-Bodied',
      'zh': '飽滿酒體 / 厚重',
      'description_en': 'Rich, heavy, coating the mouth',
      'description_zh': '豐厚濃郁，包覆口腔',
    },
  };

  // ==================== AROMA & FLAVOR TERMS ====================

  /// Primary aroma categories
  static const Map<String, Map<String, dynamic>> aromaCategories = {
    'fruity': {
      'en': 'Fruity',
      'zh': '果香',
      'subcategories': {
        'red_fruits': {
          'en': 'Red Fruits',
          'zh': '紅色水果',
          'examples': ['Strawberry 草莓', 'Raspberry 覆盆子', 'Cherry 櫻桃', 'Red Currant 紅醋栗'],
        },
        'black_fruits': {
          'en': 'Black Fruits',
          'zh': '黑色水果',
          'examples': ['Blackcurrant 黑加侖', 'Blackberry 黑莓', 'Plum 李子', 'Blueberry 藍莓'],
        },
        'stone_fruits': {
          'en': 'Stone Fruits',
          'zh': '核果',
          'examples': ['Peach 桃子', 'Apricot 杏子', 'Nectarine 油桃'],
        },
        'citrus': {
          'en': 'Citrus',
          'zh': '柑橘類',
          'examples': ['Lemon 檸檬', 'Lime 青檸', 'Grapefruit 葡萄柚', 'Orange 橙'],
        },
        'tropical': {
          'en': 'Tropical',
          'zh': '熱帶水果',
          'examples': ['Pineapple 菠蘿', 'Mango 芒果', 'Passion Fruit 熱情果', 'Lychee 荔枝'],
        },
      },
    },
    'floral': {
      'en': 'Floral',
      'zh': '花香',
      'examples': ['Rose 玫塊', 'Violet 紫蘿蘭', 'Jasmine 茉莉', 'Honeysuckle 金銀花'],
    },
    'spicy': {
      'en': 'Spicy',
      'zh': '香料',
      'examples': ['Pepper 胡椒', 'Cinnamon 肉桂', 'Clove 丁香', 'Vanilla 香草'],
    },
    'earthy': {
      'en': 'Earthy',
      'zh': '土壤 / 泥土感',
      'examples': ['Wet Earth 濕土', 'Mushroom 蘑菇', 'Forest Floor 森林地表', 'Truffle 松露'],
    },
    'woody': {
      'en': 'Woody / Oak',
      'zh': '木質 / 橡木',
      'examples': ['Cedar 雪松', 'Sandalwood 檀木', 'Toast 烤面包', 'Smoke 煙燻'],
    },
    'herbal': {
      'en': 'Herbal',
      'zh': '草本',
      'examples': ['Mint 薄荷', 'Eucalyptus 桉樹', 'Thyme 百里香', 'Lavender 薰衣草'],
    },
  };

  // ==================== WINE REGIONS ====================

  /// Major wine regions (bilingual)
  static const Map<String, Map<String, String>> wineRegions = {
    // France
    'burgundy': {
      'en': 'Burgundy',
      'zh': '布艮地',
      'country_en': 'France',
      'country_zh': '法國',
    },
    'bordeaux': {
      'en': 'Bordeaux',
      'zh': '波爾多',
      'country_en': 'France',
      'country_zh': '法國',
    },
    'champagne': {
      'en': 'Champagne',
      'zh': '香檳',
      'country_en': 'France',
      'country_zh': '法國',
    },
    'rhone': {
      'en': 'Rhône Valley',
      'zh': '隆河谷',
      'country_en': 'France',
      'country_zh': '法國',
    },
    'chateauneuf': {
      'en': "Châteauneuf-du-Pape",
      'zh': '教皇新堡',
      'country_en': 'France',
      'country_zh': '法國',
    },
    'loire': {
      'en': 'Loire Valley',
      'zh': '盧瓦爾河谷',
      'country_en': 'France',
      'country_zh': '法國',
    },
    'alsace': {
      'en': 'Alsace',
      'zh': '阿爾薩斯',
      'country_en': 'France',
      'country_zh': '法國',
    },
    // Italy
    'tuscany': {
      'en': 'Tuscany',
      'zh': '托斯卡尼',
      'country_en': 'Italy',
      'country_zh': '義大利',
    },
    'piedmont': {
      'en': 'Piedmont',
      'zh': '皮埃蒙特',
      'country_en': 'Italy',
      'country_zh': '義大利',
    },
    // Spain
    'rioja': {
      'en': 'Rioja',
      'zh': '里奧哈',
      'country_en': 'Spain',
      'country_zh': '西班牙',
    },
    // Germany
    'mosel': {
      'en': 'Mosel',
      'zh': '摩澤爾',
      'country_en': 'Germany',
      'country_zh': '德國',
    },
    // New World
    'napa': {
      'en': 'Napa Valley',
      'zh': '納帕谷',
      'country_en': 'USA',
      'country_zh': '美國',
    },
    'sonoma': {
      'en': 'Sonoma',
      'zh': '索諾瑪',
      'country_en': 'USA',
      'country_zh': '美國',
    },
    'barossa': {
      'en': 'Barossa Valley',
      'zh': '巴羅薩谷',
      'country_en': 'Australia',
      'country_zh': '澳大利亞',
    },
    'marlborough': {
      'en': 'Marlborough',
      'zh': '馬爾堡',
      'country_en': 'New Zealand',
      'country_zh': '紐西蘭',
    },
    'casablanca': {
      'en': 'Casablanca Valley',
      'zh': '卡薩布蘭加谷',
      'country_en': 'Chile',
      'country_zh': '智利',
    },
    'stellenbosch': {
      'en': 'Stellenbosch',
      'zh': '斯泰倫博斯',
      'country_en': 'South Africa',
      'country_zh': '南菲',
    },
  };

  // ==================== GRAPE VARIETIES ====================

  /// Common grape varieties (bilingual)
  static const Map<String, Map<String, String>> grapeVarieties = {
    // Red grapes
    'cabernet_sauvignon': {
      'en': 'Cabernet Sauvignon',
      'zh': '卡本內蘇維濃',
      'color': 'red',
    },
    'merlot': {
      'en': 'Merlot',
      'zh': '梅洛',
      'color': 'red',
    },
    'pinot_noir': {
      'en': 'Pinot Noir',
      'zh': '黑皮諾',
      'color': 'red',
    },
    'syrah': {
      'en': 'Syrah / Shiraz',
      'zh': '希哈 / 施赫',
      'color': 'red',
    },
    'grenache': {
      'en': 'Grenache',
      'zh': '格納希',
      'color': 'red',
    },
    'tempranillo': {
      'en': 'Tempranillo',
      'zh': '田帕尼優',
      'color': 'red',
    },
    'sangiovese': {
      'en': 'Sangiovese',
      'zh': '山吉歐維榭',
      'color': 'red',
    },
    'nebbiolo': {
      'en': 'Nebbiolo',
      'zh': '內比歐羅',
      'color': 'red',
    },
    'malbec': {
      'en': 'Malbec',
      'zh': '馬爾貝克',
      'color': 'red',
    },
    'zinfandel': {
      'en': 'Zinfandel',
      'zh': '金粉黛',
      'color': 'red',
    },
    // White grapes
    'chardonnay': {
      'en': 'Chardonnay',
      'zh': '夏多內',
      'color': 'white',
    },
    'sauvignon_blanc': {
      'en': 'Sauvignon Blanc',
      'zh': '白蘇維濃',
      'color': 'white',
    },
    'riesling': {
      'en': 'Riesling',
      'zh': '雷司令',
      'color': 'white',
    },
    'pinot_grigio': {
      'en': 'Pinot Grigio',
      'zh': '灰皮諾',
      'color': 'white',
    },
    'gewurztraminer': {
      'en': 'Gewürztraminer',
      'zh': '瓊瑤漿',
      'color': 'white',
    },
    'viognier': {
      'en': 'Viognier',
      'zh': '維歐尼亞',
      'color': 'white',
    },
    'chenin_blanc': {
      'en': 'Chenin Blanc',
      'zh': '白詩南',
      'color': 'white',
    },
    'albarino': {
      'en': 'Albariño',
      'zh': '阿爾巴利諾',
      'color': 'white',
    },
    'muscat': {
      'en': 'Muscat',
      'zh': '蜜思卡',
      'color': 'white',
    },
  };

  // ==================== WINE FAULTS ====================

  /// Common wine faults
  static const Map<String, Map<String, String>> wineFaults = {
    'corked': {
      'en': 'Corked',
      'zh': '軟木塞污染 / 壞塞味',
      'description_en': 'Wet newspaper, basement, or moldy smell from TCA contamination',
      'description_zh': '濕報紙、地下室或發霉的氣味，由TCA污染引起',
    },
    'oxidized': {
      'en': 'Oxidized',
      'zh': '氧化',
      'description_en': 'Brown color, nutty or sherry-like aroma from excessive air exposure',
      'description_zh': '顏色變褐，帶有堅果或雪莉酒般的氣味，因過度接觸空氣',
    },
    'reduced': {
      'en': 'Reduced',
      'zh': '還原味',
      'description_en': 'Rotten egg or burnt rubber smell from lack of oxygen',
      'description_zh': '腐蛋或燒焦橡膠的氣味，因缺乏氧氣',
    },
    'volatile_acidity': {
      'en': 'Volatile Acidity',
      'zh': '揮發酸',
      'description_en': 'Vinegar or nail polish remover smell',
      'description_zh': '醋或去光水的氣味',
    },
  };

  // ==================== TASTING CONCEPTS ====================

  /// Key tasting concepts
  static const Map<String, Map<String, String>> tastingConcepts = {
    'aroma': {
      'en': 'Aroma / Nose',
      'zh': '香氣',
      'description_en': 'What you smell from the wine, including intensity and aromatic profile',
      'description_zh': '從葡萄酒中聞到的氣味，包括濃郁度和香氣輪廓',
    },
    'palate': {
      'en': 'Palate',
      'zh': '口感 / 味覺表現',
      'description_en': 'What the wine feels and tastes like in the mouth',
      'description_zh': '葡萄酒在口中的感覺和味道',
    },
    'finish': {
      'en': 'Finish / Aftertaste',
      'zh': '餘味 / 餘韻',
      'description_en': 'The flavor that remains after swallowing or spitting',
      'description_zh': '吞下或吐出後殘留的味道',
    },
    'balance': {
      'en': 'Balance',
      'zh': '平衡',
      'description_en': 'When sweetness, acidity, tannin, alcohol, and flavor feel harmonious',
      'description_zh': '甜度、酸度、丹寧、酒精和風味和諧統一',
    },
    'vintage': {
      'en': 'Vintage',
      'zh': '年份',
      'description_en': 'The harvest year of the grapes used in the wine',
      'description_zh': '釀造葡萄酒所用的葡萄採收年份',
    },
    'appellation': {
      'en': 'Appellation',
      'zh': '產區',
      'description_en': 'The legally defined and protected geographic origin of the wine',
      'description_zh': '葡萄酒的法定地理產區標示',
    },
    'terroir': {
      'en': 'Terroir',
      'zh': '風土',
      'description_en': 'The growing environment that shapes wine character: climate, soil, topography',
      'description_zh': '塑造葡萄酒特性的種植環境：氣候、土壤、地形',
    },
    'old_world': {
      'en': 'Old World',
      'zh': '舊世界',
      'description_en': 'Traditional wine countries: France, Italy, Spain, Germany',
      'description_zh': '傳統釀酒國：法國、義大利、西班牙、德國',
    },
    'new_world': {
      'en': 'New World',
      'zh': '新世界',
      'description_en': 'Newer winemaking countries: USA, Australia, New Zealand, South Africa, Chile',
      'description_zh': '新興釀酒國：美國、澳大利亞、紐西蘭、南菲、智利',
    },
  };

  // ==================== HELPER METHODS ====================

  /// Get term by key with language preference
  static String getTerm(String key, String language) {
    // Check all dictionaries
    final dictionaries = [
      sweetnessLevels,
      bodyLevels,
      wineRegions,
      grapeVarieties,
      tastingConcepts,
    ];

    for (final dict in dictionaries) {
      if (dict.containsKey(key)) {
        return dict[key]![language] ?? dict[key]!['en'] ?? key;
      }
    }
    return key;
  }

  /// Get all terms for a specific category
  static Map<String, dynamic> getCategory(String category) {
    switch (category) {
      case 'sweetness':
        return sweetnessLevels;
      case 'body':
        return bodyLevels;
      case 'regions':
        return wineRegions;
      case 'grapes':
        return grapeVarieties;
      case 'concepts':
        return tastingConcepts;
      case 'faults':
        return wineFaults;
      default:
        return {};
    }
  }

  /// Search for a term (fuzzy matching)
  static List<Map<String, String>> search(String query, {String language = 'en'}) {
    final results = <Map<String, String>>[];
    final lowerQuery = query.toLowerCase();

    // Search through all dictionaries
    final allTerms = <Map<String, Map<String, String>>>[
      sweetnessLevels,
      bodyLevels,
      tanninDescriptors,
      acidityDescriptors,
      wineRegions,
      grapeVarieties,
      tastingConcepts,
      wineFaults,
    ];

    for (final dict in allTerms) {
      for (final entry in dict.entries) {
        final key = entry.key;
        final value = entry.value;
        
        // Check if query matches key or any value
        if (key.toLowerCase().contains(lowerQuery) ||
            value['en']?.toLowerCase().contains(lowerQuery) == true ||
            value['zh']?.toLowerCase().contains(lowerQuery) == true) {
          results.add({
            'key': key,
            'en': value['en'] ?? '',
            'zh': value['zh'] ?? '',
            'category': _getCategoryName(dict),
          });
        }
      }
    }

    return results;
  }

  static String _getCategoryName(Map<String, dynamic> dict) {
    if (dict == sweetnessLevels) return 'Sweetness';
    if (dict == bodyLevels) return 'Body';
    if (dict == tanninDescriptors) return 'Tannin';
    if (dict == acidityDescriptors) return 'Acidity';
    if (dict == wineRegions) return 'Region';
    if (dict == grapeVarieties) return 'Grape';
    if (dict == tastingConcepts) return 'Concept';
    if (dict == wineFaults) return 'Fault';
    return 'Unknown';
  }
}
