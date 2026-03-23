# Wine AI - Social Survival for Business Dinners

A Flutter web app that uses Vision AI to instantly identify wine and provide "Face-Saving" talking points for Hong Kong professionals navigating business dinners.

## Features

- **📸 Wine Scanner** - Take a photo of any wine label for instant analysis
- **🍷 Wine Identity** - Full wine details including producer, region, grapes, vintage
- **📊 Benchmarks** - Global and regional rankings, price estimates, critic scores
- **🎚️ Taste Profile** - Interactive sliders showing body, tannin, sweetness, acidity
- **💬 Social Scripts** - AI-generated talking points (The Hook, The Observation, The Question)
- **🍽️ Dynamic Pairing** - Cuisine-specific pairing recommendations
- **🏆 Social Vault** - Track "Face Earned" and scanned wine values

## Tech Stack

- **Framework:** Flutter 3.41.4
- **Language:** Dart 3.11.1
- **Database:** SQLite (sqflite)
- **State Management:** Provider
- **AI:** Kimi Vision API
- **UI:** Custom Cal AI aesthetic (dark theme)

## Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure API Key
Create `.env` file in project root:
```
KIMI_API_KEY=your_kimi_api_key_here
```

Or use dart-define:
```bash
flutter run --dart-define=KIMI_API_KEY=your_key
```

### 3. Run on Web
```bash
flutter run -d chrome
```

### 4. Build for Production
```bash
# Web
flutter build web --release

# Android APK (when SDK configured)
flutter build apk --release
```

## Project Structure

```
lib/
├── core/
│   ├── theme/           # Dark theme, colors, typography
│   └── constants/       # App constants
├── data/
│   ├── models/          # Wine, User, SearchHistory
│   ├── repositories/    # Database helper
│   └── services/        # Kimi LLM service
├── features/
│   ├── context/         # User setup screen
│   ├── scanner/         # Camera capture screen
│   ├── results/         # Bento-grid results
│   └── vault/           # History & stats
├── providers/           # State management
├── ui/components/       # Bento cards, sliders, etc.
└── main.dart
```

## Screens

### Context (Home)
- Set occupation and typical bottle budget
- Calculates consumption tier (Casual → Collector)

### Scan
- Camera capture with gallery fallback
- Animated data bubbles during analysis
- Base64 image encoding for API

### Results
- Bento-grid layout with wine identity
- Benchmarks, taste profile, serving intel
- Social scripts for conversation
- Dynamic cuisine pairing selector

### Vault
- Total "Face Earned" tracking
- Total scanned value (HKD)
- Scan history with timestamps
- Pull-to-refresh

## API Integration

The app uses Kimi's Vision API to analyze wine images. The prompt returns structured JSON with:

```json
{
  "wine_identity": { ... },
  "benchmarks": { ... },
  "taste_profile": { ... },
  "serving_intel": { ... },
  "social_scripts": { ... },
  "dynamic_pairing": { ... }
}
```

## Caching

Wines are cached by fingerprint (Producer + Vintage + Region) to minimize API costs and improve speed for repeat scans.

## License

Private project - All rights reserved.
