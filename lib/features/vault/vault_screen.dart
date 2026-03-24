import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/search_history_model.dart';
import '../../providers/vault_provider.dart';
import '../../providers/wine_provider.dart';
import '../../ui/components/bento_components.dart';
import '../results/results_screen.dart';

class VaultScreen extends StatefulWidget {
  final VoidCallback? onNavigateToScan;
  const VaultScreen({super.key, this.onNavigateToScan});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VaultProvider>().loadStats();
    });
  }

  String _formatNumber(double number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) return '${diff.inMinutes}m ago';
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Consumer<VaultProvider>(
          builder: (context, vaultProvider, _) {
            if (vaultProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.accent),
              );
            }

            final stats = vaultProvider.stats;

            return RefreshIndicator(
              onRefresh: () => vaultProvider.refresh(),
              color: AppTheme.accent,
              backgroundColor: AppTheme.surface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppConstants.vaultTitle,
                        style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text('Your wine journey and achievements',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: AppTheme.spacingXl),
                    if (stats.totalScans > 0)
                      _buildContent(stats)
                    else
                      _buildEmptyState(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(VaultStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Grid
        BentoGrid(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          children: [
            StatCard(
              value: _formatNumber(stats.totalFaceEarned),
              label: AppConstants.totalFaceEarned,
              icon: Icons.emoji_events,
              color: AppTheme.wineGold,
            ),
            StatCard(
              value: 'HKD ${_formatNumber(stats.totalScannedValue)}',
              label: AppConstants.totalScannedValue,
              icon: Icons.account_balance_wallet,
              color: AppTheme.success,
            ),
            StatCard(
              value: stats.totalScans.toString(),
              label: 'Wines Scanned',
              icon: Icons.wine_bar,
              color: AppTheme.accent,
            ),
            StatCard(
              value: stats.topConsumptionTier,
              label: 'Your Tier',
              icon: Icons.workspace_premium,
              color: AppTheme.wineRed,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Favorite cuisine
        if (stats.mostScannedCuisine != '-') ...[
          BentoCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withAlpha(51),
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(Icons.restaurant, color: AppTheme.accent),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Favorite Cuisine',
                          style: TextStyle(
                              color: AppTheme.textTertiary, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(
                        stats.mostScannedCuisine,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
        ],

        // Recent Scans Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppConstants.scanHistoryLabel,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => context.read<VaultProvider>().refresh(),
              child: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Scan history items
        ...stats.recentScans.map((scan) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
              child: _buildHistoryItem(scan),
            )),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppTheme.spacingXxl),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
            ),
            child: const Icon(
              Icons.wine_bar_outlined,
              size: 48,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          const Text(
            AppConstants.emptyVaultMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ElevatedButton.icon(
            onPressed: widget.onNavigateToScan,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Start Scanning'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(SearchHistory scan) {
    return GestureDetector(
      onTap: () async {
        final wineProvider = context.read<WineProvider>();
        final wine = await wineProvider.checkCache(scan.wineFingerprint);
        if (wine != null && mounted) {
          wineProvider.setCurrentWine(wine);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ResultsScreen()),
          );
        }
      },
      child: BentoCard(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.wineRed.withAlpha(51),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: const Icon(Icons.wine_bar, color: AppTheme.wineRed),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan.wineName ?? 'Unknown Wine',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (scan.cuisineContext != null) ...[
                        const Icon(Icons.restaurant,
                            size: 12, color: AppTheme.textTertiary),
                        const SizedBox(width: 4),
                        Text(scan.cuisineContext!,
                            style: const TextStyle(
                                color: AppTheme.textTertiary, fontSize: 12)),
                        const SizedBox(width: 12),
                      ],
                      const Icon(Icons.access_time,
                          size: 12, color: AppTheme.textTertiary),
                      const SizedBox(width: 4),
                      Text(_formatDate(scan.scannedAt),
                          style: const TextStyle(
                              color: AppTheme.textTertiary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            if (scan.faceEarned != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.wineGold.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events,
                        size: 12, color: AppTheme.wineGold),
                    const SizedBox(width: 4),
                    Text(
                      '+${scan.faceEarned!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppTheme.wineGold,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
