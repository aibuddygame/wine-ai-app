import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/wine_model.dart';
import '../../providers/wine_provider.dart';
import '../../ui/components/vivino_components.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WineProvider>(
      builder: (context, wineProvider, _) {
        final wine = wineProvider.currentWine;

        if (wine == null) {
          return const Scaffold(
            backgroundColor: VivinoColors.background,
            body: Center(
              child: Text(
                'No wine data available',
                style: TextStyle(color: VivinoColors.textSecondary),
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
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 2. WINE IDENTITY - Producer, Name, Region
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
                            Text(
                              '${wine.identity.classification.isNotEmpty ? "${wine.identity.classification} • " : ""}${wine.identity.subRegion}, ${wine.identity.region}, ${wine.identity.country}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: VivinoColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 3. STYLE - Taste Profile Sliders
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VivinoSectionHeader(title: 'Style'),
                            const SizedBox(height: 16),
                            VivinoStyleBar(
                              leftLabel: 'Light',
                              rightLabel: 'Bold',
                              value: wine.tasteProfile.lightBold / 100,
                            ),
                            VivinoStyleBar(
                              leftLabel: 'Smooth',
                              rightLabel: 'Tannic',
                              value: wine.tasteProfile.smoothTannic / 100,
                            ),
                            VivinoStyleBar(
                              leftLabel: 'Dry',
                              rightLabel: 'Sweet',
                              value: wine.tasteProfile.drySweet / 100,
                            ),
                            VivinoStyleBar(
                              leftLabel: 'Soft',
                              rightLabel: 'Acidic',
                              value: wine.tasteProfile.softAcidic / 100,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 4. FLAVORS - Aroma Tags
                      if (wine.flavorProfile != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const VivinoSectionHeader(title: 'Flavors'),
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

                      // 5. REGION & STYLE - Description
                      if (wine.regionStyle != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const VivinoSectionHeader(title: 'Region & Style'),
                              const SizedBox(height: 12),
                              Text(
                                wine.regionStyle!.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: VivinoColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.wb_sunny_outlined,
                                    size: 16,
                                    color: VivinoColors.textTertiary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Climate: ${wine.regionStyle!.climate}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: VivinoColors.textTertiary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // 6. GRAPES - Educational Content
                      if (wine.grapeEducation.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const VivinoSectionHeader(title: 'Grapes'),
                              const SizedBox(height: 16),
                              ...wine.grapeEducation.map(
                                (g) => VivinoGrapeItem(
                                  variety: g.variety,
                                  percentage: g.percentage,
                                  description: g.description,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // 7. PAIRING - Food Match
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VivinoSectionHeader(title: 'Pairing'),
                            const SizedBox(height: 16),
                            VivinoCuisineSelector(
                              cuisines: AppConstants.cuisines,
                              selectedCuisine: wineProvider.selectedCuisine,
                              onSelect: wineProvider.setCuisine,
                            ),
                            const SizedBox(height: 24),
                            _buildPairingContent(wine, wineProvider),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 8. SOCIAL SCRIPTS - Our Unique Feature
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VivinoSectionHeader(title: 'Social Scripts'),
                            const SizedBox(height: 12),
                            VivinoSocialScripts(
                              theHook: wine.socialScripts.theHook,
                              theObservation: wine.socialScripts.theObservation,
                              theQuestion: wine.socialScripts.theQuestion,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 9. SERVING - Tips
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VivinoSectionHeader(title: 'Serving'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildServingItem(
                                  icon: Icons.thermostat,
                                  value: '${wine.servingIntel.temperatureC.toStringAsFixed(0)}°C',
                                  label: 'Temperature',
                                ),
                                _buildServingItem(
                                  icon: Icons.timer_outlined,
                                  value: wine.servingIntel.decantingRecommendation,
                                  label: 'Decanting',
                                ),
                                _buildServingItem(
                                  icon: Icons.wine_bar,
                                  value: wine.servingIntel.glasswareRecommendation,
                                  label: 'Glass',
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

                      // 10. RANKING - Global & Regional Percentiles
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VivinoSectionHeader(title: 'Ranking'),
                            const SizedBox(height: 16),
                            _buildRankingItem(
                              'World',
                              wine.benchmarks.globalTopPercent,
                            ),
                            const SizedBox(height: 12),
                            _buildRankingItem(
                              wine.identity.region,
                              wine.benchmarks.regionalTopPercent,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 11. COMMUNITY - Reviews
                      if (wine.communityReview != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const VivinoSectionHeader(title: 'Community'),
                              const SizedBox(height: 12),
                              VivinoReviewCard(
                                rating: wine.communityReview!.rating,
                                reviewText: wine.communityReview!.reviewText,
                                source: wine.communityReview!.source,
                                reviewCount: wine.communityReview!.reviewCount,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

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
                onSave: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved to Vault!')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPairingContent(Wine wine, WineProvider provider) {
    final pairing = wine.pairings[provider.selectedCuisine];
    if (pairing == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${pairing.pairingScore}%',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: VivinoColors.primary,
          ),
        ),
        const Text(
          'Match Score',
          style: TextStyle(
            fontSize: 12,
            color: VivinoColors.textTertiary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          pairing.pairingRationale,
          style: const TextStyle(
            fontSize: 14,
            color: VivinoColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Goes well with:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: VivinoColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...pairing.dishRecommendations.map(
          (dish) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.restaurant,
                  size: 16,
                  color: VivinoColors.textTertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  dish,
                  style: const TextStyle(
                    fontSize: 14,
                    color: VivinoColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildRankingItem(String scope, int percentile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top $percentile% in $scope',
              style: const TextStyle(
                fontSize: 14,
                color: VivinoColors.textSecondary,
              ),
            ),
            Text(
              '$percentile%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: VivinoColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: VivinoColors.border,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: [
              Flexible(
                flex: percentile,
                child: Container(
                  decoration: BoxDecoration(
                    color: VivinoColors.success,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Flexible(
                flex: 100 - percentile,
                child: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
