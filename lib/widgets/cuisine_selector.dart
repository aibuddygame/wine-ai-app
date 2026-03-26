import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';

class CuisineSelector extends StatelessWidget {
  final String selectedCuisine;
  final ValueChanged<String> onCuisineSelected;

  const CuisineSelector({
    super.key,
    required this.selectedCuisine,
    required this.onCuisineSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: AppConstants.cuisines.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cuisine = AppConstants.cuisines[index];
          final isSelected = cuisine == selectedCuisine;

          return GestureDetector(
            onTap: () => onCuisineSelected(cuisine),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white54,
                  width: 1.5,
                ),
              ),
              child: Text(
                cuisine,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
