import 'package:flutter/material.dart';
import '../models/pairing_models.dart';

/// States for the pairing card
enum PairingCardState {
  idle,
  quickPickSelected,
  typingDish,
  scanningMenu,
  loading,
  success,
  fallback,
  error,
}

/// Card for selecting meal pairing input method
class PairingCard extends StatelessWidget {
  final PairingCardState state;
  final Function(String) onQuickPickSelected;
  final VoidCallback onTypeDish;
  final VoidCallback onScanMenu;
  final VoidCallback onSkip;
  final Function(String) onDishSubmitted;
  final VoidCallback onCancel;
  final String? errorMessage;
  final String locale;

  const PairingCard({
    Key? key,
    required this.state,
    required this.onQuickPickSelected,
    required this.onTypeDish,
    required this.onScanMenu,
    required this.onSkip,
    required this.onDishSubmitted,
    required this.onCancel,
    this.errorMessage,
    this.locale = 'zh',
  }) : super(key: key);

  bool get _isZh => locale.startsWith('zh');

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case PairingCardState.typingDish:
        return _buildDishInputCard(context);
      case PairingCardState.loading:
        return _buildLoadingCard();
      case PairingCardState.error:
        return _buildErrorCard();
      case PairingCardState.idle:
      case PairingCardState.quickPickSelected:
      case PairingCardState.scanningMenu:
      case PairingCardState.success:
      case PairingCardState.fallback:
      default:
        return _buildMainCard(context);
    }
  }

  /// Main pairing card with quick picks
  Widget _buildMainCard(BuildContext context) {
    final options = getQuickPickOptions(locale);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              _isZh ? '為今晚的餐點配對這瓶酒' : 'Match this bottle with tonight\'s meal',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Text(
              _isZh 
                ? '快速獲得配對建議 — 點擊餐點類型、輸入菜名或掃描菜單' 
                : 'Get pairing advice fast — tap a meal type, type a dish, or scan the menu.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 20),
            
            // Quick pick buttons - Row 1
            Row(
              children: [
                Expanded(child: _buildQuickPickButton(context, options[0])),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickPickButton(context, options[1])),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickPickButton(context, options[2])),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickPickButton(context, options[3])),
              ],
            ),
            const SizedBox(height: 8),
            
            // Quick pick buttons - Row 2
            Row(
              children: [
                Expanded(child: _buildQuickPickButton(context, options[4])),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickPickButton(context, options[5])),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickPickButton(context, options[6])),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickPickButton(context, options[7])),
              ],
            ),
            const SizedBox(height: 20),
            
            // Secondary actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTypeDish,
                    icon: const Icon(Icons.edit, size: 18),
                    label: Text(_isZh ? '輸入菜名' : 'Type dish'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onScanMenu,
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: Text(_isZh ? '掃描菜單' : 'Scan menu'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Skip button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onSkip,
                child: Text(_isZh ? '暫時跳過' : 'Skip for now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Quick pick button
  Widget _buildQuickPickButton(BuildContext context, QuickPickOption option) {
    return ElevatedButton(
      onPressed: () => onQuickPickSelected(option.id),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black87,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Text(
        option.label,
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Dish input card
  Widget _buildDishInputCard(BuildContext context) {
    final controller = TextEditingController();
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onCancel,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    _isZh ? '輸入你的菜名' : 'Type your dish',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: _isZh 
                  ? '例如：清蒸石斑、和牛牛排、龍蝦意粉' 
                  : 'e.g., steamed garoupa, wagyu steak, lobster pasta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.restaurant),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    onDishSubmitted(controller.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_isZh ? '獲得配對建議' : 'Get pairing advice'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Loading card
  Widget _buildLoadingCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(_isZh ? '正在獲得配對建議...' : 'Getting pairing advice...'),
            ],
          ),
        ),
      ),
    );
  }

  /// Error card
  Widget _buildErrorCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? (_isZh ? '暫時無法生成配對建議，請嘗試其他餐點類型' : 'Couldn\'t generate pairing advice right now. Please try another meal type.'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCancel,
              child: Text(_isZh ? '重試' : 'Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
