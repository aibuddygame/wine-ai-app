import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/wine_provider.dart';
import '../../providers/user_provider.dart';
import '../../ui/components/bento_components.dart';
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
          backgroundColor: AppTheme.error,
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
      backgroundColor: AppTheme.background,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DataBubblesAnimation(),
          const SizedBox(height: AppTheme.spacingXl),
          Text(
            AppConstants.analyzingLabel,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          const Text(
            'Our AI Sommelier is analyzing your wine...',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerUI(WineProvider wineProvider) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppConstants.scannerTitle,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            AppConstants.scannerSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXxl),

          // Scanner Visual Frame
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              border: Border.all(color: AppTheme.border, width: 2),
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
                      color: AppTheme.accent.withAlpha(128),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    const Text(
                      'Position wine label\nwithin frame',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: AppTheme.textTertiary, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXxl),

          // API key warning
          if (!wineProvider.hasApiKey) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              margin: const EdgeInsets.only(bottom: AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: AppTheme.warning.withAlpha(26),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.warning.withAlpha(77)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: AppTheme.warning, size: 20),
                  SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      'API key not configured. Set KIMI_API_KEY to enable scanning.',
                      style: TextStyle(color: AppTheme.warning, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Capture Button
          SizedBox(
            width: 200,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _captureImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capture'),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Gallery Button
          TextButton.icon(
            onPressed: _pickFromGallery,
            icon: const Icon(Icons.photo_library, size: 18),
            label: const Text('Choose from Gallery'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
            ),
          ),

          // Error display
          if (wineProvider.error != null) ...[
            const SizedBox(height: AppTheme.spacingLg),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(26),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.error.withAlpha(77)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppTheme.error),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      wineProvider.error!,
                      style: const TextStyle(
                          color: AppTheme.error, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        size: 16, color: AppTheme.error),
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
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.accent, width: 3),
                left: BorderSide(color: AppTheme.accent, width: 3),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
