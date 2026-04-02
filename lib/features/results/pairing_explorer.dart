import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../data/models/wine_model.dart';
import '../../services/menu_analysis_service.dart';
import '../../ui/components/vivino_components.dart';
import 'menu_camera_dialog.dart';

/// Interactive Cuisine Pairing Explorer
/// 
/// Features:
/// - Horizontal scrollable tabs: Chinese, Japanese, Korean, Western, Asian, Today's Menu
/// - Active: Black bg, white text, 24px radius
/// - Inactive: Transparent bg, gray text, no borders
/// - Bento-style content card with compatibility score and dish chips
class PairingExplorer extends StatefulWidget {
  final Map<String, DynamicPairing> pairings;
  final String initialCuisine;
  final Wine? currentWine;
  final String? apiKey;

  const PairingExplorer({
    super.key,
    required this.pairings,
    this.initialCuisine = 'Western',
    this.currentWine,
    this.apiKey,
  });

  @override
  State<PairingExplorer> createState() => _PairingExplorerState();
}

class _PairingExplorerState extends State<PairingExplorer>
    with SingleTickerProviderStateMixin {
  late String _selectedCuisine;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _cuisines = ['Chinese', 'Japanese', 'Korean', 'Western', 'Asian'];
  
  // Today's Menu state
  bool _isTodayMenu = false;
  MenuPairingResult? _todayMenuResult;
  bool _isAnalyzingMenu = false;

  @override
  void initState() {
    super.initState();
    _selectedCuisine = _cuisines.contains(widget.initialCuisine)
        ? widget.initialCuisine
        : 'Western';
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCuisineSelected(String cuisine) {
    if (cuisine == _selectedCuisine && !_isTodayMenu) return;
    
    setState(() {
      _selectedCuisine = cuisine;
      _isTodayMenu = false;
    });
    
    // Trigger fade animation
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _onTodayMenuSelected() async {
    // If already have results, just show them
    if (_todayMenuResult != null) {
      setState(() {
        _isTodayMenu = true;
      });
      _animationController.reset();
      _animationController.forward();
      return;
    }

    // Show camera dialog
    final imageBytes = await MenuCameraDialog.show(context);
    if (imageBytes == null || widget.currentWine == null) return;

    setState(() {
      _isAnalyzingMenu = true;
      _isTodayMenu = true;
    });

    try {
      final apiKey = widget.apiKey;
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key not configured. Please check your settings.');
      }
      
      final service = MenuAnalysisService(apiKey: apiKey);
      
      final wineJson = jsonEncode(widget.currentWine!.toJson());
      final result = await service.analyzeMenu(
        wineProfileJson: wineJson,
        menuImageBytes: imageBytes,
      );

      if (!mounted) return;
      
      setState(() {
        _todayMenuResult = result;
        _isAnalyzingMenu = false;
      });
      
      _animationController.reset();
      _animationController.forward();
      
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isTodayMenu = false;
        _isAnalyzingMenu = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Menu analysis failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  DynamicPairing get _currentPairing {
    return widget.pairings[_selectedCuisine] ??
        const DynamicPairing(
          cuisine: 'Western',
          pairingRationale: 'Classic pairing with rich, bold flavors',
          dishRecommendations: ['Grilled Steak', 'Roasted Lamb', 'Aged Cheese'],
          pairingScore: 85,
        );
  }

  String get _cuisineEmoji {
    if (_isTodayMenu) return '📷';
    switch (_selectedCuisine) {
      case 'Chinese':
        return '🥢';
      case 'Japanese':
        return '🍱';
      case 'Korean':
        return '🥘';
      case 'Western':
        return '🍽️';
      case 'Asian':
        return '🌶️';
      default:
        return '🍽️';
    }
  }

  String get _cuisineLogicTitle {
    if (_isTodayMenu) return "Today's Menu";
    switch (_selectedCuisine) {
      case 'Chinese':
        return 'Umami & Fat';
      case 'Japanese':
        return 'Cleanliness & Delicacy';
      case 'Korean':
        return 'Fermentation & Spice';
      case 'Western':
        return 'Protein & Cream';
      case 'Asian':
        return 'Aromatics & Heat';
      default:
        return 'Classic Pairing';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const VivinoSectionHeader(title: 'Pairing Explorer'),
        const SizedBox(height: 12),
        
        // Tab Bar - Horizontal Scrollable (Cuisines + Today's Menu)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Cuisine tabs
              ..._cuisines.map((cuisine) {
                final isSelected = cuisine == _selectedCuisine && !_isTodayMenu;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _onCuisineSelected(cuisine),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        cuisine,
                        style: TextStyle(
                          color: isSelected ? Colors.white : VivinoColors.textSecondary,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              
              // Today's Menu button
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: _onTodayMenuSelected,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: _isTodayMenu ? Colors.black : VivinoColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isTodayMenu ? Colors.black : VivinoColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: _isTodayMenu ? Colors.white : VivinoColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Today's Menu",
                          style: TextStyle(
                            color: _isTodayMenu ? Colors.white : VivinoColors.primary,
                            fontSize: 14,
                            fontWeight: _isTodayMenu ? FontWeight.w600 : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Content Card
        FadeTransition(
          opacity: _fadeAnimation,
          child: _isTodayMenu
              ? _buildTodayMenuCard()
              : _buildCuisineCard(_currentPairing),
        ),
      ],
    );
  }

  Widget _buildCuisineCard(DynamicPairing pairing) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VivinoColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Compatibility Score + Why it Works
          Row(
            children: [
              // Score Circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _getScoreColor(pairing.pairingScore),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${pairing.pairingScore}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '%',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Why it Works
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _cuisineEmoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _cuisineLogicTitle,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: VivinoColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      pairing.pairingRationale.isNotEmpty
                          ? pairing.pairingRationale
                          : 'This wine complements ${_selectedCuisine.toLowerCase()} cuisine beautifully.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: VivinoColors.textPrimary,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          
          // Bottom Section: Recommended Dishes
          const Text(
            'Recommended Dishes',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: VivinoColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          // Dish Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pairing.dishRecommendations.take(3).map((dish) {
              return _DishChip(label: dish);
            }).toList(),
          ),
          
          // Avoid dishes (if any)
          if (pairing.avoidDishes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.block_outlined,
                  size: 14,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  'Avoid: ${pairing.avoidDishes.take(2).join(', ')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTodayMenuCard() {
    if (_isAnalyzingMenu) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VivinoColors.border, width: 1),
        ),
        child: const Column(
          children: [
            CircularProgressIndicator(color: VivinoColors.primary),
            SizedBox(height: 16),
            Text(
              'Analyzing menu...',
              style: TextStyle(
                color: VivinoColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_todayMenuResult == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VivinoColors.border, width: 1),
        ),
        child: Column(
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 48,
              color: VivinoColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap "Today\'s Menu" to take a photo of the menu',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: VivinoColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final result = _todayMenuResult!;
    final goodPairings = result.goodPairings;
    final avoidPairings = result.avoidPairings;
    final hasGoodPairings = goodPairings.isNotEmpty;
    
    // Calculate average score for display
    final avgScore = result.pairings.isEmpty
        ? 0
        : result.pairings.map((p) => p.compatibilityScore).reduce((a, b) => a + b) ~/ result.pairings.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VivinoColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Overall Score + Verdict
          Row(
            children: [
              // Score Circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _getVerdictColor(result.overallVerdict),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$avgScore',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '%',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Verdict
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _cuisineEmoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _cuisineLogicTitle,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: VivinoColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getVerdictColor(result.overallVerdict).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        result.overallVerdict.toUpperCase(),
                        style: TextStyle(
                          color: _getVerdictColor(result.overallVerdict),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (result.suggestion != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        result.suggestion!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: VivinoColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          
          // Poor match warning
          if (!result.isSuitable) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Consider a Different Wine',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  if (result.wineRecommendation != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Better choice: ${result.wineRecommendation}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: VivinoColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Good pairings
          if (hasGoodPairings) ...[
            const Text(
              'Best Pairings from Menu',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: VivinoColors.textTertiary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ...goodPairings.take(3).map((pairing) => _MenuDishCard(pairing: pairing)),
          ],
          
          // Avoid pairings
          if (avoidPairings.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Avoid',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ...avoidPairings.take(2).map((pairing) => _MenuDishCard(pairing: pairing, isAvoid: true)),
          ],
          
          // Retake photo button
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _todayMenuResult = null;
                });
                _onTodayMenuSelected();
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Analyze Different Menu'),
              style: TextButton.styleFrom(
                foregroundColor: VivinoColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return const Color(0xFF2E7D32); // Green
    if (score >= 80) return VivinoColors.primary;     // Wine red
    if (score >= 70) return const Color(0xFFF57C00); // Orange
    return const Color(0xFF757575);                   // Gray
  }

  Color _getVerdictColor(String verdict) {
    switch (verdict) {
      case 'excellent':
        return const Color(0xFF2E7D32); // Green
      case 'good':
        return VivinoColors.primary;     // Wine red
      case 'fair':
        return const Color(0xFFF57C00); // Orange
      case 'poor':
        return Colors.redAccent;
      default:
        return VivinoColors.textSecondary;
    }
  }
}

/// Dish Chip Widget
class _DishChip extends StatelessWidget {
  final String label;

  const _DishChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: VivinoColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VivinoColors.border, width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: VivinoColors.textPrimary,
        ),
      ),
    );
  }
}

/// Menu dish pairing card
class _MenuDishCard extends StatelessWidget {
  final DishPairing pairing;
  final bool isAvoid;

  const _MenuDishCard({required this.pairing, this.isAvoid = false});

  @override
  Widget build(BuildContext context) {
    final color = isAvoid
        ? Colors.redAccent
        : (pairing.compatibilityScore >= 90
            ? const Color(0xFF2E7D32)
            : VivinoColors.primary);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: VivinoColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAvoid ? Colors.redAccent.withValues(alpha: 0.3) : VivinoColors.border),
      ),
      child: Row(
        children: [
          // Score
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${pairing.compatibilityScore}',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Dish info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pairing.dish,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: VivinoColors.textPrimary,
                  ),
                ),
                if (pairing.whyItWorks.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    pairing.whyItWorks,
                    style: const TextStyle(
                      fontSize: 12,
                      color: VivinoColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Icon
          Icon(
            isAvoid ? Icons.cancel : Icons.check_circle,
            color: color,
            size: 20,
          ),
        ],
      ),
    );
  }
}
