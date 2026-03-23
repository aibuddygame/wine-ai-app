import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/wine_model.dart';
import '../../providers/wine_provider.dart';
import '../../ui/components/bento_components.dart';

/// Results Screen - Bento-grid wine analysis display
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WineProvider>(
      builder: (context, wineProvider, child) {
        final wine = wineProvider.currentWine;

        if (wine == null) {
          return const Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(
              child: Text(
                'No wine data available',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text(AppConstants.resultsTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                wineProvider.clearCurrentWine();
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wine Identity Header
                  _buildWineHeader(wine.identity),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Benchmarks
                  _buildBenchmarksSection(wine.benchmarks),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Taste Profile
                  _buildTasteSection(wine.tasteProfile),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Serving Intel
                  _buildServingSection(wine.servingIntel),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Social Scripts
                  _buildScriptsSection(wine.socialScripts),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Dynamic Pairing
                  _buildPairingSection(wine, wineProvider),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWineHeader(WineIdentity identity) {
    return BentoCard(
      backgroundColor: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Producer & Region
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.wineRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wine_bar,
                      size: 14,
                      color: AppTheme.wineRed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      identity.vintage,
                      style: const TextStyle(
                        color: AppTheme.wineRed,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  identity.region,
                  style: const TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Full Name
          Text(
            identity.fullName,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Sub-region & Grapes
          Text(
            '${identity.subRegion} • ${identity.grapes.join(", ")}',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenchmarksSection(WineBenchmarks benchmarks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.benchmarksSection,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        BentoGrid(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          children: [
            PercentBadge(
              percent: benchmarks.globalTopPercent,
              label: 'Global Top',
              color: AppTheme.wineGold,
            ),
            PercentBadge(
              percent: benchmarks.regionalTopPercent,
              label: 'Regional Top',
              color: AppTheme.accent,
            ),
            BentoCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${benchmarks.priceCurrency} ${benchmarks.averagePrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Avg. Price',
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (benchmarks.criticScore != null)
              BentoCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      benchmarks.criticScore!.toStringAsFixed(0),
                      style: const TextStyle(
                        color: AppTheme.success,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Critic Score',
                      style: TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTasteSection(TasteProfile taste) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.tasteSection,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        BentoCard(
          child: Column(
            children: [
              TasteSlider(
                label: 'Body',
                value: taste.lightBold,
                leftLabel: 'Light',
                rightLabel: 'Bold',
                color: AppTheme.wineRed,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TasteSlider(
                label: 'Tannin',
                value: taste.smoothTannic,
                leftLabel: 'Smooth',
                rightLabel: 'Tannic',
                color: AppTheme.accent,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TasteSlider(
                label: 'Sweetness',
                value: taste.drySweet,
                leftLabel: 'Dry',
                rightLabel: 'Sweet',
                color: AppTheme.warning,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TasteSlider(
                label: 'Acidity',
                value: taste.softAcidic,
                leftLabel: 'Soft',
                rightLabel: 'Acidic',
                color: AppTheme.success,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Aroma Groups
        if (taste.aromaGroups.isNotEmpty) ...[
          Wrap(
            spacing: AppTheme.spacingSm,
            runSpacing: AppTheme.spacingSm,
            children: taste.aromaGroups.entries.expand((entry) {
              return entry.value.map((aroma) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(
                    aroma,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildServingSection(ServingIntel serving) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.servingSection,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        BentoCard(
          child: Column(
            children: [
              _buildServingRow(
                icon: Icons.thermostat,
                label: 'Temperature',
                value: '${serving.temperatureC.toStringAsFixed(0)}°C',
              ),
              const Divider(color: AppTheme.border, height: 24),
              _buildServingRow(
                icon: Icons.timer,
                label: 'Decanting',
                value: serving.decantingRecommendation,
              ),
              const Divider(color: AppTheme.border, height: 24),
              _buildServingRow(
                icon: Icons.wine_bar,
                label: 'Glassware',
                value: serving.glasswareRecommendation,
              ),
              if (serving.servingTip.isNotEmpty) ...[
                const Divider(color: AppTheme.border, height: 24),
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppTheme.wineGold,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        serving.servingTip,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServingRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.accent,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScriptsSection(SocialScripts scripts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.scriptsSection,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        BentoCard(
          backgroundColor: AppTheme.surface,
          child: Column(
            children: [
              _buildScriptItem(
                icon: Icons.format_quote,
                title: 'The Hook',
                content: scripts.theHook,
                color: AppTheme.accent,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              _buildScriptItem(
                icon: Icons.remove_red_eye,
                title: 'The Observation',
                content: scripts.theObservation,
                color: AppTheme.wineGold,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              _buildScriptItem(
                icon: Icons.help_outline,
                title: 'The Question',
                content: scripts.theQuestion,
                color: AppTheme.success,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScriptItem({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPairingSection(Wine wine, WineProvider provider) {
    final selectedCuisine = provider.selectedCuisine;
    final pairing = wine.pairings[selectedCuisine];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.pairingSection,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Cuisine Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AppConstants.cuisines.map((cuisine) {
              return Padding(
                padding: const EdgeInsets.only(right: AppTheme.spacingSm),
                child: CuisineChip(
                  label: cuisine,
                  isSelected: selectedCuisine == cuisine,
                  onTap: () => provider.setCuisine(cuisine),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Pairing Card
        if (pairing != null) ...[
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.restaurant,
                            size: 14,
                            color: AppTheme.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${pairing.pairingScore}% Match',
                            style: const TextStyle(
                              color: AppTheme.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  pairing.pairingRationale,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const Text(
                  'Recommended Dishes:',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Wrap(
                  spacing: AppTheme.spacingSm,
                  runSpacing: AppTheme.spacingSm,
                  children: pairing.dishRecommendations.map((dish) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
                      ),
                      child: Text(
                        dish,
                        style: const TextStyle(
                          color: AppTheme.accent,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
