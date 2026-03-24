import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/wine_model.dart';
import '../../providers/wine_provider.dart';
import '../../ui/components/bento_components.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WineProvider>(
      builder: (context, wineProvider, _) {
        final wine = wineProvider.currentWine;

        if (wine == null) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(title: const Text(AppConstants.resultsTitle)),
            body: const Center(
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
                  _WineHeader(identity: wine.identity),
                  const SizedBox(height: AppTheme.spacingLg),
                  _BenchmarksSection(benchmarks: wine.benchmarks),
                  const SizedBox(height: AppTheme.spacingLg),
                  _TasteSection(taste: wine.tasteProfile),
                  const SizedBox(height: AppTheme.spacingLg),
                  _ServingSection(serving: wine.servingIntel),
                  const SizedBox(height: AppTheme.spacingLg),
                  _ScriptsSection(scripts: wine.socialScripts),
                  const SizedBox(height: AppTheme.spacingLg),
                  _PairingSection(wine: wine, provider: wineProvider),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==================== WINE HEADER ====================

class _WineHeader extends StatelessWidget {
  final WineIdentity identity;
  const _WineHeader({required this.identity});

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.wineRed.withAlpha(51),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wine_bar,
                        size: 14, color: AppTheme.wineRed),
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
                      color: AppTheme.textTertiary, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
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
          Text(
            '${identity.subRegion} \u2022 ${identity.grapes.join(", ")}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ==================== BENCHMARKS ====================

class _BenchmarksSection extends StatelessWidget {
  final WineBenchmarks benchmarks;
  const _BenchmarksSection({required this.benchmarks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(AppConstants.benchmarksSection),
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
                  const Text('Avg. Price',
                      style: TextStyle(
                          color: AppTheme.textTertiary, fontSize: 11)),
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
                    const Text('Critic Score',
                        style: TextStyle(
                            color: AppTheme.textTertiary, fontSize: 11)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ==================== TASTE PROFILE ====================

class _TasteSection extends StatelessWidget {
  final TasteProfile taste;
  const _TasteSection({required this.taste});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(AppConstants.tasteSection),
        const SizedBox(height: AppTheme.spacingMd),
        BentoCard(
          child: Column(
            children: [
              TasteSlider(
                  label: 'Body',
                  value: taste.lightBold,
                  leftLabel: 'Light',
                  rightLabel: 'Bold',
                  color: AppTheme.wineRed),
              const SizedBox(height: AppTheme.spacingMd),
              TasteSlider(
                  label: 'Tannin',
                  value: taste.smoothTannic,
                  leftLabel: 'Smooth',
                  rightLabel: 'Tannic',
                  color: AppTheme.accent),
              const SizedBox(height: AppTheme.spacingMd),
              TasteSlider(
                  label: 'Sweetness',
                  value: taste.drySweet,
                  leftLabel: 'Dry',
                  rightLabel: 'Sweet',
                  color: AppTheme.warning),
              const SizedBox(height: AppTheme.spacingMd),
              TasteSlider(
                  label: 'Acidity',
                  value: taste.softAcidic,
                  leftLabel: 'Soft',
                  rightLabel: 'Acidic',
                  color: AppTheme.success),
            ],
          ),
        ),
        if (taste.aromaGroups.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingMd),
          Wrap(
            spacing: AppTheme.spacingSm,
            runSpacing: AppTheme.spacingSm,
            children: taste.aromaGroups.entries
                .expand((entry) => entry.value.map((aroma) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Text(aroma,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12)),
                    )))
                .toList(),
          ),
        ],
      ],
    );
  }
}

// ==================== SERVING INTEL ====================

class _ServingSection extends StatelessWidget {
  final ServingIntel serving;
  const _ServingSection({required this.serving});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(AppConstants.servingSection),
        const SizedBox(height: AppTheme.spacingMd),
        BentoCard(
          child: Column(
            children: [
              _servingRow(Icons.thermostat, 'Temperature',
                  '${serving.temperatureC.toStringAsFixed(0)}\u00B0C'),
              const Divider(color: AppTheme.border, height: 24),
              _servingRow(
                  Icons.timer, 'Decanting', serving.decantingRecommendation),
              const Divider(color: AppTheme.border, height: 24),
              _servingRow(Icons.wine_bar, 'Glassware',
                  serving.glasswareRecommendation),
              if (serving.servingTip.isNotEmpty) ...[
                const Divider(color: AppTheme.border, height: 24),
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        color: AppTheme.wineGold, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(serving.servingTip,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 14)),
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

  Widget _servingRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textTertiary, fontSize: 12)),
              Text(value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== SOCIAL SCRIPTS ====================

class _ScriptsSection extends StatelessWidget {
  final SocialScripts scripts;
  const _ScriptsSection({required this.scripts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(AppConstants.scriptsSection),
        const SizedBox(height: AppTheme.spacingMd),
        BentoCard(
          child: Column(
            children: [
              _scriptItem(Icons.format_quote, 'The Hook', scripts.theHook,
                  AppTheme.accent),
              const SizedBox(height: AppTheme.spacingMd),
              _scriptItem(Icons.remove_red_eye, 'The Observation',
                  scripts.theObservation, AppTheme.wineGold),
              const SizedBox(height: AppTheme.spacingMd),
              _scriptItem(Icons.help_outline, 'The Question',
                  scripts.theQuestion, AppTheme.success),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scriptItem(
      IconData icon, String title, String content, Color color) {
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
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 4),
                Text(content,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== DYNAMIC PAIRING ====================

class _PairingSection extends StatelessWidget {
  final Wine wine;
  final WineProvider provider;
  const _PairingSection({required this.wine, required this.provider});

  @override
  Widget build(BuildContext context) {
    final selectedCuisine = provider.selectedCuisine;
    final pairing = wine.pairings[selectedCuisine];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(AppConstants.pairingSection),
        const SizedBox(height: AppTheme.spacingMd),
        // Cuisine chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AppConstants.cuisines
                .map((cuisine) => Padding(
                      padding:
                          const EdgeInsets.only(right: AppTheme.spacingSm),
                      child: CuisineChip(
                        label: cuisine,
                        isSelected: selectedCuisine == cuisine,
                        onTap: () => provider.setCuisine(cuisine),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        if (pairing != null) _buildPairingCard(pairing),
      ],
    );
  }

  Widget _buildPairingCard(DynamicPairing pairing) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.success.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.restaurant,
                    size: 14, color: AppTheme.success),
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
            children: pairing.dishRecommendations
                .map((dish) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withAlpha(26),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                        border:
                            Border.all(color: AppTheme.accent.withAlpha(77)),
                      ),
                      child: Text(dish,
                          style: const TextStyle(
                              color: AppTheme.accent, fontSize: 12)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ==================== HELPER ====================

Widget _sectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: AppTheme.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}
