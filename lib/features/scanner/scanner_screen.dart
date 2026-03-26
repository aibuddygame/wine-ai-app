import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/wine_provider.dart';
import '../../providers/user_provider.dart';
import '../../ui/components/vivino_components.dart';
import '../results/results_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: AppConstants.maxImageWidth,
        maxHeight: AppConstants.maxImageHeight,
        imageQuality: AppConstants.imageQuality,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        _analyzeImage(bytes);
      }
    } catch (_) {
      // Camera not available (common on web), fall back to gallery
      _pickFromGallery();
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: AppConstants.maxImageWidth,
        maxHeight: AppConstants.maxImageHeight,
        imageQuality: AppConstants.imageQuality,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        _analyzeImage(bytes);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: VivinoColors.primary,
        ),
      );
    }
  }

  Future<void> _analyzeImage(Uint8List imageBytes) async {
    final userProvider = context.read<UserProvider>();
    final wineProvider = context.read<WineProvider>();

    await wineProvider.analyzeWine(
      imageBytes,
      occupation: userProvider.user?.occupation,
      budget: userProvider.user?.typicalBudget,
    );

    if (!mounted) return;

    if (wineProvider.error == null && wineProvider.currentWine != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ResultsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VivinoColors.background,
      body: SafeArea(
        child: Consumer<WineProvider>(
          builder: (context, wineProvider, _) {
            if (wineProvider.isAnalyzing) return _buildAnalyzingState();
            return _buildScannerUI(wineProvider);
          },
        ),
      ),
    );
  }

  Widget _buildAnalyzingState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(VivinoColors.primary),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.analyzingLabel,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: VivinoColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.analyzingSubtitle,
            style: const TextStyle(
              color: VivinoColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerUI(WineProvider wineProvider) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(
            l10n.scannerTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: VivinoColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.scannerSubtitle,
            style: const TextStyle(
              fontSize: 14,
              color: VivinoColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Scanner Visual Frame
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: VivinoColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: VivinoColors.border, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Corner markers
                ..._buildCornerMarkers(),
                // Center content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.document_scanner_outlined,
                      size: 64,
                      color: VivinoColors.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.positionLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: VivinoColors.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // API key warning
          if (!wineProvider.hasApiKey) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: VivinoColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: VivinoColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: VivinoColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.apiKeyWarning,
                      style: const TextStyle(color: VivinoColors.primary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Capture Button
          SizedBox(
            width: 220,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _captureImage,
              icon: const Icon(Icons.camera_alt, size: 24),
              label: Text(
                l10n.captureButton,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: VivinoColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Gallery Button
          TextButton.icon(
            onPressed: _pickFromGallery,
            icon: const Icon(Icons.photo_library, size: 20),
            label: Text(
              l10n.galleryButton,
              style: const TextStyle(fontSize: 14),
            ),
            style: TextButton.styleFrom(
              foregroundColor: VivinoColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),

          // Error display
          if (wineProvider.error != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: VivinoColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: VivinoColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: VivinoColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      wineProvider.error!,
                      style: const TextStyle(
                        color: VivinoColors.primary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: VivinoColors.primary),
                    onPressed: () => wineProvider.clearError(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildCornerMarkers() {
    const positions = [
      {'top': 20.0, 'left': 20.0, 'angle': 0.0},
      {'top': 20.0, 'right': 20.0, 'angle': 90.0},
      {'bottom': 20.0, 'right': 20.0, 'angle': 180.0},
      {'bottom': 20.0, 'left': 20.0, 'angle': 270.0},
    ];

    return positions.map((pos) {
      return Positioned(
        top: pos['top'],
        left: pos['left'],
        right: pos['right'],
        bottom: pos['bottom'],
        child: Transform.rotate(
          angle: (pos['angle']!) * 3.14159265 / 180,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: VivinoColors.primary, width: 3),
                left: BorderSide(color: VivinoColors.primary, width: 3),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
