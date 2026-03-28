import 'package:flutter/material.dart';
import '../../data/models/wine_model.dart';
import '../../ui/components/vivino_components.dart';

/// Interactive Cuisine Pairing Explorer
/// 
/// Features:
/// - Horizontal scrollable tabs: Chinese, Japanese, Korean, Western, Asian
/// - Active: Black bg, white text, 24px radius
/// - Inactive: Transparent bg, gray text, no borders
/// - Bento-style content card with compatibility score and dish chips
class PairingExplorer extends StatefulWidget {
  final Map<String, DynamicPairing> pairings;
  final String initialCuisine;

  const PairingExplorer({
    super.key,
    required this.pairings,
    this.initialCuisine = 'Western',
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
    if (cuisine == _selectedCuisine) return;
    
    setState(() {
      _selectedCuisine = cuisine;
    });
    
    // Trigger fade animation
    _animationController.reset();
    _animationController.forward();
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
    final pairing = _currentPairing;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const VivinoSectionHeader(title: 'Pairing Explorer'),
        const SizedBox(height: 12),
        
        // Tab Bar - Horizontal Scrollable
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _cuisines.map((cuisine) {
              final isSelected = cuisine == _selectedCuisine;
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
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Bento-Style Content Card
        FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
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
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return const Color(0xFF2E7D32); // Green
    if (score >= 80) return VivinoColors.primary;     // Wine red
    if (score >= 70) return const Color(0xFFF57C00); // Orange
    return const Color(0xFF757575);                   // Gray
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
