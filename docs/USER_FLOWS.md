# Wine AI - User Flows & Journey Maps

**Version:** 1.0  
**Date:** March 24, 2026  
**Companion to:** PRD.md

---

## 1. Overview

This document maps the complete user experience for Wine AI, focusing on the "Social Survival" positioning for Hong Kong business executives. Each flow is designed to minimize time-to-value while maximizing social utility.

---

## 2. Primary User Journey: The Business Dinner

### 2.1 Journey Map

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   BEFORE    │ →  │   ARRIVAL   │ →  │   ORDERING  │ →  │  CONVERSING │ →  │    AFTER    │
│  (Setup)    │    │  (Context)  │    │   (Scan)    │    │  (Scripts)  │    │  (Reflect)  │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
      │                  │                  │                  │                  │
      ▼                  ▼                  ▼                  ▼                  ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
• Set profile │    • Confirm    │    • Scan wine  │    • Read Hook  │    • Save wine │
• Check tier  │    • occupation │    • Get results│    • Deliver    │    • Rate exp  │
• Review past │    • Set budget │    • View scripts│   • Ask Question│    • Track face│
  wines       │    • for dinner │    • Check pairings│  • Build rapport│    • Share win │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘

Emotion: Hopeful    Emotion: Ready     Emotion: Confident  Emotion: Engaged   Emotion: Proud
         ↓                ↓                   ↓                  ↓                 ↓
    "Tonight's     "I'm prepared"    "I know this      "I'm contributing"  "I nailed it"
     the night"                        wine now"
```

### 2.2 Detailed Flow: Context → Scan → Scripts → Vault

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                    USER FLOW DIAGRAM                                     │
└─────────────────────────────────────────────────────────────────────────────────────────┘

[START]
   │
   ▼
┌─────────────────┐
│  Open App       │
│  (Cold Start)   │
└────────┬────────┘
         │
         ▼
    ┌─────────┐
    │ Profile │
    │ Setup?  │
    └────┬────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌───────┐ ┌───────────┐
│  YES  │ │    NO     │
│       │ │ (Has      │
│       │ │  profile) │
└───┬───┘ └─────┬─────┘
    │           │
    ▼           ▼
┌─────────────────┐     ┌─────────────────┐
│ Onboarding Flow │     │  Default to     │
│ • Occupation    │     │  SCAN Tab       │
│ • Budget Range  │     │                 │
│ • Preferences   │     │                 │
└────────┬────────┘     └────────┬────────┘
         │                       │
         └───────────┬───────────┘
                     │
                     ▼
            ┌─────────────────┐
            │  CONTEXT TAB    │◄──────────────────────────────────────┐
            │  (Tab 1)        │                                       │
            │                 │                                       │
            │ • View/Edit     │                                       │
            │   Profile       │                                       │
            │ • Check Stats   │                                       │
            │ • Preferences   │                                       │
            └────────┬────────┘                                       │
                     │                                                │
        ┌────────────┼────────────┐                                   │
        │            │            │                                   │
        ▼            ▼            ▼                                   │
   ┌─────────┐ ┌─────────┐ ┌─────────┐                               │
   │ Edit    │ │ Check   │ │  Go to  │───────────────────────────────┘
   │ Profile │ │  Tier   │ │  Scan   │
   └────┬────┘ └────┬────┘ └────┬────┘
        │           │           │
        └───────────┴───────────┘
                    │
                    ▼
           ┌─────────────────┐
           │   SCAN TAB      │◄──────────────────────────────────────┐
           │   (Tab 2)       │                                       │
           │   [CENTER]      │                                       │
           └────────┬────────┘                                       │
                    │                                                │
         ┌──────────┴──────────┐                                     │
         │                     │                                     │
         ▼                     ▼                                     │
    ┌─────────┐          ┌─────────┐                                │
    │ Camera  │          │ Gallery │                                │
    │  View   │          │ Select  │                                │
    └────┬────┘          └────┬────┘                                │
         │                     │                                     │
         └──────────┬──────────┘                                     │
                    │                                                │
                    ▼                                                │
           ┌─────────────────┐                                       │
           │  ANALYZING...   │                                       │
           │                 │                                       │
           │ • Show spinner  │                                       │
           │ • Wine facts    │                                       │
           │ • Progress bar  │                                       │
           └────────┬────────┘                                       │
                    │                                                │
           ┌────────┴────────┐                                       │
           │                 │                                       │
           ▼                 ▼                                       │
      ┌─────────┐      ┌─────────┐                                  │
      │ Success │      │  Fail   │                                  │
      │         │      │         │                                  │
      └────┬────┘      └────┬────┘                                  │
           │                │                                       │
           │                ▼                                       │
           │           ┌─────────────────┐                          │
           │           │  Error State    │                          │
           │           │                 │                          │
           │           │ • Show tips     │                          │
           │           │ • Retry button  │                          │
           │           │ • Manual entry  │                          │
           │           └────────┬────────┘                          │
           │                    │                                   │
           │                    └───────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         RESULTS SCREEN                                  │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ HERO SECTION                                                     │   │
│  │ • Wine image/placeholder                                         │   │
│  │ • Name, vintage, producer                                        │   │
│  │ • Rating badge                                                   │   │
│  │ • Price estimate                                                 │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ TASTE PROFILE (Expandable)                                       │   │
│  │ • Radar chart or 4 sliders                                       │   │
│  │ • Body / Tannin / Sweetness / Acidity                           │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ SOCIAL SCRIPTS (KEY DIFFERENTIATOR)                              │   │
│  │ ┌─────────────────────────────────────────────────────────────┐ │   │
│  │ │ THE HOOK                                                    │ │   │
│  │ │ "This vintage had perfect weather..."                      │ │   │
│  │ │                                          [Copy]            │ │   │
│  │ ├─────────────────────────────────────────────────────────────┤ │   │
│  │ │ THE OBSERVATION                                             │ │   │
│  │ │ "Notice how the tannins are silky despite the age..."      │ │   │
│  │ │                                          [Copy]            │ │   │
│  │ ├─────────────────────────────────────────────────────────────┤ │   │
│  │ │ THE QUESTION                                                │ │   │
│  │ │ "Have you tried the 2016 comparison?"                      │ │   │
│  │ │                                          [Copy]            │ │   │
│  │ └─────────────────────────────────────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ CUISINE PAIRING (Expandable)                                     │   │
│  │ • [Chinese ▼] [Japanese] [French] [Italian] [Steakhouse]        │   │
│  │ • Dish 1: Peking Duck ★ Safe Bet                                │   │
│  │ • Dish 2: Dim Sum Selection ★★ Impressive                       │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ BENCHMARKS (Expandable)                                          │   │
│  │ • Global Rank: #42 Bordeaux                                     │   │
│  │ • Regional Rank: #3 Margaux                                     │   │
│  │ • Value Score: ★★★★                                             │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  [💾 SAVE TO VAULT]  [📤 SHARE]  [🔄 SCAN ANOTHER]                     │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
           │
           │ (Tap Save)
           ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        SAVE ANIMATION                                   │
│                                                                         │
│  • Wine card flies to Vault tab icon                                    │
│  • "+180 Face Earned" badge appears                                     │
│  • Confetti/celebration animation                                       │
│  • Brief haptic feedback                                                │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
           │
           │ (Auto-redirect or manual)
           ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         VAULT TAB                                       │
│                         (Tab 3)                                         │
│◄────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ FACE EARNED STATS                                                │   │
│  │                                                                  │   │
│  │              🏆 2,450 🏆                                        │   │
│  │                                                                  │   │
│  │         12 wines scanned                                        │   │
│  │         ~HK$ 45,000 value                                       │   │
│  │                                                                  │   │
│  │  [Tier: Enthusiast 🍷🍷]                                        │   │
│  │  ████████░░ 80% to Connoisseur                                  │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  RECENT SCANS                                                           │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ 🍷 Château Margaux 2015                                         │   │
│  │    Bordeaux · 1st Growth                                        │   │
│  │    +180 Face · 2 days ago                                       │   │
│  │    [View] [Share] [Delete]                                      │   │
│  ├─────────────────────────────────────────────────────────────────┤   │
│  │ 🍷 Cloudy Bay Sauvignon 2023                                    │   │
│  │    Marlborough · Premium                                        │   │
│  │    +85 Face · 5 days ago                                        │   │
│  │    [View] [Share] [Delete]                                      │   │
│  ├─────────────────────────────────────────────────────────────────┤   │
│  │ 🍷 Penfolds Grange 2018                                         │   │
│  │    Barossa · Icon                                               │   │
│  │    +250 Face · 1 week ago                                       │   │
│  │    [View] [Share] [Delete]                                      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  [View All History →]                                                   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Secondary User Flows

### 3.1 Pre-Dinner Research Flow

**Scenario:** User wants to research a wine before the dinner to be extra prepared.

```
[START]
   │
   ▼
┌─────────────────┐
│  Open App       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  CONTEXT TAB    │
│  (or Scan Tab)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Search Wine    │
│  (Text Input)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Type Wine      │
│  Name           │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Search Results │
│  (List View)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Select Wine    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  WINE DETAIL (Simulated Scan)   │
│                                 │
│  • All same info as scan        │
│  • Social scripts generated     │
│  • "Save for Later" button      │
│                                 │
└────────┬────────────────────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌───────┐ ┌───────────┐
│ Save  │ │  Practice │
│       │ │  Scripts  │
└───┬───┘ └─────┬─────┘
    │           │
    ▼           ▼
┌─────────────────┐
│  VAULT TAB      │
│  (Saved for     │
│   later)        │
└─────────────────┘
```

### 3.2 Post-Dinner Reflection Flow

**Scenario:** User wants to rate the wine and reflect on the experience.

```
[START]
   │
   ▼
┌─────────────────┐
│  VAULT TAB      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Recent Scans   │
│  List           │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Select Wine    │
│  from Dinner    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  WINE DETAIL + RATING           │
│                                 │
│  • All scan info                │
│  ┌─────────────────────────┐    │
│  │ YOUR RATING             │    │
│  │  ☆ ☆ ☆ ☆ ☆             │    │
│  │  Tap stars to rate      │    │
│  └─────────────────────────┘    │
│  ┌─────────────────────────┐    │
│  │ QUICK TAGS              │    │
│  │ [✓] Impressed client    │    │
│  │ [ ] Would buy again     │    │
│  │ [ ] Overpriced          │    │
│  │ [ ] New favorite        │    │
│  └─────────────────────────┘    │
│  ┌─────────────────────────┐    │
│  │ PERSONAL NOTES          │    │
│  │ "Client loved this,      │    │
│  │  ordered a second        │    │
│  │  bottle"                │    │
│  └─────────────────────────┘    │
│                                 │
│  [💾 Save Review]               │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│  Update Stats   │
│  • Face bonus   │
│  • Tier check   │
└─────────────────┘
```

### 3.3 Quick Share Flow

**Scenario:** User wants to share their wine discovery.

```
[START]
   │
   ▼
┌─────────────────┐
│  Scan Complete  │
│  OR             │
│  Vault Entry    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Tap Share      │
│  Button         │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  SHARE OPTIONS                  │
│                                 │
│  [📷 Share as Image]            │
│   → Generate wine card          │
│   → Save to photos              │
│   → Share to Instagram/WeChat   │
│                                 │
│  [💬 Share as Text]             │
│   → Copy formatted text         │
│   → Share to WhatsApp/Email     │
│                                 │
│  [📋 Copy Scripts Only]         │
│   → Copy Hook/Observation/      │
│     Question to clipboard       │
│                                 │
└─────────────────────────────────┘
```

---

## 4. Edge Case Flows

### 4.1 Scan Failure Recovery

```
[START]
   │
   ▼
┌─────────────────┐
│  Scan Attempt   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  ANALYZING...   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  API Error /    │
│  No Match       │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  ERROR STATE SCREEN             │
│                                 │
│  "We couldn't identify this     │
│   wine clearly"                 │
│                                 │
│  ┌─────────────────────────┐    │
│  │ POSSIBLE REASONS:       │    │
│  │ • Label was blurry      │    │
│  │ • Lighting was poor     │    │
│  │ • Wine not in database  │    │
│  └─────────────────────────┘    │
│                                 │
│  [🔄 Try Again]                 │
│  [📁 Choose from Gallery]       │
│  [⌨️ Enter Manually]            │
│  [❓ Get Help]                  │
│                                 │
└─────────────────────────────────┘
         │
         │ (Enter Manually)
         ▼
┌─────────────────────────────────┐
│  MANUAL ENTRY                   │
│                                 │
│  Wine Name: [____________]      │
│  Producer:  [____________]      │
│  Vintage:   [____]              │
│                                 │
│  [Generate Scripts Anyway]      │
│   → AI will create generic      │
│     scripts based on name       │
│                                 │
└─────────────────────────────────┘
```

### 4.2 Offline Mode

```
[START]
   │
   ▼
┌─────────────────┐
│  No Network     │
│  Detected       │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  OFFLINE MODE                   │
│                                 │
│  "You're offline. Here's what   │
│   you can do:"                  │
│                                 │
│  [📚 View Vault History]        │
│   → All past scans available    │
│                                 │
│  [📷 Queue Scan]                │
│   → Photo saved                 │
│   → Will analyze when online    │
│                                 │
│  [⚙️ Settings]                  │
│   → Manage offline content      │
│                                 │
└─────────────────────────────────┘
```

### 4.3 First-Time User Onboarding

```
[START]
   │
   ▼
┌─────────────────┐
│  First Launch   │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  ONBOARDING SCREEN 1            │
│                                 │
│  🍷 Welcome to Wine AI          │
│                                 │
│  "Your personal wine assistant  │
│   for business dinners"         │
│                                 │
│  [Next]                         │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  ONBOARDING SCREEN 2            │
│                                 │
│  📸 Scan Any Wine               │
│                                 │
│  "Point your camera at any      │
│   wine label for instant        │
│   intelligence"                 │
│                                 │
│  [Demo Animation]               │
│  [Next]                         │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  ONBOARDING SCREEN 3            │
│                                 │
│  💬 Smart Scripts               │
│                                 │
│  "Get AI-generated talking      │
│   points tailored to your       │
│   profession"                   │
│                                 │
│  [Example Script Card]          │
│  [Next]                         │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  PROFILE SETUP                  │
│                                 │
│  "Let's personalize your        │
│   experience"                   │
│                                 │
│  What's your occupation?        │
│  [Dropdown/Selector]            │
│                                 │
│  Typical dinner budget?         │
│  [Slider: $300 - $5000+]        │
│                                 │
│  [Complete Setup]               │
│                                 │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│  SCAN TAB       │
│  (Ready to use) │
└─────────────────┘
```

---

## 5. Screen States Matrix

| Screen | Empty State | Loading State | Error State | Success State |
|--------|-------------|---------------|-------------|---------------|
| **Context** | "Set up your profile" | Loading profile | Retry button | Profile displayed |
| **Scan (Camera)** | N/A | N/A | Camera permission denied | Live preview |
| **Scan (Analyzing)** | N/A | Spinner + wine facts | Timeout error | Results ready |
| **Results** | N/A | Skeleton screens | Partial data warning | Full results |
| **Vault** | "No wines yet. Start scanning!" | Loading history | Sync error | List of wines |
| **Wine Detail** | N/A | Loading | Not found | Full details |

---

## 6. User Decision Trees

### 6.1 "Should I Scan or Search?"

```
                    ┌─────────────────┐
                    │  Need Wine      │
                    │  Information?   │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
        ┌─────────┐   ┌─────────┐   ┌─────────┐
        │ Have    │   │ Have    │   │ Just    │
        │ bottle  │   │ name    │   │ curious │
        │ in hand │   │ only    │   │         │
        └────┬────┘   └────┬────┘   └────┬────┘
             │             │             │
             ▼             ▼             ▼
        ┌─────────┐   ┌─────────┐   ┌─────────┐
        │  SCAN   │   │ SEARCH  │   │ BROWSE  │
        │  Tab    │   │ (future)│   │ Vault   │
        └─────────┘   └─────────┘   └─────────┘
```

### 6.2 "What Script Should I Use?"

```
                    ┌─────────────────┐
                    │  Conversation   │
                    │  Stage?         │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
        ┌─────────┐   ┌─────────┐   ┌─────────┐
        │ Starting│   │ Middle  │   │ Deep    │
        │ wine    │   │ of      │   │ discussion│
        │ talk    │   │ meal    │   │         │
        └────┬────┘   └────┬────┘   └────┬────┘
             │             │             │
             ▼             ▼             ▼
        ┌─────────┐   ┌─────────┐   ┌─────────┐
        │  HOOK   │   │OBSERVATION│  │ QUESTION│
        │         │   │         │   │         │
        │ "Have   │   │ "Notice │   │ "What's │
        │ you     │   │ the..." │   │ your..."│
        │ tried...│   │         │   │         │
        └─────────┘   └─────────┘   └─────────┘
```

---

## 7. Time-to-Value Analysis

| Step | Target Time | Critical? |
|------|-------------|-----------|
| App open to camera | < 2s | Yes |
| Camera to capture | User controlled | - |
| Capture to results | < 5s | Yes |
| Results to first script | < 1s (instant) | Yes |
| Total: Open to talking point | < 10s | Critical |

---

## 8. Emotional Journey Map

| Stage | User Goal | Potential Friction | Design Solution |
|-------|-----------|-------------------|-----------------|
| **Before** | Feel prepared | Don't know what to expect | Onboarding sets expectations |
| **Arrival** | Confirm readiness | Wrong profile settings | Easy context adjustment |
| **Ordering** | Identify wine quickly | Slow scan / no match | Fast AI + error recovery |
| **Conversation** | Sound intelligent | Scripts don't fit | Context-aware generation |
| **After** | Feel accomplished | No record of success | Vault + Face Earned celebration |

---

## 9. Mobile-First Considerations

### 9.1 One-Handed Use

- Primary actions in thumb zone
- Bottom navigation for main tabs
- Swipe gestures for common actions
- Floating action button for quick scan

### 9.2 Quick Glance

- Large, readable wine names
- High contrast for scripts
- Clear visual hierarchy
- Minimal scrolling for key info

### 9.3 Discreet Mode

- Option to dim screen
- Quick exit to "calculator" mode
- Silent haptics only
- No audio

---

## 10. Success Metrics by Flow

| Flow | Primary Metric | Target |
|------|----------------|--------|
| Scan → Results | Success rate | > 85% |
| Results → Scripts | Copy rate | > 60% |
| Scan → Vault Save | Save rate | > 70% |
| Vault → Share | Share rate | > 20% |
| App Open → Scan | Time to scan | < 5s |
| First launch → Profile complete | Onboarding completion | > 80% |

---

**Document Owner:** Olim (Product Strategist)  
**Last Updated:** March 24, 2026  
**Next Review:** Post-MVP User Testing
