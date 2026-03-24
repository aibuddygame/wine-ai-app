import 'package:flutter/foundation.dart';
import '../data/models/search_history_model.dart';
import '../data/repositories/database_helper.dart';

class VaultProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  VaultStats _stats = VaultStats.empty();
  bool _isLoading = false;
  String? _error;

  VaultStats get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalScans => _stats.totalScans;
  double get totalFaceEarned => _stats.totalFaceEarned;
  double get totalScannedValue => _stats.totalScannedValue;
  String get mostScannedCuisine => _stats.mostScannedCuisine;
  String get topConsumptionTier => _stats.topConsumptionTier;
  List<SearchHistory> get recentScans => _stats.recentScans;

  VaultProvider() {
    loadStats();
  }

  Future<void> loadStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stats = await _db.getVaultStats();
      _error = null;
    } catch (e) {
      _error = 'Failed to load vault data';
      debugPrint('VaultProvider.loadStats error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadStats();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
