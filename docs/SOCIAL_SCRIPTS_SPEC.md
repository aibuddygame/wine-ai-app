# 5-Point Strategic Social Script Specification

## Overview

The Social Scripts feature has been upgraded from 3 points to **5 strategic talking points** designed to help users impress at business dinners. Each point builds on the previous one, creating a compelling narrative arc from prestige to sensory experience.

---

## The 5-Point Structure

### Point 1: THE HOOK (PRESTIGE)
**Purpose:** Open with a prestigious fact that establishes credibility and sparks interest.

**Prompt for AI:**
> "Find one prestigious fact. Does this winery have an award, a famous owner, or a unique history (e.g., 'oldest in the region')? Write it as a conversation starter that sounds like an 'insider' secret."

**Example Output:**
- *"This winery was founded in 1853 by a former advisor to Napoleon III — it's been family-owned for six generations."*
- *"The owner is actually a tech billionaire who bought this estate after retiring from Silicon Valley."*

**UI Label:** "1. The Hook (Prestige)" / "1. 開場白（聲望）"

---

### Point 2: THE GRAPE (CHARACTER)
**Purpose:** Explain the grape's role and personality in this specific bottle.

**Prompt for AI:**
> "Describe the grape's role here. If it's a blend, explain the balance. If a single varietal, explain its 'personality' in this bottle (e.g., 'This Cabernet is known for its thick skins, giving us that deep color and structure')."

**Example Output:**
- *"This is 100% Cabernet Sauvignon — those thick skins give us that deep ruby color and the firm tannins that'll soften beautifully with age."*
- *"It's a classic Bordeaux blend: Cabernet provides the backbone, Merlot adds the plushness, and a touch of Cabernet Franc brings that herbal complexity."*

**UI Label:** "2. The Grape (Character)" / "2. 葡萄品種（個性）"

---

### Point 3: THE REGION (TERROIR)
**Purpose:** Connect the wine to its place of origin through specific environmental factors.

**Prompt for AI:**
> "Explain the impact of the geography. Mention one specific environmental factor (e.g., 'The cool breezes from the Andes' or 'The limestone soil of Burgundy') and how it makes the wine taste 'finer' or 'bolder'."

**Example Output:**
- *"The vineyards sit at 800 meters in the Andes foothills — those cool mountain breezes slow down ripening, giving the wine this incredible freshness and elegance you don't find in valley wines."*
- *"The limestone soil here is the secret — it forces the vines to struggle, which concentrates the flavors and gives that distinctive minerality on the finish."*

**UI Label:** "3. The Region (Terroir)" / "3. 產區（風土）"

---

### Point 4: THE VINTAGE (EXPERT INSIGHT)
**Purpose:** Demonstrate expertise by interpreting the weather conditions of the harvest year.

**Prompt for AI:**
> "Research the specific climate conditions of the bottle's region for its harvest year. Identify if it was a 'Cool/Slow' year (resulting in elegance, higher acidity, and 'Old World' restraint) or a 'Warm/Fast' year (resulting in bold fruit, higher alcohol, and 'New World' power). Translate these weather facts into a social narrative. If the year was difficult (e.g., drought or frost), frame it as a 'Triumph of Quality over Quantity' to add prestige. Avoid dry data like '250mm of rain'; instead, use phrases like 'The vines really had to struggle, which gave us this incredible concentration.'"

**Example Output:**
- *"2019 was a challenging year — a late frost in spring actually reduced the crop by 30%, but what remained was incredibly concentrated. You can taste that intensity in every sip."*
- *"2020 was warm and dry, which meant the grapes ripened quickly. The result is this lush, opulent style with plenty of ripe fruit — very 'New World' in character."*

**UI Label:** "4. The Vintage (Expert Insight)" / "4. 年份（專家見解）"

---

### Point 5: TASTE & FLAVORS (SENSORY TRIP)
**Purpose:** Guide the listener through the tasting experience, combining quantitative data with qualitative descriptions.

**Prompt for AI:**
> "Combine the quantitative 'sliders' with qualitative 'flavors'. Use phrases like: 'You'll notice the [Flavor Notes] up front, followed by a [Taste Characteristic, e.g., velvety/acidic] finish that lingers.'"

**Example Output:**
- *"On the nose, you'll get blackcurrant and cedar from the oak. On the palate, it's full-bodied with those firm tannins, and the finish is long with a touch of graphite minerality."*
- *"The first thing you'll notice is that vibrant red fruit — cherry and raspberry — then the acidity kicks in, giving it this refreshing, almost juicy quality that makes you want another sip."*

**UI Label:** "5. Taste & Flavors (Sensory Trip)" / "5. 味道與風味（感官之旅）"

---

## Data Model Changes

### Updated `SocialScripts` Class

```dart
class SocialScripts {
  final String theHook;      // Point 1: Prestige fact
  final String theGrape;     // Point 2: Grape character
  final String theRegion;    // Point 3: Terroir impact
  final String theVintage;   // Point 4: Vintage insight
  final String theTaste;     // Point 5: Sensory trip

  const SocialScripts({
    required this.theHook,
    required this.theGrape,
    required this.theRegion,
    required this.theVintage,
    required this.theTaste,
  });
  
  // ... fromJson/toJson methods
}
```

### JSON Structure

```json
{
  "social_scripts": {
    "the_hook": "...",
    "the_grape": "...",
    "the_region": "...",
    "the_vintage": "...",
    "the_taste": "..."
  }
}
```

---

## UI Implementation

### Visual Design

Each point is displayed as a card with:
- **Icon:** Unique icon representing the point type
- **Title:** Numbered label (e.g., "1. The Hook (Prestige)")
- **Content:** The generated script text
- **Color:** Distinct color for each point for visual separation

### Icon Mapping

| Point | Icon | Color |
|-------|------|-------|
| 1. The Hook | `emoji_events_outlined` | Primary Wine Red |
| 2. The Grape | `grass_outlined` | Gold/Star |
| 3. The Region | `terrain_outlined` | Green |
| 4. The Vintage | `calendar_today_outlined` | Blue |
| 5. The Taste | `wine_bar_outlined` | Success Green |

### Localization

**English:**
- Section Title: "Social Scripts"
- Subtitle: "5 talking points to impress at your dinner"
- Points: "1. The Hook (Prestige)", "2. The Grape (Character)", etc.

**Traditional Chinese (HK Style):**
- Section Title: "社交腳本"
- Subtitle: "5個談話要點，讓您在晚宴上留下深刻印象"
- Points: "1. 開場白（聲望）", "2. 葡萄品種（個性）", etc.

---

## API Integration Notes

When calling the Kimi API for wine analysis, the prompt should request all 5 social script points:

```
Generate a 5-point strategic social script for this wine:

1. THE HOOK (PRESTIGE): Find one prestigious fact about the winery...
2. THE GRAPE (CHARACTER): Describe the grape's role and personality...
3. THE REGION (TERROIR): Explain the geography's impact...
4. THE VINTAGE (EXPERT INSIGHT): Analyze the harvest year conditions...
5. TASTE & FLAVORS (SENSORY TRIP): Guide through the tasting experience...

Also consider the user's current cuisine context: [CUISINE_TYPE]
```

---

## Files Modified

1. `lib/data/models/wine_model.dart` — Updated `SocialScripts` class
2. `lib/ui/components/vivino_components.dart` — Updated `VivinoSocialScripts` widget
3. `lib/features/results/results_screen.dart` — Updated to use 5-point structure
4. `lib/l10n/app_en.arb` — Added new localization strings
5. `lib/l10n/app_zh_TW.arb` — Added Traditional Chinese translations
6. `docs/SOCIAL_SCRIPTS_SPEC.md` — This document

---

## Testing Checklist

- [ ] SocialScripts model correctly serializes/deserializes
- [ ] UI displays all 5 points with correct icons and colors
- [ ] Localization works in both English and Traditional Chinese
- [ ] Empty/null values are handled gracefully
- [ ] Long text content is properly scrollable
- [ ] Theme switching works correctly

---

*Last Updated: March 28, 2026*
