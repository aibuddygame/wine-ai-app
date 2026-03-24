import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ==================== BENTO CARD ====================

class BentoCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const BentoCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(AppTheme.spacingMd),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// ==================== BENTO GRID ====================

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

// ==================== DATA BUBBLE ====================

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
    final c = color ?? AppTheme.accent;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.withAlpha(38),
        shape: BoxShape.circle,
        border: Border.all(color: c.withAlpha(77), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: c, size: size * 0.3),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: c,
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

// ==================== ANIMATED DATA BUBBLES ====================

class _BubbleConfig {
  final String label;
  final IconData icon;
  final Color color;
  const _BubbleConfig(this.label, this.icon, this.color);
}

class DataBubblesAnimation extends StatefulWidget {
  const DataBubblesAnimation({super.key});

  @override
  State<DataBubblesAnimation> createState() => _DataBubblesAnimationState();
}

class _DataBubblesAnimationState extends State<DataBubblesAnimation>
    with TickerProviderStateMixin {
  static const _bubbles = [
    _BubbleConfig('Identity', Icons.wine_bar, AppTheme.wineRed),
    _BubbleConfig('Taste', Icons.trending_up, AppTheme.accent),
    _BubbleConfig('Rankings', Icons.emoji_events, AppTheme.wineGold),
    _BubbleConfig('Scripts', Icons.chat_bubble, AppTheme.success),
  ];

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _bubbles.length,
      (i) => AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      ),
    );

    _animations = _controllers
        .map((c) => Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(_bubbles.length, (i) {
          final bubble = _bubbles[i];
          final angle = (i / _bubbles.length) * 2 * pi;
          const radius = 60.0;

          return AnimatedBuilder(
            animation: _animations[i],
            builder: (context, _) {
              final scale = 0.8 + 0.2 * _animations[i].value;
              final offset = Offset(
                radius * 0.8 * cos(angle) * scale,
                radius * 0.6 * sin(angle) * scale,
              );

              return Transform.translate(
                offset: offset,
                child: Opacity(
                  opacity: 0.6 + 0.4 * _animations[i].value,
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
        }),
      ),
    );
  }
}

// ==================== TASTE SLIDER ====================

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
    final c = color ?? AppTheme.accent;
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
                color: c,
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
            valueColor: AlwaysStoppedAnimation<Color>(c),
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

// ==================== PERCENT BADGE ====================

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
    final c = color ?? AppTheme.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.withAlpha(26),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: c.withAlpha(77)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$percent%',
            style: TextStyle(
              color: c,
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

// ==================== CUISINE CHIP ====================

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
          color:
              isSelected ? AppTheme.accent.withAlpha(51) : AppTheme.surfaceLight,
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

// ==================== STAT CARD ====================

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
          Icon(icon, color: color ?? AppTheme.accent, size: 28),
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

// ==================== LOADING SKELETON ====================

class SkeletonCard extends StatefulWidget {
  final double? width;
  final double height;

  const SkeletonCard({super.key, this.width, this.height = 120});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight.withAlpha(
              (_animation.value * 255).toInt(),
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
        );
      },
    );
  }
}
