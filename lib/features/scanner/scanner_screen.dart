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

/// Scanner Tab - Camera/Image capture screen
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        _analyzeImage(bytes);
      }
    } catch (e) {
      // Fallback to gallery on web or if camera fails
      _pickFromGallery();
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        _analyzeImage(bytes);
      }
    } catch (e) {
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

    final occupation = userProvider.user?.occupation;
    final budget = userProvider.user?.typicalBudget;

    await wineProvider.analyzeWine(
      imageBytes,
      occupation: occupation,
      budget: budget,
    );

    if (wineProvider.error == null && wineProvider.currentWine != null) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ResultsScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Consumer<WineProvider>(
          builder: (context, wineProvider, child) {
            if (wineProvider.isAnalyzing) {
              return _buildAnalyzingState();
            }

            return _buildScannerUI();
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

  Widget _buildScannerUI() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header
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

          // Scanner Visual
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
                Positioned(
                  top: 20,
                  left: 20,
                  child: _buildCornerMarker(),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: _buildCornerMarker(rotate: 90),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: _buildCornerMarker(rotate: 270),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: _buildCornerMarker(rotate: 180),
                ),

                // Center icon
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.document_scanner_outlined,
                      size: 64,
                      color: AppTheme.accent.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    const Text(
                      'Position wine label\nwithin frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXxl),

          // Capture Button
          SizedBox(
            width: 200,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _captureImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capture'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
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
          if (context.watch<WineProvider>().error != null) ...[
            const SizedBox(height: AppTheme.spacingLg),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppTheme.error),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      context.watch<WineProvider>().error!,
                      style: const TextStyle(color: AppTheme.error, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16, color: AppTheme.error),
                    onPressed: () => context.read<WineProvider>().clearError(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCornerMarker({int rotate = 0}) {
    return Transform.rotate(
      angle: rotate * 3.14159 / 180,
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
    );
  }
}
