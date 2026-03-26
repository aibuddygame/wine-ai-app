import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
}

// Vivino Section Header
class VivinoSectionHeader extends StatelessWidget {
  final String title;
  
  const VivinoSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: VivinoColors.textTertiary,
        letterSpacing: 1.2,
      ),
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

// Vivino Wine Hero with Rating Badge
class VivinoWineHero extends StatelessWidget {
  final String? imageUrl;
  final double rating;
  final int ratingCount;

  const VivinoWineHero({
    super.key,
    this.imageUrl,
    required this.rating,
    required this.ratingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Wine bottle image
        Container(
          width: 220,
          height: 320,
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
        // Rating badge
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: VivinoColors.star,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: VivinoColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$ratingCount ratings',
                  style: const TextStyle(
                    fontSize: 11,
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

// Vivino Social Scripts Card
class VivinoSocialScripts extends StatelessWidget {
  final String theHook;
  final String theObservation;
  final String theQuestion;

  const VivinoSocialScripts({
    super.key,
    required this.theHook,
    required this.theObservation,
    required this.theQuestion,
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
          _buildScriptItem(
            icon: Icons.lightbulb_outline,
            title: 'The Hook',
            content: theHook,
            color: VivinoColors.primary,
          ),
          const Divider(height: 24),
          _buildScriptItem(
            icon: Icons.visibility_outlined,
            title: 'The Observation',
            content: theObservation,
            color: VivinoColors.star,
          ),
          const Divider(height: 24),
          _buildScriptItem(
            icon: Icons.chat_bubble_outline,
            title: 'The Question',
            content: theQuestion,
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

// Vivino Grape Education Item
class VivinoGrapeItem extends StatelessWidget {
  final String variety;
  final String percentage;
  final String description;

  const VivinoGrapeItem({
    super.key,
    required this.variety,
    required this.percentage,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                variety,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: VivinoColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: VivinoColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  percentage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: VivinoColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: VivinoColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Vivino Review Card
class VivinoReviewCard extends StatelessWidget {
  final double rating;
  final String reviewText;
  final String source;
  final int reviewCount;

  const VivinoReviewCard({
    super.key,
    required this.rating,
    required this.reviewText,
    required this.source,
    required this.reviewCount,
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
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  size: 16,
                  color: index < rating.round()
                      ? VivinoColors.star
                      : VivinoColors.border,
                );
              }),
              const Spacer(),
              Text(
                '$reviewCount ratings',
                style: const TextStyle(
                  fontSize: 12,
                  color: VivinoColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"$reviewText"',
            style: const TextStyle(
              fontSize: 14,
              color: VivinoColors.textSecondary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '- $source',
            style: const TextStyle(
              fontSize: 12,
              color: VivinoColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// Vivino Bottom Action Bar
class VivinoBottomBar extends StatelessWidget {
  final String price;
  final String currency;
  final VoidCallback onSave;

  const VivinoBottomBar({
    super.key,
    required this.price,
    required this.currency,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Average price',
                  style: TextStyle(
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
              label: const Text(
                'SAVE TO VAULT',
                style: TextStyle(
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
    );
  }
}
