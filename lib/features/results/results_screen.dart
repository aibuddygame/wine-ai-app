import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/wine_model.dart';
import '../../providers/wine_provider.dart';
import '../../ui/components/vivino_components.dart';
import '../../l10n/app_localizations.dart';
import 'pairing_explorer.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<WineProvider>(
      builder: (context, wineProvider, _) {
        final wine = wineProvider.currentWine;

        if (wine == null) {
          return Scaffold(
            backgroundColor: VivinoColors.background,
            body: Center(
              child: Text(
                l10n.scanHistory,
                style: const TextStyle(color: VivinoColors.textSecondary),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: VivinoColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: VivinoColors.textPrimary),
              onPressed: () {
                wineProvider.clearCurrentWine();
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: VivinoColors.textPrimary),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: VivinoColors.textPrimary),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. HERO SECTION - Wine Image with Rating Badge
                      Center(
                        child: VivinoWineHero(
                          imageUrl: null,
                          rating: wine.benchmarks.criticScore?.toDouble() ?? 4.2,
                          ratingCount: wine.communityReview?.reviewCount ?? 2847,
                          ratingContext: l10n.ratingContext,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 2. ACTION BUTTONS - Rate & Actions
                      VivinoActionButtons(
                        rateLabel: l10n.rate,
                        actionsLabel: l10n.actions,
                        onRate: () {},
                        onActions: () {},
                      ),

                      const SizedBox(height: 24),

                      // 3. WINE IDENTITY - Producer, Name, Region
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wine.identity.producer,
                              style: const TextStyle(
                                fontSize: 14,
                                color: VivinoColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${wine.identity.fullName.split(' ').last} ${wine.identity.vintage}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: VivinoColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${_getFlagEmoji(wine.identity.country)} ',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Expanded(
                                  child: Text(
                                    '${wine.identity.wineType} from ${wine.identity.subRegion}, ${wine.identity.region}, ${wine.identity.country}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: VivinoColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 4. SUMMARY HEADER
                      Center(
                        child: VivinoSectionHeader(
                          title: l10n.summary,
                          centered: true,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 5. REGION & STYLE TAGS
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VivinoSectionHeader(title: l10n.region),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  VivinoRegionTag(
                                    label: '${wine.identity.subRegion}, ${wine.identity.country}',
                                    flagEmoji: _getFlagEmoji(wine.identity.country),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            VivinoSectionHeader(title: l10n.regionalStyle),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  VivinoRegionTag(
                                    label: '${wine.identity.country} ${wine.identity.grapeVariety.split(' ').first}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 6. TASTE PROFILE - Style Sliders
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VivinoSectionHeader(title: l10n.tasteProfile),
                            const SizedBox(height: 16),
                            VivinoStyleBar(
                              leftLabel: l10n.light,
                              rightLabel: l10n.bold,
                              value: wine.tasteProfile.lightBold / 100,
                            ),
                            VivinoStyleBar(
                              leftLabel: l10n.smooth,
                              rightLabel: l10n.tannic,
                              value: wine.tasteProfile.smoothTannic / 100,
                            ),
                            VivinoStyleBar(
                              leftLabel: l10n.dry,
                              rightLabel: l10n.sweet,
                              value: wine.tasteProfile.drySweet / 100,
                            ),
                            VivinoStyleBar(
                              leftLabel: l10n.soft,
                              rightLabel: l10n.acidic,
                              value: wine.tasteProfile.softAcidic / 100,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 7. FLAVORS - Aroma Tags
                      if (wine.flavorProfile != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VivinoSectionHeader(title: l10n.flavors),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...wine.flavorProfile!.primary.map(
                                      (f) => VivinoFlavorTag(label: f),
                                    ),
                                    ...wine.flavorProfile!.secondary.map(
                                      (f) => VivinoFlavorTag(label: f),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // 8. PAIRING EXPLORER - Interactive Cuisine Tabs
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PairingExplorer(
                          pairings: wine.pairings,
                          initialCuisine: _getInitialCuisine(wine.pairings),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 9. PREMIUM BANNER
                      VivinoPremiumBanner(
                        title: l10n.premiumBannerTitle,
                        ctaLabel: l10n.joinPremium,
                        onCta: () {},
                      ),

                      const SizedBox(height: 32),

                      // 10. GRAPE SECTION
                      if (wine.grapeEducation.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VivinoSectionHeader(title: l10n.grape),
                              const SizedBox(height: 16),
                              ...wine.grapeEducation.map(
                                (g) => VivinoGrapeItem(
                                  variety: g.variety,
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // 11. WINEMAKER'S NOTES
                      if (wine.winemakerNotes != null && wine.winemakerNotes!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VivinoSectionHeader(title: l10n.winemakerNotes),
                              const SizedBox(height: 12),
                              VivinoWinemakerNotes(notes: wine.winemakerNotes!),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // 12. WINE RANKING - Percentile Charts
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VivinoSectionHeader(title: l10n.wineRanking),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                VivinoRankingChart(
                                  scope: l10n.ofWinesInWorld,
                                  percentile: wine.benchmarks.globalTopPercent,
                                  badgeText: 'TOP ${wine.benchmarks.globalTopPercent}%',
                                ),
                                VivinoRankingChart(
                                  scope: '${l10n.ofWinesFrom} ${wine.identity.region}',
                                  percentile: wine.benchmarks.regionalTopPercent,
                                  badgeText: 'TOP ${wine.benchmarks.regionalTopPercent}%',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                l10n.bestWineInHistory,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: VivinoColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 13. REVIEWS SECTION
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                VivinoSectionHeader(
                                  title: l10n.reviews,
                                  centered: false,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    l10n.addNewReview,
                                    style: const TextStyle(
                                      color: VivinoColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Review toggle buttons
                            Row(
                              children: [
                                _buildToggleButton(l10n.helpful, true),
                                const SizedBox(width: 8),
                                _buildToggleButton(l10n.recent, false),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (wine.communityReview != null)
                              VivinoReviewCard(
                                rating: wine.communityReview!.rating,
                                reviewText: wine.communityReview!.reviewText,
                                source: wine.communityReview!.source,
                                reviewCount: wine.communityReview!.reviewCount,
                                authorName: l10n.sampleReviewerName,
                                authorRatingCount: l10n.sampleReviewerCount,
                                timeAgo: l10n.sampleTimeAgo,
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 14. SOCIAL SCRIPTS - 5-Point Strategic Social Script
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VivinoSectionHeader(title: l10n.socialScripts),
                            const SizedBox(height: 4),
                            Text(
                              l10n.socialScriptsSubtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: VivinoColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 12),
                            VivinoSocialScripts(
                              theHook: wine.socialScripts.theHook,
                              theGrape: wine.socialScripts.theGrape,
                              theRegion: wine.socialScripts.theRegion,
                              theVintage: wine.socialScripts.theVintage,
                              theTaste: wine.socialScripts.theTaste,
                              hookTitle: l10n.theHook,
                              grapeTitle: l10n.theGrape,
                              regionTitle: l10n.theRegion,
                              vintageTitle: l10n.theVintage,
                              tasteTitle: l10n.theTaste,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 15. SERVING - Tips
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VivinoSectionHeader(title: l10n.serving),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildServingItem(
                                  icon: Icons.thermostat,
                                  value: '${wine.servingIntel.temperatureC.toStringAsFixed(0)}°C',
                                  label: l10n.temperature,
                                ),
                                _buildServingItem(
                                  icon: Icons.timer_outlined,
                                  value: wine.servingIntel.decantingRecommendation,
                                  label: l10n.decanting,
                                ),
                                _buildServingItem(
                                  icon: Icons.wine_bar,
                                  value: wine.servingIntel.glasswareRecommendation,
                                  label: l10n.glass,
                                ),
                              ],
                            ),
                            if (wine.servingIntel.servingTip.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: VivinoColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.lightbulb_outline,
                                      color: VivinoColors.star,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        wine.servingIntel.servingTip,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: VivinoColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 16. SHOP SIMILAR WINES CTA
                      VivinoShopSimilarButton(
                        label: l10n.shopSimilarWines,
                        onTap: () {},
                      ),

                      // Bottom spacing
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              VivinoBottomBar(
                price: wine.benchmarks.averagePrice.toStringAsFixed(0),
                currency: wine.benchmarks.priceCurrency,
                saveLabel: l10n.saveToVault,
                priceLabel: l10n.averagePrice,
                unavailableText: l10n.unavailableForPurchase,
                onSave: () async {
                  final result = await wineProvider.saveCurrentWineToVault();
                  final isSuccess = result == 'success';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isSuccess ? l10n.saved : result),
                      backgroundColor: isSuccess ? VivinoColors.success : VivinoColors.primary,
                      duration: Duration(seconds: isSuccess ? 2 : 5),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServingItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: VivinoColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: VivinoColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: VivinoColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.black : VivinoColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : VivinoColors.textPrimary,
        ),
      ),
    );
  }

  String _getFlagEmoji(String country) {
    final Map<String, String> flags = {
      'Chile': '🇨🇱',
      'France': '🇫🇷',
      'Italy': '🇮🇹',
      'Spain': '🇪🇸',
      'USA': '🇺🇸',
      'United States': '🇺🇸',
      'Australia': '🇦🇺',
      'New Zealand': '🇳🇿',
      'Argentina': '🇦🇷',
      'South Africa': '🇿🇦',
      'Germany': '🇩🇪',
      'Portugal': '🇵🇹',
    };
    return flags[country] ?? '🍷';
  }

  String _getInitialCuisine(Map<String, DynamicPairing> pairings) {
    // Priority order for initial cuisine selection
    const priorityCuisines = ['Western', 'Chinese', 'Japanese', 'Korean', 'Asian'];
    
    for (final cuisine in priorityCuisines) {
      if (pairings.containsKey(cuisine) && pairings[cuisine] != null) {
        return cuisine;
      }
    }
    
    // Fallback to first available pairing
    return pairings.isNotEmpty ? pairings.keys.first : 'Western';
  }
}
