# Wine AI - Product Requirements Document (PRD)

**Version:** 1.0  
**Date:** March 24, 2026  
**Prepared for:** R2D2 (CTO/Engineer)  
**Based on:** Vivino Competitive Research (A-Orb)

---

## 1. Executive Summary

Wine AI is an AI-powered wine companion designed for Hong Kong and Asia-Pacific business executives. Unlike general-purpose wine apps like Vivino, Wine AI focuses on **social survival** — transforming wine moments into opportunities to impress clients, bosses, and peers.

### Core Value Proposition
> **"Don't just identify wine. Win the dinner."**

### Key Differentiator
AI-generated **Social Scripts** (Hook → Observation → Question) that replace crowd-sourced reviews with situationally-aware talking points tailored to the user's occupation and dining context.

---

## 2. Product Vision

### 2.1 Target User

**Primary Persona: The Hong Kong Executive**
- **Name:** Marcus Chen
- **Age:** 35-50
- **Role:** Senior Manager / Director / Entrepreneur
- **Pain Point:** "I'm at a business dinner. The client orders a wine I've never heard of. I need to say something intelligent without sounding like I'm trying too hard."
- **Goal:** Navigate wine conversations confidently, build rapport, close deals

**Secondary Personas:**
- Junior professionals seeking to impress superiors
- Expats navigating Asian business dining culture
- Sales professionals using dinners as relationship-building tools

### 2.2 Positioning Statement

For **Asia-Pacific business executives** who **use wine as a social tool**, Wine AI is a **mobile companion** that provides **instant wine intelligence and conversation starters**, unlike Vivino which focuses on **wine discovery and purchase**.

### 2.3 Success Metrics

| Metric | Target (MVP) | Target (6 months) |
|--------|--------------|-------------------|
| Monthly Active Users | 1,000 | 10,000 |
| Scans per user / month | 4 | 8 |
| Social script usage rate | 60% | 70% |
| "Face Earned" engagement | 50% of scans | 60% of scans |
| App Store Rating | 4.5+ | 4.7+ |

---

## 3. Core User Flows

### 3.1 Primary Flow: The Business Dinner Scenario

```
[Context Setup] → [Scan Wine] → [Review Results] → [Use Social Scripts] → [Save to Vault]
```

**Time to Value:** < 10 seconds from scan to first talking point

### 3.2 Secondary Flow: Pre-Dinner Preparation

```
[Search Wine] → [Review Profile] → [Prepare Scripts] → [Save for Later]
```

### 3.3 Tertiary Flow: Post-Dinner Reflection

```
[Vault] → [Review Past Scans] → [Add Personal Rating] → [Track "Face Earned"]
```

---

## 4. Feature Requirements

### 4.1 P0 Features (MVP Must-Have)

#### 4.1.1 Smart Label Scanner
**User Story:** As an executive, I want to scan a wine label so I can instantly know what I'm drinking.

**Requirements:**
- Full-screen camera with corner guide markers
- Auto-capture when label is in focus
- Gallery fallback for screenshots/photos
- Animated "analyzing" state with wine facts trivia
- < 3 second response time for Kimi Vision API

**Acceptance Criteria:**
- [ ] Scanner accessible from bottom nav (center tab)
- [ ] Corner guides help position label correctly
- [ ] Haptic feedback on capture
- [ ] Loading animation shows progress
- [ ] Graceful error handling for failed scans

#### 4.1.2 Social Scripts Engine
**User Story:** As an executive, I want AI-generated talking points so I can contribute meaningfully to wine conversations.

**Requirements:**
- Three-part script structure:
  1. **The Hook** — Attention-grabbing opener
  2. **The Observation** — Insightful comment about the wine
  3. **The Question** — Conversation starter for the table
- Context-aware generation based on:
  - User occupation (Finance, Legal, Tech, etc.)
  - Wine characteristics (region, grape, vintage)
  - Dining context (if provided)
- Copy-to-clipboard functionality for each script

**Acceptance Criteria:**
- [ ] Scripts generate within API response time
- [ ] Each script part is clearly labeled
- [ ] Copy button on each script section
- [ ] Scripts are conversationally natural (not robotic)
- [ ] Different occupations get different script tones

#### 4.1.3 Context-Aware Results
**User Story:** As an executive, I want results tailored to my profile so I get relevant intelligence, not generic facts.

**Requirements:**
- Occupation selection in Context tab
- Budget range selection affecting "Face Earned" calculation
- Results prioritize information useful for business conversation
- Regional context (Asia-Pacific focus)

**Acceptance Criteria:**
- [ ] Occupation persists across sessions
- [ ] Budget range affects face calculation
- [ ] Results highlight prestige markers (awards, rarity, etc.)
- [ ] Price estimates in HKD (primary) with USD fallback

#### 4.1.4 Taste Profile Visualization
**User Story:** As an executive, I want to see wine characteristics visually so I can quickly understand the wine's profile.

**Requirements:**
- Four-axis visualization:
  - Body (Light → Full)
  - Tannin (Soft → Firm)
  - Sweetness (Dry → Sweet)
  - Acidity (Low → High)
- Interactive sliders or radar chart
- Comparison to "typical" for the grape/region

**Acceptance Criteria:**
- [ ] Visual representation loads instantly
- [ ] Four characteristics clearly displayed
- [ ] Visual is shareable/screenshot-friendly
- [ ] Accessible color coding

#### 4.1.5 Cuisine Pairing
**User Story:** As an executive, I want pairing suggestions so I can make informed ordering recommendations.

**Requirements:**
- Dynamic pairing by cuisine type (Chinese, Japanese, French, Italian, etc.)
- Specific dish recommendations per cuisine
- "Safe bet" indicator for conservative choices
- "Impressive" indicator for bold choices

**Acceptance Criteria:**
- [ ] Minimum 5 cuisine types supported
- [ ] 2-3 specific dishes per cuisine
- [ ] Visual distinction between safe/impressive choices
- [ ] Quick cuisine selector UI

#### 4.1.6 Vault / History
**User Story:** As an executive, I want to save my scans so I can build my wine knowledge over time.

**Requirements:**
- Automatic save of all scans
- "Face Earned" calculation per wine:
  - Base score from wine quality/rarity
  - Budget efficiency multiplier
  - Context bonus (first time trying, etc.)
- Running totals (total face, wines scanned, estimated value)
- Consumption tier progression (Casual → Enthusiast → Connoisseur → Collector)

**Acceptance Criteria:**
- [ ] All scans auto-saved with timestamp
- [ ] Face calculation formula documented
- [ ] Tier progression visible and motivating
- [ ] Search/filter in vault
- [ ] Delete/archive functionality

### 4.2 P1 Features (Post-MVP)

#### 4.2.1 User Ratings
- 5-star rating system
- Quick tags ("Would buy again", "Overpriced", "Impressed client", etc.)
- Personal tasting notes

#### 4.2.2 Wine Search
- Text search by wine name
- Recent searches
- Trending wines in region

#### 4.2.3 Shareable Wine Cards
- Generate image card from scan results
- Share via native share sheet
- Pre-formatted text for messaging apps

#### 4.2.4 Offline Mode
- View vault without connection
- Queue scans for when offline
- Cache recent results

### 4.3 P2 Features (Future)

#### 4.3.1 Cellar Management
- Inventory tracking
- Drinking window recommendations
- Value tracking over time

#### 4.3.2 Personal Recommendations
- "Match for You" score based on history
- Preference learning from ratings
- Suggested wines to try

#### 4.3.3 Restaurant Menu Scanner
- Scan wine lists for recommendations
- Price comparison
- Quick "best value" indicators

---

## 5. UX Design Specifications

### 5.1 Navigation Structure

**3-Tab Bottom Navigation:**

```
┌─────────────────────────────────────────┐
│                                         │
│              [Content Area]             │
│                                         │
├──────────┬──────────┬───────────────────┤
│ Context  │   Scan   │       Vault       │
│  (Tab 1) │  (Tab 2) │      (Tab 3)      │
│          │ [Center] │                   │
└──────────┴──────────┴───────────────────┘
```

**Tab Definitions:**

1. **Context Tab** — Your Profile & Settings
   - Occupation selector
   - Budget range
   - Preferences
   - Help/About

2. **Scan Tab** — The Core Experience
   - Camera view (default)
   - Results view (after scan)
   - Center tab, visually emphasized

3. **Vault Tab** — Your Wine History
   - Scan history
   - Face Earned stats
   - Consumption tier
   - Saved favorites

### 5.2 Screen Specifications

#### 5.2.1 Context Tab

**Layout:**
```
┌─────────────────────────────┐
│  Your Profile               │
├─────────────────────────────┤
│                             │
│  [Occupation Selector]      │
│  Current: Finance           │
│                             │
│  [Budget Range]             │
│  HK$ 500 - 2,000            │
│                             │
│  [Preferences]              │
│  • Red wine focus           │
│  • Show price estimates     │
│                             │
│  ─────────────────────────  │
│                             │
│  [Help & About]             │
│  [Privacy Policy]           │
│                             │
└─────────────────────────────┘
```

**Interactions:**
- Occupation: Dropdown/selector with 8-10 common professions
- Budget: Dual-handle slider or preset ranges
- Preferences: Toggle switches

#### 5.2.2 Scan Tab — Camera View

**Layout:**
```
┌─────────────────────────────┐
│                             │
│    ┌─────────────────┐      │
│    │                 │      │
│    │   [Camera       │      │
│    │    Preview]     │      │
│    │                 │      │
│    │   Corner guides │      │
│    │   around edges  │      │
│    │                 │      │
│    └─────────────────┘      │
│                             │
│  [📁 Gallery]  [⚡ Flash]    │
│                             │
│  "Position wine label       │
│   within the frame"         │
│                             │
└─────────────────────────────┘
```

**Interactions:**
- Auto-capture when label detected
- Manual capture button (fallback)
- Gallery access for existing photos
- Flash toggle

#### 5.2.3 Scan Tab — Analyzing State

**Layout:**
```
┌─────────────────────────────┐
│                             │
│                             │
│      [Animated Logo]        │
│      or spinner             │
│                             │
│    "Analyzing wine..."      │
│                             │
│    ─────────────────        │
│    Wine Fact of the Day:    │
│    "Burgundy has over 100   │
│     distinct terroirs"      │
│    ─────────────────        │
│                             │
│                             │
└─────────────────────────────┘
```

**Interactions:**
- Rotating wine facts during analysis
- Progress indicator
- Cancel button

#### 5.2.4 Scan Tab — Results View

**Layout:**
```
┌─────────────────────────────┐
│  [Back]          [Share]    │
├─────────────────────────────┤
│                             │
│      [Wine Image]           │
│      or placeholder         │
│                             │
│  Château Margaux 2015       │
│  ★★★★★ 4.8 · Bordeaux       │
│  1st Growth · ~HK$ 6,500    │
│                             │
├─────────────────────────────┤
│  [Taste Profile Radar]      │
├─────────────────────────────┤
│  🗣️ SOCIAL SCRIPTS          │
│  ┌─────────────────────┐    │
│  │ THE HOOK            │    │
│  │ "This vintage had   │    │
│  │  perfect weather..."│    │
│  │              [Copy] │    │
│  ├─────────────────────┤    │
│  │ THE OBSERVATION     │    │
│  │ "Notice how the     │    │
│  │  tannins are..."    │    │
│  │              [Copy] │    │
│  ├─────────────────────┤    │
│  │ THE QUESTION        │    │
│  │ "Have you tried the │    │
│  │  2016 comparison?"  │    │
│  │              [Copy] │    │
│  └─────────────────────┘    │
├─────────────────────────────┤
│  🍽️ PAIRING                 │
│  [Chinese ▼]                │
│  • Peking Duck              │
│  • Dim Sum selection        │
├─────────────────────────────┤
│  📊 BENCHMARKS              │
│  Global Rank: #42 Bordeaux  │
│  Value Score: ⭐⭐⭐⭐        │
├─────────────────────────────┤
│  [💾 Save to Vault]         │
└─────────────────────────────┘
```

**Interactions:**
- Scrollable content
- Expandable/collapsible sections
- Copy buttons on scripts
- Cuisine selector dropdown
- Save button adds to vault with animation

#### 5.2.5 Vault Tab

**Layout:**
```
┌─────────────────────────────┐
│  Your Wine Vault            │
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐    │
│  │   🏆 FACE EARNED    │    │
│  │                     │    │
│  │      2,450          │    │
│  │                     │    │
│  │  12 wines scanned   │    │
│  │  ~HK$ 45,000 value  │    │
│  └─────────────────────┘    │
│                             │
│  [Tier: Enthusiast ▼]       │
│  ████████░░ 80% to next     │
│                             │
├─────────────────────────────┤
│  Recent Scans               │
│  ┌─────────────────────┐    │
│  │ 🍷 Château...       │    │
│  │    +180 Face · 2d   │    │
│  ├─────────────────────┤    │
│  │ 🍷 Cloudy Bay...    │    │
│  │    +85 Face · 5d    │    │
│  └─────────────────────┘    │
│                             │
│  [View All →]               │
└─────────────────────────────┘
```

**Interactions:**
- Tap wine card → detail view
- Pull to refresh stats
- Tier badge tap → tier explanation
- Search bar (future)

### 5.3 Visual Design System

#### 5.3.1 Color Palette

**Primary Colors:**
- Wine Red: `#722F37` (primary brand)
- Deep Burgundy: `#4A1C24` (headers, emphasis)
- Gold/Amber: `#D4AF37` (achievements, premium)

**Secondary Colors:**
- Cream/Off-white: `#F5F5DC` (backgrounds)
- Charcoal: `#36454F` (text)
- Light Gray: `#E5E5E5` (borders, dividers)

**Semantic Colors:**
- Success Green: `#2E7D32` (Face earned, good value)
- Warning Orange: `#F57C00` (moderate indicators)
- Info Blue: `#1976D2` (tips, links)

#### 5.3.2 Typography

**Font Stack:**
- Primary: System font stack (San Francisco on iOS, Roboto on Android)
- Headings: Bold weight, tight tracking
- Body: Regular weight, comfortable line height

**Hierarchy:**
- H1: 28px / Bold (Screen titles)
- H2: 22px / Bold (Section headers)
- H3: 18px / Semibold (Card titles)
- Body: 16px / Regular
- Caption: 14px / Regular (Secondary text)
- Small: 12px / Regular (Metadata)

#### 5.3.3 Components

**Buttons:**
- Primary: Filled, rounded corners (8px), wine red
- Secondary: Outlined, same radius
- Icon buttons: Circular, 44px touch target

**Cards:**
- Background: White
- Border radius: 12px
- Shadow: 0 2px 8px rgba(0,0,0,0.1)
- Padding: 16px

**Input Fields:**
- Border: 1px solid light gray
- Border radius: 8px
- Height: 48px
- Focus: Wine red border

---

## 6. Technical Requirements

### 6.1 API Integration

**Kimi Vision API:**
- Endpoint: Moonshot AI Vision endpoint
- Request: Image (base64 or URL) + prompt
- Response: Structured wine data
- Rate limiting: Handle 429s gracefully
- Timeout: 10 seconds max

**Prompt Template:**
```
Analyze this wine label image. Provide:
1. Wine name and producer
2. Vintage year
3. Grape variety/varieties
4. Region and appellation
5. Taste profile (body, tannin, sweetness, acidity on 1-5 scale)
6. Notable awards or classifications
7. Estimated price range in HKD
8. Three cuisine pairing recommendations

Format as JSON.
```

### 6.2 Social Scripts Generation

**Prompt Template:**
```
Given this wine: {wine_name}, {vintage}, {region}, {characteristics}

Generate three conversation scripts for a {occupation} at a business dinner:

1. THE HOOK: An attention-grabbing opening line about this wine (1 sentence)
2. THE OBSERVATION: An insightful comment about the wine's characteristics or pedigree (2-3 sentences)
3. THE QUESTION: A sophisticated question to engage others at the table (1 question)

Tone should be: {tone_based_on_occupation}
- Finance: Data-driven, mentions value/prestige
- Legal: Traditional, references heritage
- Tech: Modern, innovative angles
- Creative: Artistic, sensory-focused
- General: Balanced, accessible
```

### 6.3 Data Models

**Wine Model:**
```dart
class Wine {
  final String id;
  final String name;
  final String producer;
  final int? vintage;
  final String region;
  final String country;
  final List<String> grapes;
  final TasteProfile tasteProfile;
  final double? rating;
  final double? priceHkd;
  final String? imageUrl;
  final List<String> awards;
  final DateTime scannedAt;
}
```

**TasteProfile Model:**
```dart
class TasteProfile {
  final int body;        // 1-5
  final int tannin;      // 1-5
  final int sweetness;   // 1-5
  final int acidity;     // 1-5
}
```

**SocialScript Model:**
```dart
class SocialScript {
  final String hook;
  final String observation;
  final String question;
  final String occupationContext;
}
```

**UserProfile Model:**
```dart
class UserProfile {
  final String occupation;
  final double budgetMin;
  final double budgetMax;
  final String preferredCurrency;
  final List<String> preferences;
}
```

**VaultEntry Model:**
```dart
class VaultEntry {
  final String id;
  final Wine wine;
  final int faceEarned;
  final DateTime scannedAt;
  final double? userRating;
  final String? personalNotes;
  final bool isFavorite;
}
```

### 6.4 State Management

**Provider Structure:**
- `ScanProvider` — Current scan state, results
- `UserProvider` — Profile, preferences
- `VaultProvider` — History, stats, entries
- `ScriptProvider` — Social script generation

### 6.5 Local Storage

**SQLite Schema:**
```sql
CREATE TABLE wines (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  producer TEXT,
  vintage INTEGER,
  region TEXT,
  country TEXT,
  grapes TEXT, -- JSON array
  body INTEGER,
  tannin INTEGER,
  sweetness INTEGER,
  acidity INTEGER,
  rating REAL,
  price_hkd REAL,
  image_url TEXT,
  awards TEXT, -- JSON array
  scanned_at TEXT
);

CREATE TABLE vault_entries (
  id TEXT PRIMARY KEY,
  wine_id TEXT REFERENCES wines(id),
  face_earned INTEGER,
  user_rating REAL,
  personal_notes TEXT,
  is_favorite INTEGER,
  created_at TEXT
);

CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY,
  occupation TEXT,
  budget_min REAL,
  budget_max REAL,
  currency TEXT,
  preferences TEXT -- JSON
);
```

---

## 7. Face Earned Calculation

### 7.1 Formula

```
Face Earned = Base Score × Budget Multiplier × Context Bonus
```

**Base Score (0-500):**
- Wine rating: 0-200 points
  - 90+ wines: 200
  - 85-89: 150
  - 80-84: 100
  - <80: 50
- Classification bonus: 0-150 points
  - Grand Cru/1st Growth: 150
  - Premier Cru: 100
  - AOC/Appellation: 50
- Rarity factor: 0-100 points
  - Small production: 100
  - Limited release: 75
  - Standard: 50

**Budget Multiplier (0.5x - 2.0x):**
- Under budget: 1.5x - 2.0x (smart choice)
- On budget: 1.0x
- Over budget: 0.5x - 0.8x (risky)

**Context Bonus (1.0x - 1.5x):**
- First time trying: 1.2x
- Impressed client: 1.5x
- Special occasion: 1.3x
- Standard: 1.0x

### 7.2 Consumption Tiers

| Tier | Face Required | Badge |
|------|---------------|-------|
| Casual | 0-999 | 🍷 |
| Enthusiast | 1,000-4,999 | 🍷🍷 |
| Connoisseur | 5,000-14,999 | 🍷🍷🍷 |
| Collector | 15,000+ | 👑 |

---

## 8. Error Handling & Edge Cases

### 8.1 Scan Failures

**Label Not Recognized:**
- Show "Try again" with tips
- Offer manual search option
- Log for improvement

**Poor Image Quality:**
- Detect blur/low light
- Suggest retaking photo
- Provide camera tips

**API Timeout:**
- Retry once automatically
- Show "Taking longer than usual"
- Offer cancel + retry

### 8.2 Network Issues

**Offline Mode:**
- Queue scans for later
- Show cached vault data
- Indicate offline status

**Slow Connection:**
- Compress images more aggressively
- Show progress indicators
- Allow background processing

### 8.3 Data Quality

**Incomplete Wine Data:**
- Show "Partial results" badge
- Fill gaps with generic info
- Allow user to add notes

**Conflicting Information:**
- Show confidence level
- Present multiple possibilities
- Let user select correct one

---

## 9. Analytics & Tracking

### 9.1 Events to Track

**Core Flow:**
- `scan_initiated` — Camera opened
- `scan_completed` — Successful analysis
- `scan_failed` — Failed with reason
- `script_copied` — User copied a script
- `wine_saved` — Added to vault
- `vault_viewed` — Opened vault tab

**Engagement:**
- `time_in_app` — Session duration
- `screens_viewed` — Navigation patterns
- `feature_used` — Which features are popular

**Conversion:**
- `onboarding_completed` — Profile setup finished
- `tier_achieved` — Reached new consumption tier
- `share_initiated` — Used share functionality

### 9.2 Metrics Dashboard

**Daily:**
- Active scans
- Success rate
- Average time to result
- Script usage rate

**Weekly:**
- New vault entries
- Face earned total
- User retention
- Feature adoption

---

## 10. Open Questions

### For Product:
1. Should we add a "Practice Mode" for rehearsing scripts?
2. Do we need multi-language support (Cantonese, Mandarin)?
3. Should we integrate with restaurant reservation apps?

### For Engineering:
1. What's the fallback if Kimi Vision is unavailable?
2. Do we need a backend for user accounts/cloud sync?
3. What's the image storage strategy long-term?

### For Design:
1. Should we have a dark mode option?
2. What animations for "Face Earned" celebrations?
3. How to handle very long wine names in UI?

---

## 11. Appendix

### 11.1 Occupation Options

1. Finance (Banking, PE, VC, Insurance)
2. Legal (Lawyer, Judge, Legal counsel)
3. Technology (Engineer, Product, Founder)
4. Consulting (Strategy, Management)
5. Creative (Design, Marketing, Media)
6. Healthcare (Doctor, Pharma)
7. Real Estate
8. General Business / Other

### 11.2 Budget Ranges (HKD)

- Under $300 (Entry)
- $300 - $800 (Mid-range)
- $800 - $2,000 (Premium)
- $2,000 - $5,000 (Luxury)
- $5,000+ (Collector)

### 11.3 Cuisine Options

- Chinese (Cantonese, Sichuan, etc.)
- Japanese
- French
- Italian
- Steakhouse
- Seafood
- Fusion/Modern

---

**Document Owner:** Olim (Product Strategist)  
**Last Updated:** March 24, 2026  
**Next Review:** Post-MVP Launch
