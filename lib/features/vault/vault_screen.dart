import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/search_history_model.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/vault_provider.dart';
import '../../providers/wine_provider.dart';
import '../../ui/components/vivino_components.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: VivinoColors.background,
      body: SafeArea(
        child: Consumer<VaultProvider>(
          builder: (context, vaultProvider, _) {
            if (vaultProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: VivinoColors.primary),
              );
            }

            final stats = vaultProvider.stats;

            return RefreshIndicator(
              onRefresh: () => vaultProvider.refresh(),
              color: VivinoColors.primary,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.vaultTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: VivinoColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.vaultSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: VivinoColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
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
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildStatCard(
              value: _formatNumber(stats.totalFaceEarned),
              label: AppConstants.totalFaceEarned,
              icon: Icons.emoji_events,
              color: VivinoColors.star,
            ),
            _buildStatCard(
              value: 'HKD ${_formatNumber(stats.totalScannedValue)}',
              label: AppConstants.totalScannedValue,
              icon: Icons.account_balance_wallet,
              color: VivinoColors.success,
            ),
            _buildStatCard(
              value: stats.totalScans.toString(),
              label: 'Wines Scanned',
              icon: Icons.wine_bar,
              color: VivinoColors.primary,
            ),
            _buildStatCard(
              value: stats.topConsumptionTier,
              label: 'Your Tier',
              icon: Icons.workspace_premium,
              color: VivinoColors.primary,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Favorite cuisine
        if (stats.mostScannedCuisine != '-') ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: VivinoColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: VivinoColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.restaurant, color: VivinoColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Favorite Cuisine',
                        style: TextStyle(
                          color: VivinoColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stats.mostScannedCuisine,
                        style: const TextStyle(
                          color: VivinoColors.textPrimary,
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
          const SizedBox(height: 24),
        ],

        // Recent Scans Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppConstants.scanHistoryLabel,
              style: TextStyle(
                color: VivinoColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => context.read<VaultProvider>().refresh(),
              style: TextButton.styleFrom(
                foregroundColor: VivinoColors.primary,
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Scan history items
        ...stats.recentScans.map((scan) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildHistoryItem(scan),
            )),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VivinoColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: VivinoColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: VivinoColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: VivinoColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.wine_bar_outlined,
              size: 48,
              color: VivinoColors.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            AppConstants.emptyVaultMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: VivinoColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: widget.onNavigateToScan,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Start Scanning'),
            style: ElevatedButton.styleFrom(
              backgroundColor: VivinoColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: VivinoColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: VivinoColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wine_bar, color: VivinoColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan.wineName ?? 'Unknown Wine',
                    style: const TextStyle(
                      color: VivinoColors.textPrimary,
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
                            size: 12, color: VivinoColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          scan.cuisineContext!,
                          style: const TextStyle(
                            color: VivinoColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      const Icon(Icons.access_time,
                          size: 12, color: VivinoColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(scan.scannedAt),
                        style: const TextStyle(
                          color: VivinoColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (scan.faceEarned != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: VivinoColors.star.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events,
                        size: 12, color: VivinoColors.star),
                    const SizedBox(width: 4),
                    Text(
                      '+${scan.faceEarned!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: VivinoColors.star,
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
