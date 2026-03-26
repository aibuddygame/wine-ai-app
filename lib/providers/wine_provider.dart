import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../data/models/wine_model.dart';
import '../data/models/search_history_model.dart';
import '../data/repositories/database_helper.dart';
import '../data/services/kimi_service.dart';

class WineProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  final KimiService _kimiService;

  Wine? _currentWine;
  List<Wine> _wineHistory = [];
  bool _isAnalyzing = false;
  String? _error;
  String _selectedCuisine = 'Western';

  Wine? get currentWine => _currentWine;
  List<Wine> get wineHistory => _wineHistory;
  bool get isAnalyzing => _isAnalyzing;
  String? get error => _error;
  String get selectedCuisine => _selectedCuisine;
  bool get hasApiKey => _kimiService.hasApiKey;

  DynamicPairing? get currentPairing =>
      _currentWine?.pairings[_selectedCuisine];

  WineProvider({required String apiKey})
      : _kimiService = KimiService(apiKey: apiKey);

  void setCuisine(String cuisine) {
    _selectedCuisine = cuisine;
    notifyListeners();
  }

  Future<void> analyzeWine(
    Uint8List imageBytes, {
    String? occupation,
    int? budget,
    String? cuisine,
  }) async {
    _isAnalyzing = true;
    _error = null;
    notifyListeners();

    try {
      final wine = await _kimiService.analyzeWineImage(
        imageBytes,
        occupation: occupation,
        budget: budget,
        cuisine: cuisine,
      );

      // Save to database (skip on web if database fails)
      try {
        final wineId = await _db.insertWine(wine);

        // Create search history entry
        final faceEarned = SearchHistory.calculateFaceEarned(wine);
        final history = SearchHistory(
          wineId: wineId.toString(),
          wineFingerprint: wine.fingerprint,
          wineName: wine.identity.fullName,
          cuisineContext: cuisine ?? _selectedCuisine,
          budgetContext: budget,
          scannedAt: DateTime.now(),
          faceEarned: faceEarned,
        );
        await _db.insertSearchHistory(history);
        await _loadWineHistory();
      } catch (dbError) {
        debugPrint('Database save skipped (web): $dbError');
        // On web, just show results without saving to vault
      }

      _currentWine = wine;
    } on KimiServiceException catch (e) {
      _error = 'API Error: ${e.message}';
      debugPrint('WineProvider.analyzeWine KimiError: ${e.message} (status: ${e.statusCode})');
    } catch (e, stackTrace) {
      _error = 'Error: ${e.toString().substring(0, e.toString().length > 100 ? 100 : e.toString().length)}';
      debugPrint('WineProvider.analyzeWine error: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<Wine?> checkCache(String fingerprint) async {
    try {
      return await _db.getWineByFingerprint(fingerprint);
    } catch (e) {
      debugPrint('WineProvider.checkCache error: $e');
      return null;
    }
  }

  Future<void> _loadWineHistory() async {
    try {
      _wineHistory = await _db.getAllWines();
    } catch (e) {
      debugPrint('WineProvider._loadWineHistory error: $e');
    }
    notifyListeners();
  }

  void setCurrentWine(Wine wine) {
    _currentWine = wine;
    notifyListeners();
  }

  void clearCurrentWine() {
    _currentWine = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
