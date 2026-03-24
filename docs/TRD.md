# Wine AI - Technical Requirements Document (TRD)

**Version:** 1.0  
**Date:** March 24, 2026  
**Author:** R2D2 (CTO/Engineer)  
**Status:** Draft  

---

## 1. Executive Summary

This document defines the technical requirements for Wine AI MVP v2.0, incorporating P0 features identified from the Vivino competitive analysis. The focus is on enhancing the existing Flutter web app with robust data persistence, social features, and AI-driven social scripts.

**Key Technical Challenges:**
1. AI-generated social scripts (Hook/Observation/Question) based on wine analysis + user context
2. Database schema evolution for ratings, favorites, and user preferences
3. Kimi Vision API integration optimization
4. 3-tab navigation improvements with enhanced UX

---

## 2. System Architecture

### 2.1 Current Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           PRESENTATION LAYER                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │ Context Tab  │  │  Scan Tab    │  │ Results View │  │  Vault Tab   │ │
│  │  (Home)      │  │  (Camera)    │  │ (Bento Grid) │  │  (History)   │ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           STATE MANAGEMENT                              │
│                    Provider Pattern (Flutter)                           │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────────────────┐ │
│  │ UserProvider   │  │ WineProvider   │  │ VaultProvider (Extended)   │ │
│  └────────────────┘  └────────────────┘  └────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           DATA LAYER                                    │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                    SQLite (sqflite)                              │   │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────────┐ │   │
│  │  │ wines        │ │ users        │ │ search_history           │ │   │
│  │  │ (cached)     │ │ (profile)    │ │ (scans + face_earned)    │ │   │
│  │  └──────────────┘ └──────────────┘ └──────────────────────────┘ │   │
│  └──────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        EXTERNAL SERVICES                                │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                    Kimi Vision API (Moonshot)                    │   │
│  │  - Image analysis                                                │   │
│  │  - Structured JSON output                                        │   │
│  │  - Context-aware prompts (occupation, budget, cuisine)           │   │
│  └──────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Enhanced Architecture (P0 Features)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           PRESENTATION LAYER                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │ Context Tab  │  │  Scan Tab    │  │ Results View │  │  Vault Tab   │ │
│  │  (Enhanced)  │  │  (Enhanced)  │  │(Interactive) │  │  (Enhanced)  │ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘ │
│                                                                         │
│  NEW: ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │
│       │ Favorites    │  │ Wine Search  │  │ Share Cards  │             │
│       │ Screen       │  │ Screen       │  │ Generator    │             │
│       └──────────────┘  └──────────────┘  └──────────────┘             │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           STATE MANAGEMENT                              │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌────────────────┐  │
│  │UserProvider  │ │WineProvider  │ │VaultProvider │ │FavoritesProvider│  │
│  │(Enhanced)    │ │(Enhanced)    │ │(Extended)    │ │(NEW)           │  │
│  └──────────────┘ └──────────────┘ └──────────────┘ └────────────────┘  │
│                                                                         │
│  NEW: ┌──────────────┐  ┌──────────────┐                                │
│       │RatingProvider│  │SearchProvider│                                │
│       └──────────────┘  └──────────────┘                                │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           DATA LAYER                                    │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                    SQLite (Enhanced Schema)                      │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐│   │
│  │  │wines     │ │users     │ │search_   │ │favorites │ │user_    ││   │
│  │  │          │ │          │ │history   │ │          │ │ratings  ││   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └─────────┘│   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐                         │   │
│  │  │wine_tags │ │cuisines  │ │offline_  │                         │   │
│  │  │          │ │          │ │queue     │                         │   │
│  │  └──────────┘ └──────────┘ └──────────┘                         │   │
│  └──────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Database Schema

### 3.1 Current Schema

```sql
-- wines table
CREATE TABLE wines (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fingerprint TEXT UNIQUE NOT NULL,
  metadata TEXT NOT NULL,  -- JSON blob
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- users table
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  occupation TEXT NOT NULL,
  typical_budget INTEGER NOT NULL,
  consumption_tier TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- search_history table
CREATE TABLE search_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  wine_id INTEGER,
  wine_fingerprint TEXT NOT NULL,
  wine_name TEXT,
  cuisine_context TEXT,
  budget_context INTEGER,
  scanned_at TEXT DEFAULT CURRENT_TIMESTAMP,
  face_earned REAL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (wine_id) REFERENCES wines(id)
);
```

### 3.2 Enhanced Schema (P0 Features)

```sql
-- ============================================
-- EXISTING TABLES (with migrations)
-- ============================================

-- wines table (unchanged structure, enhanced metadata)
-- metadata JSON now includes: is_favorite, user_rating, notes

-- users table (enhanced)
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  occupation TEXT NOT NULL,
  typical_budget INTEGER NOT NULL,
  consumption_tier TEXT NOT NULL,
  preferred_cuisine TEXT,           -- NEW: default cuisine preference
  script_tone TEXT DEFAULT 'professional', -- NEW: casual/professional/executive
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- search_history table (enhanced)
CREATE TABLE search_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  wine_id INTEGER,
  wine_fingerprint TEXT NOT NULL,
  wine_name TEXT,
  wine_full_name TEXT,              -- NEW: denormalized for display
  wine_region TEXT,                 -- NEW: denormalized for search
  cuisine_context TEXT,
  budget_context INTEGER,
  scanned_at TEXT DEFAULT CURRENT_TIMESTAMP,
  face_earned REAL,
  user_rating INTEGER,              -- NEW: 1-5 star rating
  user_notes TEXT,                  -- NEW: personal notes
  is_favorite INTEGER DEFAULT 0,    -- NEW: boolean flag
  share_count INTEGER DEFAULT 0,    -- NEW: analytics
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (wine_id) REFERENCES wines(id)
);

-- ============================================
-- NEW TABLES
-- ============================================

-- user_ratings table (normalized ratings for aggregation)
CREATE TABLE user_ratings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  wine_fingerprint TEXT NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  tags TEXT,                        -- JSON array of quick tags
  notes TEXT,
  would_buy_again INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  UNIQUE(user_id, wine_fingerprint)
);

-- favorites table (explicit favorites with ordering)
CREATE TABLE favorites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  wine_fingerprint TEXT NOT NULL,
  wine_name TEXT,
  wine_region TEXT,
  list_name TEXT DEFAULT 'default', -- for multiple lists (e.g., "Dinner Party")
  sort_order INTEGER DEFAULT 0,
  added_at TEXT DEFAULT CURRENT_TIMESTAMP,
  notes TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id),
  UNIQUE(user_id, wine_fingerprint, list_name)
);

-- wine_tags table (quick tag system)
CREATE TABLE wine_tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  wine_fingerprint TEXT NOT NULL,
  tag TEXT NOT NULL,                -- e.g., "impressive", "overpriced", "gift-worthy"
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- offline_queue table (for pending operations)
CREATE TABLE offline_queue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  operation_type TEXT NOT NULL,     -- 'rating', 'favorite', 'scan'
  payload TEXT NOT NULL,            -- JSON payload
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  retry_count INTEGER DEFAULT 0,
  last_error TEXT
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_wines_fingerprint ON wines(fingerprint);
CREATE INDEX idx_history_user ON search_history(user_id);
CREATE INDEX idx_history_scanned ON search_history(scanned_at);
CREATE INDEX idx_history_favorite ON search_history(is_favorite);
CREATE INDEX idx_history_rating ON search_history(user_rating);
CREATE INDEX idx_ratings_user ON user_ratings(user_id);
CREATE INDEX idx_ratings_wine ON user_ratings(wine_fingerprint);
CREATE INDEX idx_favorites_user ON favorites(user_id);
CREATE INDEX idx_favorites_list ON favorites(list_name);
CREATE INDEX idx_tags_user ON wine_tags(user_id);
CREATE INDEX idx_tags_wine ON wine_tags(wine_fingerprint);
```

### 3.3 Data Models

#### UserRating Model
```dart
class UserRating {
  final String? id;
  final String? userId;
  final String wineFingerprint;
  final int rating; // 1-5
  final List<String> tags;
  final String? notes;
  final bool wouldBuyAgain;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserRating({
    this.id,
    this.userId,
    required this.wineFingerprint,
    required this.rating,
    this.tags = const [],
    this.notes,
    this.wouldBuyAgain = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserRating.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() => { ... };
}
```

#### Favorite Model
```dart
class Favorite {
  final String? id;
  final String? userId;
  final String wineFingerprint;
  final String wineName;
  final String wineRegion;
  final String listName;
  final int sortOrder;
  final DateTime addedAt;
  final String? notes;

  const Favorite({...});

  factory Favorite.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() => { ... };
}
```

---

## 4. Kimi Vision API Integration

### 4.1 API Configuration

```dart
class KimiServiceConfig {
  static const String apiUrl = 'https://api.moonshot.cn/v1/chat/completions';
  static const String model = 'moonshot-v1-8k-vision-preview';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 2;
  static const double temperature = 0.3;
  static const int maxTokens = 2000;
}
```

### 4.2 Enhanced Prompt Engineering

The social scripts generation is the key differentiator. The prompt must incorporate:

1. **Wine characteristics** (body, tannin, region, vintage)
2. **User context** (occupation, budget tier)
3. **Dining context** (cuisine type, formality level)
4. **Script tone** (professional vs. casual vs. executive)

#### Enhanced Prompt Structure

```dart
String _buildEnhancedPrompt({
  String? occupation,
  int? budget,
  String? cuisine,
  String? scriptTone, // 'casual' | 'professional' | 'executive'
  String? formality,  // 'business_dinner' | 'casual' | 'celebration'
}) {
  final contextParts = <String>[];
  
  // User context
  if (occupation != null) contextParts.add('Occupation: $occupation');
  if (budget != null) contextParts.add('Budget Tier: ${_getBudgetTier(budget)}');
  if (scriptTone != null) contextParts.add('Communication Style: $scriptTone');
  
  // Dining context
  if (cuisine != null) contextParts.add('Cuisine: $cuisine');
  if (formality != null) contextParts.add('Occasion: $formality');

  return '''
Analyze this wine image and provide detailed information in STRICT JSON format.

USER CONTEXT:
${contextParts.isNotEmpty ? contextParts.join('\n') : 'General consumer'}

SOCIAL SCRIPTS REQUIREMENTS:
Generate three conversation elements tailored to the user's context:

1. THE HOOK: An opening line or interesting fact that:
   - Matches the user's communication style ($scriptTone)
   - Is appropriate for the occasion ($formality)
   - Demonstrates knowledge without showing off
   - Can be delivered naturally in conversation

2. THE OBSERVATION: A sophisticated tasting note that:
   - Uses accessible but refined language
   - References specific aroma/taste elements visible in the analysis
   - Provides a "safe" opinion (not too controversial)
   - Can be expanded upon if asked

3. THE QUESTION: An engaging question to ask the sommelier/host that:
   - Shows genuine interest without being confrontational
   - Is appropriate for the wine's price tier
   - Could lead to useful information or rapport building
   - Demonstrates some wine knowledge

Respond ONLY with valid JSON matching this structure:
{
  "wine_identity": { ... },
  "benchmarks": { ... },
  "taste_profile": { ... },
  "serving_intel": { ... },
  "social_scripts": {
    "the_hook": "string",
    "the_observation": "string", 
    "the_question": "string",
    "context_used": {
      "tone": "string",
      "formality": "string",
      "cuisine": "string"
    }
  },
  "dynamic_pairing": { ... }
}
'''
}
```

### 4.3 Response Validation & Fallbacks

```dart
class SocialScriptsValidator {
  static const int minLength = 20;
  static const int maxLength = 200;
  
  static ValidationResult validate(SocialScripts scripts) {
    final errors = <String>[];
    
    if (scripts.theHook.length < minLength) {
      errors.add('Hook too short');
    }
    if (scripts.theObservation.length < minLength) {
      errors.add('Observation too short');
    }
    if (scripts.theQuestion.length < minLength) {
      errors.add('Question too short');
    }
    
    // Check for generic/template language
    if (_isGeneric(scripts.theHook)) {
      errors.add('Hook appears generic');
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
  
  static SocialScripts getFallbackScripts(Wine wine) {
    return SocialScripts(
      theHook: 'This ${wine.identity.producer} from ${wine.identity.vintage} is quite interesting...',
      theObservation: 'I notice the ${wine.tasteProfile.aromaGroups['primary']?.first ?? 'fruit'} notes are quite prominent.',
      theQuestion: 'What would you recommend as the ideal serving temperature for this wine?',
    );
  }
}
```

### 4.4 Caching Strategy

```dart
class WineCacheManager {
  // Fingerprint-based cache key
  static String generateCacheKey(WineIdentity identity, {
    String? occupation,
    String? cuisine,
    String? tone,
  }) {
    final base = '${identity.producer}|${identity.vintage}|${identity.region}';
    final context = '${occupation ?? ''}|${cuisine ?? ''}|${tone ?? ''}';
    return md5.convert(utf8.encode('$base|$context')).toString();
  }
  
  // Cache wine with context
  Future<void> cacheWine(Wine wine, UserContext context) async {
    final key = generateCacheKey(wine.identity, 
      occupation: context.occupation,
      cuisine: context.cuisine,
      tone: context.scriptTone,
    );
    // Store in SQLite with expiration
  }
  
  // Retrieve with context matching
  Future<Wine?> getCachedWine(WineIdentity identity, UserContext context) async {
    // Try exact context match first
    // Fall back to wine-only match if context differs
  }
}
```

---

## 5. Feature Specifications

### 5.1 P0 Features (Must-Have)

#### 5.1.1 Enhanced Social Scripts Engine

**Requirements:**
- Generate context-aware conversation starters
- Support 3 script tones: casual, professional, executive
- Adapt to dining occasion (business dinner, casual, celebration)
- Provide fallback scripts for API failures
- Cache scripts per wine + context combination

**Technical Implementation:**
```dart
class SocialScriptsEngine {
  final KimiService _kimiService;
  final WineCacheManager _cache;
  
  Future<SocialScripts> generateScripts({
    required Wine wine,
    required UserContext context,
  }) async {
    // 1. Check cache
    final cached = await _cache.getScripts(wine.fingerprint, context);
    if (cached != null) return cached;
    
    // 2. Call API with enhanced prompt
    final scripts = await _kimiService.generateScripts(wine, context);
    
    // 3. Validate response
    final validation = SocialScriptsValidator.validate(scripts);
    if (!validation.isValid) {
      // Use fallback with logging
      return SocialScriptsValidator.getFallbackScripts(wine);
    }
    
    // 4. Cache and return
    await _cache.cacheScripts(wine.fingerprint, context, scripts);
    return scripts;
  }
}
```

#### 5.1.2 User Ratings System

**Requirements:**
- 5-star rating with half-star support
- Quick tags (e.g., "impressive", "overpriced", "gift-worthy")
- Personal notes
- "Would buy again" toggle
- Aggregate ratings per wine (local only)

**UI Components:**
```dart
class RatingWidget extends StatelessWidget {
  final double rating; // 0.0 - 5.0
  final bool allowHalfStars;
  final ValueChanged<double>? onRatingChanged;
  
  @override
  Widget build(BuildContext context) { ... }
}

class QuickTagSelector extends StatelessWidget {
  final List<String> selectedTags;
  final List<String> availableTags = [
    'impressive', 'overpriced', 'great_value', 
    'gift_worthy', 'cellar_worthy', 'everyday_drinker'
  ];
  
  @override
  Widget build(BuildContext context) { ... }
}
```

#### 5.1.3 Favorites System

**Requirements:**
- Heart icon on wine cards
- Multiple favorite lists (default + custom)
- Reorder favorites within lists
- Quick add from scan results
- Favorites view in Vault tab

**Database Operations:**
```dart
class FavoritesRepository {
  Future<List<Favorite>> getFavorites({String listName = 'default'});
  Future<void> addFavorite(Favorite favorite);
  Future<void> removeFavorite(String wineFingerprint);
  Future<void> reorderFavorites(List<String> orderedFingerprints);
  Future<void> createList(String listName);
  Future<void> deleteList(String listName);
}
```

#### 5.1.4 Wine Search (Text-Based)

**Requirements:**
- Search by wine name, producer, region, grape
- Fuzzy matching for typos
- Recent searches
- Search suggestions
- Results from cached wines first

**Search Implementation:**
```dart
class WineSearchService {
  Future<List<Wine>> search(String query) async {
    // 1. Search local cache
    final local = await _db.searchWines(query);
    
    // 2. Fuzzy match
    return _fuzzySort(local, query);
  }
  
  List<Wine> _fuzzySort(List<Wine> wines, String query) {
    return wines.map((w) => (
      wine: w,
      score: _calculateMatchScore(w, query),
    ))
    .where((r) => r.score > 0.3)
    .sorted((a, b) => b.score.compareTo(a.score))
    .map((r) => r.wine)
    .toList();
  }
}
```

#### 5.1.5 Shareable Wine Cards

**Requirements:**
- Generate image card from wine data
- Include wine identity, benchmarks, social scripts
- Share to native share sheet
- Copy text version to clipboard
- Save to gallery

**Implementation:**
```dart
class WineCardGenerator {
  Future<Uint8List> generateCard(Wine wine) async {
    // Use flutter/rendering to capture widget as image
    final boundary = _cardKey.currentContext?.findRenderObject() 
        as RenderRepaintBoundary?;
    final image = await boundary?.toImage(pixelRatio: 3.0);
    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
```

### 5.2 P1 Features (Should-Have)

#### 5.2.1 Offline Mode
- Queue operations when offline
- Sync when connection restored
- Full scan history available offline

#### 5.2.2 Enhanced Scanner UX
- Corner guides for label positioning
- Real-time focus feedback
- Auto-capture on stable focus
- Multi-image analysis for accuracy

#### 5.2.3 Taste Profile Evolution
- Track taste preferences over time
- Personalized recommendations based on ratings
- Taste profile visualization

---

## 6. API Requirements

### 6.1 Internal APIs (Provider Layer)

| Provider | Methods | Description |
|----------|---------|-------------|
| `UserProvider` | `loadUser()`, `saveUser()`, `updatePreferences()` | User profile management |
| `WineProvider` | `scanWine()`, `getWine()`, `searchWines()` | Wine operations |
| `VaultProvider` | `getStats()`, `getHistory()`, `clearHistory()` | Vault data |
| `FavoritesProvider` | `addFavorite()`, `removeFavorite()`, `getFavorites()` | Favorites management |
| `RatingProvider` | `rateWine()`, `getRating()`, `getRatedWines()` | Ratings management |
| `SearchProvider` | `search()`, `getRecentSearches()`, `clearSearches()` | Search functionality |

### 6.2 External APIs

#### Kimi Vision API

**Endpoint:** `POST https://api.moonshot.cn/v1/chat/completions`

**Request:**
```json
{
  "model": "moonshot-v1-8k-vision-preview",
  "messages": [
    {
      "role": "system",
      "content": "You are a Senior Sommelier..."
    },
    {
      "role": "user",
      "content": [
        {"type": "text", "text": "prompt..."},
        {"type": "image_url", "image_url": {"url": "data:image/jpeg;base64,..."}}
      ]
    }
  ],
  "temperature": 0.3,
  "max_tokens": 2000
}
```

**Response:**
```json
{
  "choices": [{
    "message": {
      "content": "{\"wine_identity\": {...}, ...}"
    }
  }]
}
```

**Error Handling:**
- 401: Invalid API key
- 429: Rate limit exceeded (implement exponential backoff)
- 500: Server error (retry with backoff)
- Timeout: Retry up to 3 times

---

## 7. UI/UX Specifications

### 7.1 Navigation Structure

```
BottomNavigationBar:
├── Context (Home) - User profile & preferences
├── Scan (Camera) - Wine scanning (FAB style)
└── Vault (History) - Stats, favorites, history

Additional Routes:
├── /search - Text search screen
├── /favorites - Favorites management
├── /wine/{id} - Wine detail view
├── /results - Scan results (bento grid)
└── /settings - App settings
```

### 7.2 Screen Specifications

#### Context Tab (Enhanced)
- Occupation input with suggestions
- Budget slider with tier indicators
- Script tone selector (chips)
- Default cuisine preference
- Consumption tier display

#### Scan Tab (Enhanced)
- Full-screen camera view
- Corner guides overlay
- Gallery fallback button
- Recent scans quick access
- Scan tips/help

#### Results Screen (Enhanced)
- Wine header with favorite button
- Benchmarks grid
- Taste profile sliders
- Social scripts with copy buttons
- Dynamic pairing selector
- Rating input (1-5 stars)
- Share button
- Save to favorites

#### Vault Tab (Enhanced)
- Stats cards (Face Earned, Total Value, Scans)
- Tab switcher: History | Favorites
- History list with ratings
- Favorites grid
- Pull-to-refresh

### 7.3 Component Library

| Component | Usage |
|-----------|-------|
| `BentoCard` | Primary content container |
| `BentoGrid` | Grid layout for stats |
| `TasteSlider` | Taste profile visualization |
| `CuisineChip` | Cuisine selector |
| `PercentBadge` | Benchmark display |
| `RatingWidget` | Star rating input/display |
| `QuickTagChip` | Tag selection |
| `WineCard` | Wine list item |
| `ShareCard` | Generated share image |

---

## 8. Performance Requirements

### 8.1 Response Times

| Operation | Target | Maximum |
|-----------|--------|---------|
| App launch | < 2s | < 3s |
| Scan to result | < 5s | < 10s |
| Cache lookup | < 50ms | < 100ms |
| Search results | < 200ms | < 500ms |
| Favorites load | < 100ms | < 200ms |
| Rating save | < 50ms | < 100ms |

### 8.2 Resource Limits

| Resource | Limit |
|----------|-------|
| SQLite DB size | 50MB (auto-vacuum) |
| Image cache | 100MB |
| API timeout | 30s |
| Max image size | 5MB |
| Concurrent API calls | 1 (queue others) |

### 8.3 Optimization Strategies

1. **Image Compression:** Compress images to 1024x1024 before API upload
2. **Lazy Loading:** Load wine details on demand
3. **Pagination:** Limit history to 50 items per page
4. **Debouncing:** Debounce search input by 300ms
5. **Memoization:** Cache expensive widget builds

---

## 9. Security Requirements

### 9.1 Data Protection

- API keys stored in environment variables only
- No PII stored without encryption
- Local database encrypted at rest (SQLCipher)
- Image data cleared from memory after processing

### 9.2 API Security

- API key rotation support
- Request signing (future)
- Rate limiting client-side
- No API keys in logs

---

## 10. Testing Strategy

### 10.1 Unit Tests

```dart
// Example test cases
group('SocialScriptsEngine', () {
  test('generates context-aware scripts', () async { ... });
  test('returns fallback on API failure', () async { ... });
  test('caches scripts correctly', () async { ... });
});

group('WineCacheManager', () {
  test('generates consistent fingerprints', () { ... });
  test('retrieves cached wines', () async { ... });
});
```

### 10.2 Integration Tests

- Full scan flow (camera → API → results)
- Rating and favorites workflow
- Offline mode behavior
- Search functionality

### 10.3 Manual Testing Checklist

- [ ] Scan works with various lighting conditions
- [ ] Social scripts are contextually appropriate
- [ ] Ratings persist across sessions
- [ ] Favorites sync correctly
- [ ] Share cards generate properly
- [ ] Offline queue processes when online

---

## 11. Open Questions

1. **Backend Requirements:** Do we need a cloud backend for multi-device sync?
2. **Analytics:** What events should be tracked for product insights?
3. **Monetization:** Should premium features affect the technical architecture?
4. **Internationalization:** Is multi-language support needed for v2?
5. **Accessibility:** What are the target WCAG compliance levels?

---

## 12. Appendix

### A. Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.0
  sqflite: ^2.3.0
  sqflite_common_ffi_web: ^0.4.0
  http: ^1.1.0
  crypto: ^3.0.3
  path: ^1.8.3
  share_plus: ^7.2.0
  path_provider: ^2.1.0
  image: ^4.1.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

### B. Environment Variables

```bash
KIMI_API_KEY=your_api_key_here
ENVIRONMENT=development|production
ENABLE_ANALYTICS=true|false
CACHE_SIZE_MB=100
```

---

*Document prepared by R2D2 (CTO/Engineer)*  
*For technical questions, contact via Telegram group*
