import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/user_provider.dart';
import '../../providers/language_provider.dart';
import '../../ui/components/vivino_components.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  void _loadUserData() {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;
    if (user != null) {
      _occupationController.text = user.occupation;
      _selectedBudget = user.typicalBudget;
      setState(() => _isEditing = false);
    } else {
      setState(() => _isEditing = true);
    }
  }

  @override
  void dispose() {
    _occupationController.dispose();
    super.dispose();
  }

  void _saveContext() {
    final l10n = AppLocalizations.of(context)!;
    final occupation = _occupationController.text.trim();
    if (occupation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.occupationHint),
          backgroundColor: VivinoColors.primary,
        ),
      );
      return;
    }

    context.read<UserProvider>().saveUser(
          occupation: occupation,
          typicalBudget: _selectedBudget,
        );

    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.saved),
        backgroundColor: VivinoColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;
        final hasUser = user != null;

        return Scaffold(
          backgroundColor: VivinoColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language Switcher
                  _buildLanguageSwitcher(context),
                  const SizedBox(height: 24),
                  Text(
                    l10n.contextTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: VivinoColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.contextSubtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: VivinoColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (hasUser && !_isEditing) _buildProfileCard(user, l10n),
                  if (!hasUser || _isEditing) _buildEditForm(hasUser, l10n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = context.watch<LanguageProvider>();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: VivinoColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.language,
            color: VivinoColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.language,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: VivinoColors.textPrimary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => languageProvider.toggleLanguage(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: VivinoColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: VivinoColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    languageProvider.isEnglish ? l10n.english : l10n.traditionalChinese,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: VivinoColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.swap_horiz,
                    size: 16,
                    color: VivinoColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(user, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VivinoColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Tier Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: VivinoColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium,
                    color: VivinoColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  user.consumptionTier,
                  style: const TextStyle(
                    color: VivinoColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoRow(
            icon: Icons.work_outline,
            label: l10n.occupationLabel,
            value: user.occupation,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.account_balance_wallet_outlined,
            label: l10n.budgetLabel,
            value: 'HKD ${user.typicalBudget}',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit, size: 18),
              label: Text(l10n.editContext),
              style: OutlinedButton.styleFrom(
                foregroundColor: VivinoColors.primary,
                side: const BorderSide(color: VivinoColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: VivinoColors.textSecondary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: VivinoColors.textTertiary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: VivinoColors.textPrimary,
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

  Widget _buildEditForm(bool hasUser, AppLocalizations l10n) {
    final isLoading = context.watch<UserProvider>().isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.occupationLabel,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: VivinoColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _occupationController,
          decoration: InputDecoration(
            hintText: l10n.occupationHint,
            hintStyle: const TextStyle(color: VivinoColors.textTertiary),
            prefixIcon: const Icon(Icons.work_outline, color: VivinoColors.textSecondary),
            filled: true,
            fillColor: VivinoColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.budgetLabel,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: VivinoColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppConstants.budgetOptions.map((budget) {
            final isSelected = _selectedBudget == budget;
            return ChoiceChip(
              label: Text('HKD $budget'),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedBudget = budget),
              backgroundColor: VivinoColors.surface,
              selectedColor: VivinoColors.primary.withOpacity(0.1),
              labelStyle: TextStyle(
                color: isSelected ? VivinoColors.primary : VivinoColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? VivinoColors.primary : VivinoColors.border,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _saveContext,
            style: ElevatedButton.styleFrom(
              backgroundColor: VivinoColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    l10n.saveContextButton,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
        if (hasUser) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() => _isEditing = false),
              style: OutlinedButton.styleFrom(
                foregroundColor: VivinoColors.textSecondary,
                side: const BorderSide(color: VivinoColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(l10n.cancel),
            ),
          ),
        ],
      ],
    );
  }
}
