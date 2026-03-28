import 'package:flutter/material.dart';

// Vivino-inspired color palette (Light Theme)
class VivinoColors {
  static const Color primary = Color(0xFFA61A3E); // Wine red
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color border = Color(0xFFE0E0E0);
  static const Color star = Color(0xFFFFB800);
  static const Color success = Color(0xFF4CAF50);
  static const Color premiumGradientStart = Color(0xFF6B1A2E); // Dark wine
  static const Color premiumGradientEnd = Color(0xFFA61A3E); // Wine red
}

// Vivino Section Header - Centered style from mockups
class VivinoSectionHeader extends StatelessWidget {
  final String title;
  final bool centered;
  
  const VivinoSectionHeader({
    super.key, 
    required this.title,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: centered ? 22 : 12,
        fontWeight: centered ? FontWeight.bold : FontWeight.w600,
        color: centered ? VivinoColors.textPrimary : VivinoColors.textTertiary,
        letterSpacing: centered ? 0 : 1.2,
      ),
      textAlign: centered ? TextAlign.center : TextAlign.left,
    );
  }
}

// Vivino Style Bar (for taste profile)
class VivinoStyleBar extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final double value; // 0.0 to 1.0

  const VivinoStyleBar({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: VivinoColors.textSecondary,
                ),
              ),
              Text(
                rightLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: VivinoColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: VivinoColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              children: [
                Flexible(
                  flex: (value * 100).toInt(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: VivinoColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Flexible(
                  flex: ((1 - value) * 100).toInt(),
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Vivino Flavor Tag
class VivinoFlavorTag extends StatelessWidget {
  final String label;

  const VivinoFlavorTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: VivinoColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: VivinoColors.textSecondary,
        ),
      ),
    );
  }
}

// Vivino Food Pairing Chip
class VivinoPairingChip extends StatelessWidget {
  final String label;

  const VivinoPairingChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: VivinoColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: VivinoColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Vivino Region/Style Tag with flag
class VivinoRegionTag extends StatelessWidget {
  final String label;
  final String? flagEmoji;

  const VivinoRegionTag({
    super.key,
    required this.label,
    this.flagEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: VivinoColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (flagEmoji != null) ...[
            Text(flagEmoji!, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: VivinoColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Vivino Cuisine Selector
class VivinoCuisineSelector extends StatelessWidget {
  final List<String> cuisines;
  final String selectedCuisine;
  final Function(String) onSelect;

  const VivinoCuisineSelector({
    super.key,
    required this.cuisines,
    required this.selectedCuisine,
    required this.onSelect,
  });

  IconData _getCuisineIcon(String cuisine) {
    switch (cuisine.toLowerCase()) {
      case 'cantonese':
      case 'chinese':
        return Icons.ramen_dining;
      case 'western':
        return Icons.restaurant;
      case 'japanese':
        return Icons.set_meal;
      case 'italian':
        return Icons.local_pizza;
      case 'french':
        return Icons.wine_bar;
      case 'sichuan':
        return Icons.local_fire_department;
      default:
        return Icons.restaurant_menu;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cuisines.map((cuisine) {
          final isSelected = cuisine == selectedCuisine;
          return GestureDetector(
            onTap: () => onSelect(cuisine),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? VivinoColors.primary : VivinoColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getCuisineIcon(cuisine),
                    color: isSelected ? Colors.white : VivinoColors.textSecondary,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cuisine,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white : VivinoColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Vivino Wine Hero with Rating Badge - Updated to match mockup exactly
class VivinoWineHero extends StatelessWidget {
  final String? imageUrl;
  final double rating;
  final int ratingCount;
  final String? ratingContext;

  const VivinoWineHero({
    super.key,
    this.imageUrl,
    required this.rating,
    required this.ratingCount,
    this.ratingContext,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Wine bottle image
        Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
            color: VivinoColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.wine_bar,
                    size: 80,
                    color: VivinoColors.primary.withOpacity(0.3),
                  ),
                ),
        ),
        // Rating badge - positioned bottom right as in mockup
        Positioned(
          bottom: 20,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ratingContext != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ratingContext!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: VivinoColors.star,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: VivinoColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$ratingCount ratings',
                  style: const TextStyle(
                    fontSize: 12,
                    color: VivinoColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Vivino Action Buttons (Rate & Actions)
class VivinoActionButtons extends StatelessWidget {
  final VoidCallback? onRate;
  final VoidCallback? onActions;
  final String rateLabel;
  final String actionsLabel;

  const VivinoActionButtons({
    super.key,
    this.onRate,
    this.onActions,
    required this.rateLabel,
    required this.actionsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Rate Button
        OutlinedButton.icon(
          onPressed: onRate,
          icon: const Icon(Icons.star, color: Colors.orange, size: 18),
          label: Text(
            rateLabel,
            style: const TextStyle(
              color: VivinoColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: VivinoColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        const SizedBox(width: 12),
        // Actions Button
        OutlinedButton.icon(
          onPressed: onActions,
          icon: const Icon(Icons.add, color: VivinoColors.textSecondary, size: 18),
          label: Text(
            actionsLabel,
            style: const TextStyle(
              color: VivinoColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: VivinoColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }
}

// Vivino Premium Banner
class VivinoPremiumBanner extends StatelessWidget {
  final String title;
  final String ctaLabel;
  final VoidCallback? onCta;

  const VivinoPremiumBanner({
    super.key,
    required this.title,
    required this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [VivinoColors.premiumGradientStart, VivinoColors.premiumGradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onCta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: VivinoColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    ctaLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Food image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

// Vivino Grape Item with chevron
class VivinoGrapeItem extends StatelessWidget {
  final String variety;
  final VoidCallback? onTap;

  const VivinoGrapeItem({
    super.key,
    required this.variety,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: VivinoColors.border),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.local_florist,
              color: VivinoColors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                variety,
                style: const TextStyle(
                  fontSize: 15,
                  color: VivinoColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: VivinoColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

// Vivino Winemaker Notes
class VivinoWinemakerNotes extends StatelessWidget {
  final String notes;

  const VivinoWinemakerNotes({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Text(
      notes,
      style: const TextStyle(
        fontSize: 14,
        color: VivinoColors.textSecondary,
        height: 1.6,
      ),
    );
  }
}

// Vivino Review Card - Updated to match mockup
class VivinoReviewCard extends StatelessWidget {
  final double rating;
  final String reviewText;
  final String source;
  final int reviewCount;
  final String? authorName;
  final String? authorRatingCount;
  final String? timeAgo;

  const VivinoReviewCard({
    super.key,
    required this.rating,
    required this.reviewText,
    required this.source,
    required this.reviewCount,
    this.authorName,
    this.authorRatingCount,
    this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VivinoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: VivinoColors.star,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: VivinoColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Review title if available
          if (authorName != null)
            Text(
              reviewText.length > 50 ? '${reviewText.substring(0, 50)}...' : reviewText,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: VivinoColors.textPrimary,
              ),
            )
          else
            Text(
              '"$reviewText"',
              style: const TextStyle(
                fontSize: 14,
                color: VivinoColors.textSecondary,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          const SizedBox(height: 12),
          // Author info
          if (authorName != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: VivinoColors.surface,
                  child: Icon(
                    Icons.person,
                    size: 18,
                    color: VivinoColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: VivinoColors.textPrimary,
                        ),
                      ),
                      if (authorRatingCount != null)
                        Text(
                          authorRatingCount!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: VivinoColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (timeAgo != null)
                  Text(
                    timeAgo!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: VivinoColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ] else ...[
            Text(
              '- $source',
              style: const TextStyle(
                fontSize: 12,
                color: VivinoColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Vivino Wine Ranking Chart (Wine glass shaped)
class VivinoRankingChart extends StatelessWidget {
  final String scope;
  final int percentile;
  final String? badgeText;

  const VivinoRankingChart({
    super.key,
    required this.scope,
    required this.percentile,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Wine glass visualization
        Stack(
          alignment: Alignment.center,
          children: [
            // Background wine glass outline
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: VivinoColors.surface,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            // Filled portion
            Container(
              width: 80,
              height: 100 * (percentile / 100),
              decoration: BoxDecoration(
                color: VivinoColors.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            // Badge
            if (badgeText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D4037),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          scope,
          style: const TextStyle(
            fontSize: 12,
            color: VivinoColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Vivino Social Scripts Card - 5-Point Strategic Social Script
class VivinoSocialScripts extends StatelessWidget {
  final String theHook;      // Point 1: Prestige fact
  final String theGrape;     // Point 2: Grape character
  final String theRegion;    // Point 3: Terroir impact
  final String theVintage;   // Point 4: Vintage insight
  final String theTaste;     // Point 5: Sensory trip
  final String hookTitle;
  final String grapeTitle;
  final String regionTitle;
  final String vintageTitle;
  final String tasteTitle;

  const VivinoSocialScripts({
    super.key,
    required this.theHook,
    required this.theGrape,
    required this.theRegion,
    required this.theVintage,
    required this.theTaste,
    required this.hookTitle,
    required this.grapeTitle,
    required this.regionTitle,
    required this.vintageTitle,
    required this.tasteTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VivinoColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Point 1: The Hook (Prestige)
          _buildScriptItem(
            icon: Icons.emoji_events_outlined,
            title: hookTitle,
            content: theHook,
            color: VivinoColors.primary,
          ),
          const Divider(height: 24),
          // Point 2: The Grape (Character)
          _buildScriptItem(
            icon: Icons.grass_outlined,
            title: grapeTitle,
            content: theGrape,
            color: VivinoColors.star,
          ),
          const Divider(height: 24),
          // Point 3: The Region (Terroir)
          _buildScriptItem(
            icon: Icons.terrain_outlined,
            title: regionTitle,
            content: theRegion,
            color: const Color(0xFF2E7D32), // Green
          ),
          const Divider(height: 24),
          // Point 4: The Vintage (Expert Insight)
          _buildScriptItem(
            icon: Icons.calendar_today_outlined,
            title: vintageTitle,
            content: theVintage,
            color: const Color(0xFF1565C0), // Blue
          ),
          const Divider(height: 24),
          // Point 5: The Taste (Sensory Trip)
          _buildScriptItem(
            icon: Icons.wine_bar_outlined,
            title: tasteTitle,
            content: theTaste,
            color: VivinoColors.success,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
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
                  color: VivinoColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Vivino Bottom Action Bar - Updated to match mockup
class VivinoBottomBar extends StatelessWidget {
  final String price;
  final String currency;
  final String saveLabel;
  final String priceLabel;
  final VoidCallback onSave;
  final String? unavailableText;

  const VivinoBottomBar({
    super.key,
    required this.price,
    required this.currency,
    required this.saveLabel,
    required this.priceLabel,
    required this.onSave,
    this.unavailableText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (unavailableText != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: VivinoColors.surface,
                child: Text(
                  unavailableText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: VivinoColors.textSecondary,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        priceLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: VivinoColors.textTertiary,
                        ),
                      ),
                      Text(
                        '$currency $price',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: VivinoColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.add),
                    label: Text(
                      saveLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}

// Vivino Shop Similar Button (Full width)
class VivinoShopSimilarButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const VivinoShopSimilarButton({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
