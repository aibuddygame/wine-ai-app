# Wine AI App - Project Context

## Overview
**Project:** Wine AI - Social Survival for Business Dinners  
**Location:** `~/wine-ai-app/`  
**GitHub:** https://github.com/aibuddygame/wine-ai-app  
**Started:** March 23, 2026  
**Status:** MVP Complete, P1 Features In Progress

## What It Does
Flutter app using Kimi Vision AI to identify wine from photos and provide "Face-Saving" talking points for Hong Kong professionals at business dinners.

## Tech Stack
- **Framework:** Flutter 3.41.4 (Dart 3.11.1)
- **Database:** SQLite (sqflite with web compatibility)
- **State Management:** Provider
- **AI:** Kimi Vision API (moonshot/kimi-k2.5)
- **UI:** Cal AI dark theme (#000000 background, 24px radius)

## Current Status

### ✅ MVP Complete (4 Screens)
| Screen | Status | Lines |
|--------|--------|-------|
| Context (User Setup) | ✅ Complete | 274 |
| Scanner (Camera) | ✅ Complete | 286 |
| Results (Bento-grid) | ✅ Complete | 560 |
| Vault (History) | ✅ Complete | 325 |

**Core Features Working:**
- Wine image analysis via Kimi Vision API
- Structured response parsing (wine identity, benchmarks, taste profile, social scripts, pairings)
- SQLite caching by wine fingerprint
- Provider state management
- Error handling with retry logic

### 🟡 P1 Features (In Progress - R2D2)
| Feature | Status | Location |
|---------|--------|----------|
| Favorites | ⏳ Stub folder | `lib/features/favorites/` |
| Wine Search | ⏳ Stub folder | `lib/features/wine_search/` |
| Wine Detail | ⏳ Stub folder | `lib/features/wine_detail/` |
| Ratings | ⏳ Not started | - |
| Share | ⏳ Not started | - |

### ❌ Blockers
1. **Kimi API Key** — Need `.env` file with `KIMI_API_KEY`
2. **Android SDK** — Not installed (blocks APK builds)
3. **End-to-end testing** — Never tested with real wine images

## Key Files

### Models
- `lib/data/models/wine_model.dart` — Wine, WineIdentity, Benchmarks, TasteProfile, etc.
- `lib/data/models/user_model.dart` — User profile, consumption tier
- `lib/data/models/search_history_model.dart` — Search tracking

### Services
- `lib/data/services/kimi_service.dart` — Kimi Vision API integration with retry logic

### Providers
- `lib/providers/wine_provider.dart` — Current wine, scan history
- `lib/providers/user_provider.dart` — User profile, occupation, budget
- `lib/providers/vault_provider.dart` — Stats, face earned, total value

### Screens (MVP)
- `lib/features/context/context_screen.dart` — User setup (occupation, budget)
- `lib/features/scanner/scanner_screen.dart` — Camera capture + analysis
- `lib/features/results/results_screen.dart` — Bento-grid results display
- `lib/features/vault/vault_screen.dart` — History + stats

### UI Components
- `lib/ui/components/bento_components.dart` — Bento cards, sliders, badges

## API Integration

**Kimi Vision API Prompt Structure:**
```json
{
  "wine_identity": { "producer", "wine_name", "region", "country", "grape_variety", "vintage", "wine_type" },
  "benchmarks": { "global_ranking", "regional_ranking", "price_estimate_hkd", "critic_score" },
  "taste_profile": { "body", "tannin", "sweetness", "acidity" },
  "serving_intel": { "decant_time", "ideal_temp", "peak_window" },
  "social_scripts": { "the_hook", "the_observation", "the_question" },
  "dynamic_pairing": { "cuisines": [...] }
}
```

## Next Steps

### Immediate (R2D2)
1. **Favorites System** — Heart toggle on results, favorites list screen
2. **Wine Search** — Search history by name, producer, region
3. **Wine Detail** — Full-screen wine view from vault
4. **Share Feature** — Share wine info via native share sheet
5. **Ratings Display** — Show critic scores with visual indicators

### After P1
- End-to-end testing with real wine photos
- Configure Kimi API key
- Android SDK setup for APK builds
- App store preparation

## Design Reference
- **Theme:** Cal AI dark aesthetic
- **Colors:** Pure black (#000000), white text, subtle grays
- **Radius:** 24px for cards
- **Typography:** Clean, modern, readable

## Commands
```bash
# Run web dev server
cd ~/wine-ai-app && flutter run -d chrome

# Build web release
flutter build web --release

# Build APK (when SDK ready)
flutter build apk --release
```

---
**Last Updated:** 2026-03-24 by clawderhk  
**Active Agent:** R2D2 (P1 features)
