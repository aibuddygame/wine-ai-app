import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Visual taste profile slider (inspired by Vivino)
class TasteProfileSlider extends StatelessWidget {
  final String label;
  final int value;
  final String leftLabel;
  final String rightLabel;
  final Color? color;

  const TasteProfileSlider({
    super.key,
    required this.label,
    required this.value,
    required this.leftLabel,
    required this.rightLabel,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? AppTheme.accent;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$value%',
              style: TextStyle(
                color: accentColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Track background
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              // Filled portion
              Flexible(
                flex: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Empty portion
              Flexible(
                flex: 100 - value,
                child: Container(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftLabel,
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 11,
              ),
            ),
            Text(
              rightLabel,
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Social Scripts Card (Wine AI Unique Feature)
class SocialScriptsCard extends StatelessWidget {
  final String theHook;
  final String theObservation;
  final String theQuestion;

  const SocialScriptsCard({
    super.key,
    required this.theHook,
    required this.theObservation,
    required this.theQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          _buildScriptItem(
            icon: Icons.catching_pokemon, // Hook icon alternative
            title: 'THE HOOK',
            content: theHook,
            color: AppTheme.accent,
          ),
          Divider(color: AppTheme.border, height: 1),
          _buildScriptItem(
            icon: Icons.visibility_outlined,
            title: 'THE OBSERVATION',
            content: theObservation,
            color: AppTheme.wineGold,
          ),
          Divider(color: AppTheme.border, height: 1),
          _buildScriptItem(
            icon: Icons.help_outline,
            title: 'THE QUESTION',
            content: theQuestion,
            color: AppTheme.success,
          ),
        ],
      ),
    );
  }

  Widget _buildScriptItem({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
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
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wine Hero Section with Rating Badge
class WineHero extends StatelessWidget {
  final String? imageUrl;
  final double rating;
  final int ratingCount;

  const WineHero({
    super.key,
    this.imageUrl,
    required this.rating,
    required this.ratingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Wine bottle placeholder
        Container(
          width: 200,
          height: 280,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(color: AppTheme.border),
          ),
          child: imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  ),
                )
              : _buildPlaceholder(),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        // Rating badge
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: AppTheme.wineGold, size: 28),
            const SizedBox(width: 8),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                color: AppTheme.wineGold,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$ratingCount ratings',
          style: const TextStyle(
            color: AppTheme.textTertiary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wine_bar,
            size: 64,
            color: AppTheme.accent.withAlpha(128),
          ),
          const SizedBox(height: 8),
          const Text(
            'Wine Image',
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Info Card (reusable card component)
class InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          child,
        ],
      ),
    );
  }
}

/// Cuisine Tabs for Pairing Section
class CuisineTabs extends StatelessWidget {
  final List<String> cuisines;
  final String selectedCuisine;
  final Function(String) onSelect;

  const CuisineTabs({
    super.key,
    required this.cuisines,
    required this.selectedCuisine,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cuisines.map((cuisine) {
          final isSelected = cuisine == selectedCuisine;
          return Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingSm),
            child: GestureDetector(
              onTap: () => onSelect(cuisine),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppTheme.accent.withAlpha(51) 
                      : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                  ),
                ),
                child: Text(
                  cuisine,
                  style: TextStyle(
                    color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Flavor Tag Chip
class FlavorChip extends StatelessWidget {
  final String label;

  const FlavorChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Serving Info Item
class ServingInfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const ServingInfoItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accent, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textTertiary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

/// Benchmark Bar (Price/Global Ranking)
class BenchmarkBar extends StatelessWidget {
  final String label;
  final String value;
  final int percentile;

  const BenchmarkBar({
    super.key,
    required this.label,
    required this.value,
    required this.percentile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Flexible(
                flex: percentile,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.success,
                    borderRadius: BorderRadius.circular(4),
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
        const SizedBox(height: 4),
        Text(
          'Top $percentile% globally',
          style: const TextStyle(
            color: AppTheme.success,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Save to Vault Button with Gamification
class SaveToVaultButton extends StatelessWidget {
  final int faceEarned;
  final String? achievement;
  final VoidCallback onPressed;

  const SaveToVaultButton({
    super.key,
    required this.faceEarned,
    this.achievement,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.add),
              label: const Text(
                'SAVE TO VAULT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppTheme.wineGold,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Face Earned: +$faceEarned points',
                style: const TextStyle(
                  color: AppTheme.wineGold,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (achievement != null) ...[
            const SizedBox(height: 4),
            Text(
              achievement!,
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
