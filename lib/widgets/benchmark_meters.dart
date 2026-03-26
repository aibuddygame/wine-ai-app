import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class BenchmarkMeters extends StatelessWidget {
  final int worldPercentile;
  final int regionPercentile;

  const BenchmarkMeters({
    super.key,
    required this.worldPercentile,
    required this.regionPercentile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CircularMeter(
            value: worldPercentile,
            label: 'Top World',
            color: AppTheme.accent,
          ),
          _CircularMeter(
            value: regionPercentile,
            label: 'Top Region',
            color: AppTheme.accentLight,
          ),
        ],
      ),
    );
  }
}

class _CircularMeter extends StatefulWidget {
  final int value;
  final String label;
  final Color color;

  const _CircularMeter({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  State<_CircularMeter> createState() => _CircularMeterState();
}

class _CircularMeterState extends State<_CircularMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.value / 100)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return CustomPaint(
                painter: _RingPainter(
                  progress: _animation.value,
                  color: widget.color,
                  trackColor: AppTheme.surfaceLight,
                ),
                child: Center(
                  child: Text(
                    '${(widget.value).toString()}%',
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: const TextStyle(
            color: AppTheme.textTertiary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 8.0;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
