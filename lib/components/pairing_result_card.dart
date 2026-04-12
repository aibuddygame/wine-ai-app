import 'package:flutter/material.dart';
import '../models/pairing_models.dart';

/// Card for displaying wine pairing result
class PairingResultCard extends StatelessWidget {
  final PairingResult result;
  final bool isFallback;
  final VoidCallback onTryAnother;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const PairingResultCard({
    Key? key,
    required this.result,
    this.isFallback = false,
    required this.onTryAnother,
    required this.onSave,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with fit badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    isFallback ? 'General pairing' : 'Pairing advice',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildFitBadge(context, result.fit),
              ],
            ),
            const SizedBox(height: 20),
            
            // Best with
            _buildInfoRow(
              context,
              icon: Icons.restaurant,
              label: 'Best with',
              value: result.bestWith.join(', '),
            ),
            const SizedBox(height: 16),
            
            // Why
            _buildInfoRow(
              context,
              icon: Icons.lightbulb_outline,
              label: 'Why',
              value: result.why,
            ),
            const SizedBox(height: 16),
            
            // Say this
            _buildInfoRow(
              context,
              icon: Icons.chat_bubble_outline,
              label: 'Say this',
              value: '"${result.sayThis}"',
              isQuote: true,
            ),
            
            // Less suitable for (if not empty)
            if (result.lessSuitableFor.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                icon: Icons.block,
                label: 'Less suitable for',
                value: result.lessSuitableFor.join(', '),
                valueColor: Colors.orange[700],
              ),
            ],
            
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            
            // Footer actions
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onTryAnother,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Try another dish'),
                  ),
                ),
                IconButton(
                  onPressed: onSave,
                  icon: const Icon(Icons.bookmark_border),
                  tooltip: 'Save',
                ),
                IconButton(
                  onPressed: onShare,
                  icon: const Icon(Icons.share),
                  tooltip: 'Share',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build fit badge
  Widget _buildFitBadge(BuildContext context, String fit) {
    Color backgroundColor;
    Color textColor;
    
    switch (fit.toLowerCase()) {
      case 'great':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'good':
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        break;
      case 'okay':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      case 'not ideal':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Fit: $fit',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isQuote = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? (isQuote ? Colors.grey[800] : Colors.black87),
                  fontStyle: isQuote ? FontStyle.italic : FontStyle.normal,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Fallback pairing result card (when user skips)
class FallbackPairingCard extends StatelessWidget {
  final VoidCallback onAddMeal;

  const FallbackPairingCard({
    Key? key,
    required this.onAddMeal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General pairing',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            // Best with
            _buildInfoRow(
              context,
              icon: Icons.restaurant,
              label: 'Best with',
              value: 'Seafood, poultry, creamy dishes',
            ),
            const SizedBox(height: 12),
            
            // Less suitable for
            _buildInfoRow(
              context,
              icon: Icons.block,
              label: 'Less suitable for',
              value: 'Spicy hotpot, sweet desserts',
              valueColor: Colors.orange[700],
            ),
            const SizedBox(height: 12),
            
            // Talking point
            _buildInfoRow(
              context,
              icon: Icons.chat_bubble_outline,
              label: 'Talking point',
              value: '"This is a safer choice for lighter dishes rather than heavily spiced food."',
              isQuote: true,
            ),
            
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAddMeal,
                icon: const Icon(Icons.add),
                label: const Text('Add tonight\'s meal for better advice'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isQuote = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? (isQuote ? Colors.grey[800] : Colors.black87),
                  fontStyle: isQuote ? FontStyle.italic : FontStyle.normal,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
