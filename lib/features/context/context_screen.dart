import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/user_provider.dart';
import '../../ui/components/bento_components.dart';

/// Context Tab - User setup screen
class ContextScreen extends StatefulWidget {
  const ContextScreen({super.key});

  @override
  State<ContextScreen> createState() => _ContextScreenState();
}

class _ContextScreenState extends State<ContextScreen> {
  final _occupationController = TextEditingController();
  int _selectedBudget = 500;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userProvider = context.read<UserProvider>();
    if (userProvider.user != null) {
      final user = userProvider.user!;
      _occupationController.text = user.occupation;
      _selectedBudget = user.typicalBudget;
      _isEditing = false;
    } else {
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _occupationController.dispose();
    super.dispose();
  }

  void _saveContext() {
    if (_occupationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your occupation'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    context.read<UserProvider>().saveUser(
      occupation: _occupationController.text.trim(),
      typicalBudget: _selectedBudget,
    );

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Context saved successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        final hasUser = user != null;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    AppConstants.contextTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    AppConstants.contextSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // User Profile Card (if exists and not editing)
                  if (hasUser && !_isEditing) ...[
                    _buildProfileCard(user),
                    const SizedBox(height: AppTheme.spacingLg),
                  ],

                  // Edit Form
                  if (!hasUser || _isEditing) ...[
                    _buildEditForm(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(user) {
    return BentoCard(
      child: Column(
        children: [
          // Tier Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: AppTheme.accent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  user.consumptionTier,
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Occupation
          _buildInfoRow(
            icon: Icons.work_outline,
            label: 'Occupation',
            value: user.occupation,
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Budget
          _buildInfoRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Typical Budget',
            value: 'HKD ${user.typicalBudget}',
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Edit Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit Context'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(
            icon,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Occupation Field
        Text(
          AppConstants.occupationLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        TextField(
          controller: _occupationController,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: AppConstants.occupationHint,
            hintStyle: const TextStyle(color: AppTheme.textTertiary),
            prefixIcon: const Icon(Icons.work_outline, color: AppTheme.textSecondary),
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Budget Selection
        Text(
          AppConstants.budgetLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Wrap(
          spacing: AppTheme.spacingSm,
          runSpacing: AppTheme.spacingSm,
          children: AppConstants.budgetOptions.map((budget) {
            final isSelected = _selectedBudget == budget;
            return ChoiceChip(
              label: Text('HKD $budget'),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedBudget = budget),
              backgroundColor: AppTheme.surfaceLight,
              selectedColor: AppTheme.accent.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.accent : AppTheme.border,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppTheme.spacingXl),

        // Save Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: context.watch<UserProvider>().isLoading ? null : _saveContext,
            child: context.watch<UserProvider>().isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textPrimary),
                    ),
                  )
                : const Text(AppConstants.saveContextButton),
          ),
        ),

        // Cancel Button (if editing existing)
        if (context.read<UserProvider>().hasUser) ...[
          const SizedBox(height: AppTheme.spacingMd),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() => _isEditing = false),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ],
    );
  }
}
