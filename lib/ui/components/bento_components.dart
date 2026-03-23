import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Bento Grid Card - Base component for Cal AI aesthetic
class BentoCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Border? border;

  const BentoCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(AppTheme.spacingMd),
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: border ?? Border.all(color: AppTheme.border, width: 1),
        ),
        child: child,
      ),
    );
  }
}

/// Bento Grid Layout
class BentoGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double spacing;
  final double childAspectRatio;

  const BentoGrid({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.spacing = AppTheme.spacingMd,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      childAspectRatio: childAspectRatio,
      children: children,
    );
  }
}

/// Data Bubble - Floating animated bubble for loading states
class DataBubble extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final double size;

  const DataBubble({
    super.key,
    required this.label,
    required this.icon,
    this.color,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: (color ?? AppTheme.accent).withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: (color ?? AppTheme.accent).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color ?? AppTheme.accent,
            size: size * 0.3,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color ?? AppTheme.accent,
              fontSize: size * 0.12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Animated Data Bubbles for analysis loading state
class DataBubblesAnimation extends StatefulWidget {
  const DataBubblesAnimation({super.key});

  @override
  State<DataBubblesAnimation> createState() => _DataBubblesAnimationState();
}

class _DataBubblesAnimationState extends State<DataBubblesAnimation>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  final List<_BubbleData> _bubbles = [
    _BubbleData('Identity', Icons.wine_bar, AppTheme.wineRed, 0),
    _BubbleData('Taste', Icons.trending_up, AppTheme.accent, 1),
    _BubbleData('Rankings', Icons.emoji_events, AppTheme.wineGold, 2),
    _BubbleData('Scripts', Icons.chat_bubble, AppTheme.success, 3),
  ];

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(
      _bubbles.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Start animations with stagger
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: _bubbles.asMap().entries.map((entry) {
          final index = entry.key;
          final bubble = entry.value;
          
          // Position bubbles in a circle
          final angle = (index / _bubbles.length) * 2 * 3.14159;
          final radius = 60.0;
          
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final offset = Offset(
                radius * 0.8 * cos(angle) * (0.8 + 0.2 * _animations[index].value),
                radius * 0.6 * sin(angle) * (0.8 + 0.2 * _animations[index].value),
              );
              
              return Transform.translate(
                offset: offset,
                child: Opacity(
                  opacity: 0.6 + 0.4 * _animations[index].value,
                  child: DataBubble(
                    label: bubble.label,
                    icon: bubble.icon,
                    color: bubble.color,
                    size: 70,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class _BubbleData {
  final String label;
  final IconData icon;
  final Color color;
  final int index;

  _BubbleData(this.label, this.icon, this.color, this.index);
}

/// Taste Profile Slider Widget
class TasteSlider extends StatelessWidget {
  final String label;
  final int value;
  final String leftLabel;
  final String rightLabel;
  final Color? color;

  const TasteSlider({
    super.key,
    required this.label,
    required this.value,
    required this.leftLabel,
    required this.rightLabel,
    this.color,
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
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$value%',
              style: TextStyle(
                color: color ?? AppTheme.accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: AppTheme.surfaceLight,
            valueColor: AlwaysStoppedAnimation<Color>(color ?? AppTheme.accent),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftLabel,
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 10,
              ),
            ),
            Text(
              rightLabel,
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Percentage Badge
class PercentBadge extends StatelessWidget {
  final int percent;
  final String label;
  final Color? color;

  const PercentBadge({
    super.key,
    required this.percent,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppTheme.accent;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$percent%',
            style: TextStyle(
              color: badgeColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Cuisine Chip Selector
class CuisineChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CuisineChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withOpacity(0.2) : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Stat Card for Vault
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color ?? AppTheme.accent,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
