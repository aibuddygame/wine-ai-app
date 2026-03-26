import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class DataBubbles extends StatefulWidget {
  final String cuisine;

  const DataBubbles({super.key, required this.cuisine});

  @override
  State<DataBubbles> createState() => _DataBubblesState();
}

class _DataBubblesState extends State<DataBubbles>
    with TickerProviderStateMixin {
  late final List<_BubbleData> _bubbles;
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _bubbles = [
      _BubbleData('Analyzing Vintage...', AppTheme.accent),
      _BubbleData('Mapping to ${widget.cuisine}...', AppTheme.success),
      _BubbleData('Generating Social Intel...', AppTheme.wineGold),
      _BubbleData('Scoring Compatibility...', AppTheme.accentLight),
    ];

    _controllers = List.generate(
      _bubbles.length,
      (i) => AnimationController(
        duration: const Duration(milliseconds: 2500),
        vsync: this,
      ),
    );

    _slideAnimations = _controllers.map((c) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: const Offset(0, -1.5),
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();

    _fadeAnimations = _controllers.map((c) {
      return TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 40),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
      ]).animate(c);
    }).toList();

    // Stagger the bubbles
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 600), () {
        if (mounted) _controllers[i].repeat();
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
      height: 300,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(_bubbles.length, (i) {
          final bubble = _bubbles[i];
          // Spread horizontally
          final xOffset = (i - (_bubbles.length - 1) / 2) * 30.0;

          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (context, _) {
              return SlideTransition(
                position: _slideAnimations[i],
                child: Transform.translate(
                  offset: Offset(xOffset, 0),
                  child: FadeTransition(
                    opacity: _fadeAnimations[i],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: bubble.color.withAlpha(40),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: bubble.color.withAlpha(100)),
                      ),
                      child: Text(
                        bubble.label,
                        style: TextStyle(
                          color: bubble.color,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

class _BubbleData {
  final String label;
  final Color color;
  const _BubbleData(this.label, this.color);
}
