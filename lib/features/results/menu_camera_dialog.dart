import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_constants.dart';
import '../../ui/components/vivino_components.dart';

/// Dialog for capturing menu photos
class MenuCameraDialog extends StatefulWidget {
  const MenuCameraDialog({super.key});

  @override
  State<MenuCameraDialog> createState() => _MenuCameraDialogState();

  /// Show the dialog and return the captured image bytes
  static Future<Uint8List?> show(BuildContext context) async {
    return showDialog<Uint8List?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const MenuCameraDialog(),
    );
  }
}

class _MenuCameraDialogState extends State<MenuCameraDialog> {
  final ImagePicker _picker = ImagePicker();
  bool _isCapturing = false;

  Future<void> _captureFromCamera() async {
    setState(() => _isCapturing = true);
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: AppConstants.maxImageWidth,
        maxHeight: AppConstants.maxImageHeight,
        imageQuality: AppConstants.imageQuality,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        if (mounted) Navigator.of(context).pop(bytes);
      }
    } catch (_) {
      // Camera not available, fall back to gallery
      await _pickFromGallery();
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isCapturing = true);
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: AppConstants.maxImageWidth,
        maxHeight: AppConstants.maxImageHeight,
        imageQuality: AppConstants.imageQuality,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        if (mounted) Navigator.of(context).pop(bytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: VivinoColors.primary,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: VivinoColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 32,
                color: VivinoColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Today's Menu",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: VivinoColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a photo of the menu to find the best dishes to pair with this wine',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: VivinoColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Camera button
            if (_isCapturing)
              const CircularProgressIndicator(color: VivinoColors.primary)
            else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _captureFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VivinoColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose from Gallery'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: VivinoColors.textPrimary,
                    side: const BorderSide(color: VivinoColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Cancel
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: VivinoColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
