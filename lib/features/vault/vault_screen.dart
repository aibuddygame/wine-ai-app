import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/vault_provider.dart';
import '../../providers/wine_provider.dart';
import '../../ui/components/bento_components.dart';
import '../results/results_screen.dart';

/// Vault Tab - History and statistics screen
class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  @override
  void initState() {
    super.initState();
    // Load stats when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VaultProvider>().loadStats();
    });
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Consumer<VaultProvider>(
          builder: (context, vaultProvider, child) {
            if (vaultProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.accent),
              );
            }

            final stats = vaultProvider.stats;
            final hasScans = stats.totalScans > 0;

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
                    // Header
                    Text(
                      AppConstants.vaultTitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text(
                      'Your wine journey and achievements',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppTheme.spacingXl),

                    // Stats Grid
                    if (hasScans) ...[
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

                      // Most Scanned Cuisine
                      if (stats.mostScannedCuisine != '-') ...[
                        BentoCard(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.accent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: AppTheme.accent,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingMd),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Favorite Cuisine',
                                      style: TextStyle(
                                        color: AppTheme.textTertiary,
                                        fontSize: 12,
                                      ),
                                    ),
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

                      // Recent Scans
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppConstants.scanHistoryLabel,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () => vaultProvider.refresh(),
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      ...stats.recentScans.map((scan) => _buildHistoryItem(scan)),
                    ] else ...[
                      // Empty State
                      _buildEmptyState(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
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
          Text(
            AppConstants.emptyVaultMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to scan tab
              DefaultTabController.of(context).animateTo(1);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Start Scanning'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(scan) {
    return GestureDetector(
      onTap: () async {
        // Load wine and navigate to results
        final wineProvider = context.read<WineProvider>();
        final wine = await wineProvider.checkCache(scan.wineFingerprint);
        if (wine != null && mounted) {
          wineProvider.setCurrentWine(wine);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ResultsScreen(),
            ),
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
                color: AppTheme.wineRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: const Icon(
                Icons.wine_bar,
                color: AppTheme.wineRed,
              ),
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
                        Icon(
                          Icons.restaurant,
                          size: 12,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          scan.cuisineContext!,
                          style: const TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppTheme.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(scan.scannedAt),
                        style: const TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (scan.faceEarned != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.wineGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 12,
                      color: AppTheme.wineGold,
                    ),
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
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
