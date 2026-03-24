# Wine AI App - Product Specification
## Vivino Competitive Analysis & Feature Roadmap

**Prepared for:** Olim (Product Strategist) & R2D2 (CTO/Engineer)  
**Date:** March 24, 2026  
**Status:** Draft v1.0

---

## Executive Summary

This document analyzes Vivino's feature set, UX patterns, and business model to inform the Wine AI MVP roadmap. Wine AI currently has a solid foundation with Context, Scan, and Vault tabs using a unique "Social Survival" positioning for Hong Kong business professionals. This spec identifies which Vivino features to adopt, adapt, or skip.

**Key Insight:** Vivino is a general-purpose wine app (70M users, 16M wines). Wine AI should differentiate through:
- **Vertical focus:** Business dinner social intelligence (not just wine info)
- **Cultural specificity:** Hong Kong/Asian business dining context
- **AI-first approach:** Kimi Vision for instant analysis vs. crowd-sourced database

---

## 1. Vivino Deep Dive

### 1.1 Core Features Analysis

| Feature | Vivino Implementation | User Value | Complexity |
|---------|----------------------|------------|------------|
| **Label Scanner** | Photo → OCR → Database match → Wine profile | Instant wine identification | High (CV + database) |
| **Wine Database** | 16M wines, 245K wineries, crowd-sourced | Comprehensive coverage | Very High |
| **Ratings & Reviews** | 5-star + text reviews, community-driven | Social proof, quality assessment | Medium |
| **Personal Ratings** | User logs own ratings, builds taste profile | Personal journal, recommendations | Low |
| **"Match for You" Score** | ML-based personal recommendation engine | Personalized suggestions | High |
| **Cellar Management** | Inventory tracking, drinking windows | Collection management | Medium |
| **Wine Marketplace** | 500+ merchants, in-app purchasing | Convenience, price comparison | Very High |
| **Social Features** | Follow friends, share reviews, community | Discovery, social validation | Medium |
| **Restaurant Menu Scan** | Scan wine lists for recommendations | Dining out assistance | High |
| **Taste Profile** | Track preferred styles/regions/grapes | Personalization | Low |

### 1.2 UX Patterns Worth Copying

#### A. Scanner Flow
```
Camera View → Auto-capture on focus → Animated analysis → Results
```
- **Corner markers** guide label positioning
- **Real-time feedback** (bubbles/particles) during analysis
- **Fallback options** (manual search, gallery) when scan fails

#### B. Results Layout
- **Hero section:** Large wine image, name, vintage, rating
- **Horizontal scroll cards:** Key stats (price, rating, food pairings)
- **Expandable sections:** Detailed info (tasting notes, winery, region)
- **Action bar:** Rate, save, share, buy buttons (sticky bottom)

#### C. Wine Card Design
- **Visual hierarchy:** Wine image > Name/Rating > Key stats
- **Color coding:** Score badges (green=good, red=poor)
- **Quick actions:** Heart (save), share icon, price tag

#### D. Navigation Structure
```
Home (Discovery) | Scan (Camera) | Search | Profile | Cellar
```
- **Scan is central** — always accessible
- **Bottom nav** with 4-5 primary tabs
- **Floating action button** for quick scan from any screen

### 1.3 Business Model

| Revenue Stream | Description | Est. Contribution |
|---------------|-------------|-------------------|
| **Marketplace commissions** | 10-15% on wine sales | Primary (60%+) |
| **Vivino Premium** | $4.99/mo or $47.90/yr subscription | Secondary (20%) |
| **Featured placements** | Promoted wines, sponsored listings | Tertiary (15%) |
| **Affiliate partnerships** | Referral fees from merchants | Minor (5%) |

**Premium Features (Subscription):**
- Advanced cellar management
- Detailed drinking windows
- Exclusive deals
- Ad-free experience
- Advanced search filters

### 1.4 Key Differentiators

1. **Scale:** 16M wines, 70M users — network effect moat
2. **Database quality:** Manual curation + ML validation
3. **Marketplace integration:** Buy directly from scan results
4. **Community:** Social proof through ratings/reviews

---

## 2. Wine AI vs Vivino: Positioning Matrix

| Dimension | Vivino | Wine AI (Current) | Wine AI (Opportunity) |
|-----------|--------|-------------------|----------------------|
| **Primary Use Case** | Wine discovery & purchase | Business dinner survival | Executive social intelligence |
| **Target User** | General wine enthusiasts | HK business professionals | Asia-Pacific executives |
| **Core Value** | "Find good wine" | "Save face at dinner" | "Be impressive effortlessly" |
| **Data Source** | Crowd-sourced database | Kimi Vision AI | AI + curated intelligence |
| **Differentiation** | Scale & community | Context-aware social scripts | Cultural + situational expertise |
| **Monetization** | Marketplace + Premium | TBD | B2B2C (corporate partnerships) |

---

## 3. Feature Prioritization for Wine AI MVP

### 3.1 Must-Have (P0) — Core Differentiation

| Feature | Description | Rationale | Effort |
|---------|-------------|-----------|--------|
| **Smart Label Scanner** | Kimi Vision-based instant analysis | Core tech advantage; no database needed | Medium |
| **Social Scripts Engine** | AI-generated talking points (Hook/Observation/Question) | **Key differentiator** from Vivino | Low |
| **Context-Aware Results** | Occupation + budget → tailored output | Personalization without user history | Low |
| **Taste Profile Visualization** | Interactive sliders (body/tannin/sweetness/acidity) | Engaging, shareable UI | Low |
| **Cuisine Pairing** | Dynamic pairing by cuisine type | Practical dinner utility | Low |
| **Vault/History** | Scan history with "Face Earned" tracking | Gamification, retention | Low |

### 3.2 Should-Have (P1) — Competitive Parity

| Feature | Description | Rationale | Effort |
|---------|-------------|-----------|--------|
| **User Ratings** | Rate wines 1-5 stars + quick tags | Build personal taste profile over time | Low |
| **Wine Search** | Text search by name/region/grape | When scanning isn't possible | Medium |
| **Save/Favorites** | Bookmark wines to personal list | Basic collection feature | Low |
| **Share Results** | Export wine card (image/text) | Viral growth, social proof | Low |
| **Offline Cache** | View past scans without connection | Reliability | Low |

### 3.3 Nice-to-Have (P2) — Future Expansion

| Feature | Description | Rationale | Effort |
|---------|-------------|-----------|--------|
| **Cellar Management** | Track inventory, drinking windows | Vivino parity; collector segment | Medium |
| **Personal Recommendations** | "Match for You" based on history | Requires user data scale | High |
| **Social Feed** | See what friends are drinking | Network effects, engagement | High |
| **Restaurant Menu Scan** | Scan wine lists for picks | High utility, complex CV | High |
| **Price Comparison** | Show prices from merchants | Monetization prep | Medium |
| **Wine Education** | Articles, quizzes, learning paths | Engagement, retention | Medium |

### 3.4 Won't-Have (Explicitly Skip)

| Feature | Reason to Skip |
|---------|----------------|
| **Crowd-sourced reviews** | Requires massive user base; AI scripts are differentiator |
| **In-app marketplace** | Complex logistics, regulatory; affiliate model later |
| **16M wine database** | AI vision replaces need for manual database |
| **Global winery profiles** | Out of scope; focus on consumption moment |
| **Community features** | Different audience (executives vs enthusiasts) |

---

## 4. User Flow Recommendations

### 4.1 Primary Flow: Business Dinner Scenario

```
[Context Setup] → [Scan Wine] → [Review Results] → [Use Social Scripts] → [Save to Vault]
```

**Context Setup (Current: Context Tab)**
- Occupation selection (affects script tone)
- Budget range (affects "Face Earned" calculation)
- Optional: Dining cuisine context

**Scan Wine (Current: Scan Tab)**
- Full-screen camera with corner guides
- Gallery fallback for screenshots
- Animated "analyzing" state with wine facts

**Review Results (Current: Results Screen)**
- **Hero card:** Wine name, vintage, region, producer
- **Benchmarks:** Global/regional ranking, price estimate
- **Taste Profile:** Visual sliders
- **Social Scripts:** The Hook, Observation, Question
- **Pairing:** Cuisine selector with dish recommendations
- **Quick Actions:** Save, Share, Scan Another

**Save to Vault (Current: Vault Tab)**
- "Face Earned" calculation based on wine quality vs. budget
- Running totals (total face, scanned value)
- Consumption tier (Casual → Collector)

### 4.2 Secondary Flow: Pre-Dinner Research

```
[Search Wine] → [View Profile] → [Prepare Scripts] → [Save for Later]
```

**Search Wine (New Feature)**
- Text search by wine name
- Recent searches
- Trending wines in your area

### 4.3 UX Improvements from Vivino

| Current Wine AI | Vivino Pattern | Recommendation |
|-----------------|----------------|----------------|
| Static results screen | Expandable sections | Add collapsible detail sections |
| No wine image | Large wine photo | Add AI-generated or placeholder bottle image |
| Single cuisine pairing | Multiple pairing cards | Show top 3 cuisine matches |
| No rating input | 5-star rating | Add quick rating after viewing |
| Text-only sharing | Shareable wine cards | Generate image card for sharing |

---

## 5. Technical Considerations

### 5.1 Current Architecture (Strengths)

```
Flutter Web → Provider State Management → SQLite (local)
                    ↓
              Kimi Vision API (image analysis)
```

**Strengths:**
- Fast iteration (Flutter hot reload)
- Single codebase (web → mobile later)
- AI-first (no database maintenance)
- Local storage (privacy, offline)

### 5.2 Technical Debt & Scaling

| Area | Current State | Recommendation |
|------|---------------|----------------|
| **Database** | SQLite local only | Add cloud sync option for multi-device |
| **Image storage** | Base64 in memory | Cache to disk; compress uploads |
| **API costs** | Per-scan Kimi calls | Implement fingerprint caching (✓ already done) |
| **State management** | Provider | Evaluate Riverpod for complex features |
| **Offline support** | View history only | Add offline scan queue |

### 5.3 New Features: Technical Requirements

| Feature | Technical Needs | Est. Effort |
|---------|-----------------|-------------|
| **Text Search** | Wine name index, fuzzy matching | 2-3 days |
| **User Ratings** | Rating model, aggregation | 1-2 days |
| **Share Cards** | Flutter screenshot, image generation | 2-3 days |
| **Social Feed** | Backend, auth, feed algorithm | 2-3 weeks |
| **Cellar Management** | Inventory model, alerts | 3-5 days |
| **Restaurant Menu Scan** | OCR + wine name extraction | 1-2 weeks |

### 5.4 Vivino's Tech Stack (Reference)

- **Mobile:** Native iOS/Android (not Flutter)
- **Backend:** Microservices, likely Java/Kotlin
- **Database:** PostgreSQL + Elasticsearch for search
- **ML:** Custom CV models for label recognition
- **Infrastructure:** AWS/GCP hybrid

**Wine AI Advantage:** Kimi Vision eliminates need for custom CV training and massive wine database.

---

## 6. Competitive Insights

### 6.1 Vivino Weaknesses to Exploit

1. **Information overload** — Too much data for casual users
2. **Generic recommendations** — Not situationally aware
3. **No cultural context** — Western-centric content
4. **Slow scan-to-result** — Database lookup vs. AI inference
5. **Pushy monetization** — Aggressive premium upsells (per user reviews)

### 6.2 Other Competitors

| App | Strengths | Weaknesses | Wine AI Differentiation |
|-----|-----------|------------|------------------------|
| **Delectable** | Clean UI, expert curation | Smaller database, US-focused | AI scripts + Asian context |
| **Wine-Searcher** | Price comparison, inventory | No scanning, dated UI | Modern UX + social features |
| **Hello Vino** | Simple, beginner-friendly | Limited depth | Executive-level intelligence |
| **SnapWine** | AI scanning | No social/context features | Social survival positioning |

### 6.3 Market Opportunity

**Total Addressable Market (TAM):**
- Global wine app market: ~$500M (2024)
- Asia-Pacific wine consumption growing 8% YoY
- Business dining culture in HK, Singapore, Shanghai

**Serviceable Obtainable Market (SOM):**
- HK business professionals: ~500K
- Target: 10% penetration = 50K users
- Expansion: Singapore, Shanghai, Tokyo

---

## 7. Implementation Roadmap

### Phase 1: MVP Polish (Current → Launch)
**Timeline:** 2-3 weeks

- [ ] Add wine search (text-based)
- [ ] Implement user ratings (1-5 stars)
- [ ] Create shareable wine cards
- [ ] Add collapsible sections to results
- [ ] Improve scanner UX (guides, feedback)
- [ ] Add onboarding flow

### Phase 2: Core Differentiation
**Timeline:** 4-6 weeks

- [ ] Enhanced social scripts (more contexts)
- [ ] Multi-cuisine pairing view
- [ ] Personal taste profile over time
- [ ] Offline mode improvements
- [ ] Push notifications (daily wine tip)

### Phase 3: Growth Features
**Timeline:** 2-3 months

- [ ] Social sharing/feed (optional)
- [ ] Cellar management (inventory)
- [ ] Restaurant menu scanner
- [ ] Corporate/team accounts
- [ ] Partnership integrations (restaurants)

---

## 8. Open Questions for Olim & R2D2

### Product Strategy
1. **Monetization:** Freemium vs. B2B (corporate subscriptions)?
2. **Geographic expansion:** HK → Singapore → ? Priority order?
3. **Social features:** Is a feed valuable for executives, or is it noise?

### Technical
1. **Backend:** When do we need a proper backend vs. local-first?
2. **Database:** Should we build a wine database or stay AI-only?
3. **Mobile:** Timeline for native iOS/Android apps?

### UX
1. **Onboarding:** How much context to collect upfront vs. gradually?
2. **Results density:** More info (Vivino-style) or keep minimal?
3. **Gamification:** Is "Face Earned" working, or need different metaphor?

---

## 9. Appendix: Vivino UI Screenshots Reference

### Key Screens to Study
1. **Home/Discovery** — Featured wines, trending, personalized picks
2. **Scanner** — Camera view with guides, manual search fallback
3. **Wine Detail** — Hero image, rating, price, buy button, reviews
4. **Profile** — Taste profile, scan history, saved wines
5. **Cellar** — Inventory grid, drinking windows, value tracking

### Design Patterns
- **Card-based layouts** with rounded corners
- **High-quality wine photography**
- **Color-coded rating badges** (green/yellow/red)
- **Bottom sheets** for quick actions
- **Skeleton loaders** during data fetch

---

## 10. Summary: Key Takeaways

### What to Copy from Vivino
1. ✓ Scanner-first UX with clear visual guides
2. ✓ Card-based results layout
3. ✓ Quick actions (save, share, rate)
4. ✓ Personal taste tracking over time
5. ✓ "Vault" concept (cellar/wine history)

### What to Do Differently
1. ✗ Skip crowd-sourced reviews → Use AI scripts
2. ✗ Skip marketplace → Focus on utility first
3. ✗ Skip social feed → Optional, not core
4. ✗ Skip massive database → AI vision replaces it
5. ✗ Skip generic positioning → Double down on business context

### Biggest Opportunity
**Executive Wine Intelligence:** Be the app that doesn't just identify wine, but makes you look smart in front of clients, bosses, and peers. Vivino helps you buy wine. Wine AI helps you win dinners.

---

*Document prepared by A-Orb (Market Research Agent)*  
*For questions or clarifications, contact via Telegram group*
