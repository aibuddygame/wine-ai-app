import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../data/models/wine_model.dart';
import '../data/models/search_history_model.dart';
import '../data/repositories/database_helper.dart';
import '../data/services/kimi_service.dart';

/// Wine Analysis Provider
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
  DynamicPairing? get currentPairing => 
      _currentWine?.pairings[_selectedCuisine];

  WineProvider({required String apiKey}) : _kimiService = KimiService(apiKey: apiKey);

  /// Set selected cuisine
  void setCuisine(String cuisine) {
    _selectedCuisine = cuisine;
    notifyListeners();
  }

  /// Analyze wine image
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
      // First check cache
      // Note: In a real implementation, we'd generate a fingerprint from the image
      // For now, we'll always call the API
      
      final wine = await _kimiService.analyzeWineImage(
        imageBytes,
        occupation: occupation,
        budget: budget,
        cuisine: cuisine,
      );

      // Save to database
      final wineId = await _db.insertWine(wine);
      
      // Create search history
      final faceEarned = SearchHistory.calculateFaceEarned(wine);
      final history = SearchHistory(
        wineId: wineId.toString(),
        wineFingerprint: wine.fingerprint,
        wineName: wine.identity.fullName,
        cuisineContext: cuisine,
        budgetContext: budget,
        scannedAt: DateTime.now(),
        faceEarned: faceEarned,
      );
      
      await _db.insertSearchHistory(history);

      _currentWine = wine;
      await _loadWineHistory();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  /// Check cache for wine
  Future<Wine?> checkCache(String fingerprint) async {
    return await _db.getWineByFingerprint(fingerprint);
  }

  /// Load wine history
  Future<void> _loadWineHistory() async {
    _wineHistory = await _db.getAllWines();
    notifyListeners();
  }

  /// Clear current wine
  void clearCurrentWine() {
    _currentWine = null;
    notifyListeners();
  }

  /// Set current wine from history
  void setCurrentWine(Wine wine) {
    _currentWine = wine;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
