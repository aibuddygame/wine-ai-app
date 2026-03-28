import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/wine_model.dart';
import '../models/user_model.dart';
import '../models/search_history_model.dart';

/// Hive Database Helper - Replaces SQLite for cross-platform compatibility
class HiveDatabaseHelper {
  static final HiveDatabaseHelper _instance = HiveDatabaseHelper._internal();
  factory HiveDatabaseHelper() => _instance;
  HiveDatabaseHelper._internal();

  bool _initialized = false;
  Box<Map>? _winesBox;
  Box<Map>? _usersBox;
  Box<Map>? _historyBox;

  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    _winesBox = await Hive.openBox<Map>('wines');
    _usersBox = await Hive.openBox<Map>('users');
    _historyBox = await Hive.openBox<Map>('search_history');

    _initialized = true;
    debugPrint('HiveDatabaseHelper: initialized');
  }

  // ==================== WINE OPERATIONS ====================

  Future<int> insertWine(Wine wine) async {
    await init();
    final key = wine.fingerprint;
    final value = {
      'fingerprint': wine.fingerprint,
      'metadata': jsonEncode(wine.toJson()),
      'created_at': DateTime.now().toIso8601String(),
    };

    await _winesBox!.put(key, value);
    debugPrint('Hive: Wine saved with key: $key');
    return 1; // Hive doesn't use numeric IDs like SQLite
  }

  Future<Wine?> getWineByFingerprint(String fingerprint) async {
    await init();
    final value = _winesBox!.get(fingerprint);
    if (value == null) return null;

    final metadata = jsonDecode(value['metadata'] as String) as Map<String, dynamic>;
    return Wine.fromJson({
      ...metadata,
      'fingerprint': value['fingerprint'],
      'created_at': value['created_at'],
    });
  }

  Future<List<Wine>> getAllWines() async {
    await init();
    final wines = <Wine>[];

    for (final entry in _winesBox!.values) {
      try {
        final metadata = jsonDecode(entry['metadata'] as String) as Map<String, dynamic>;
        wines.add(Wine.fromJson({
          ...metadata,
          'fingerprint': entry['fingerprint'],
          'created_at': entry['created_at'],
        }));
      } catch (e) {
        debugPrint('Hive: Error parsing wine: $e');
      }
    }

    // Sort by created_at descending
    wines.sort((a, b) {
      final aDate = a.createdAt ?? DateTime(2000);
      final bDate = b.createdAt ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });

    return wines;
  }

  Future<void> deleteWine(String fingerprint) async {
    await init();
    await _winesBox!.delete(fingerprint);
  }

  // ==================== USER OPERATIONS ====================

  Future<int> saveUser(User user) async {
    await init();
    final value = {
      'id': 1,
      'occupation': user.occupation,
      'typical_budget': user.typicalBudget,
      'consumption_tier': user.consumptionTier,
      'created_at': user.createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _usersBox!.put('current_user', value);
    return 1;
  }

  Future<User?> getUser() async {
    await init();
    final value = _usersBox!.get('current_user');
    if (value == null) return null;

    return User.fromJson({
      'id': value['id'],
      'occupation': value['occupation'],
      'typical_budget': value['typical_budget'],
      'consumption_tier': value['consumption_tier'],
      'created_at': value['created_at'],
      'updated_at': value['updated_at'],
    });
  }

  // ==================== SEARCH HISTORY OPERATIONS ====================

  Future<int> insertSearchHistory(SearchHistory history) async {
    await init();
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final value = {
      'id': key,
      'user_id': history.userId,
      'wine_id': history.wineId,
      'wine_fingerprint': history.wineFingerprint,
      'wine_name': history.wineName,
      'cuisine_context': history.cuisineContext,
      'budget_context': history.budgetContext,
      'scanned_at': history.scannedAt.toIso8601String(),
      'face_earned': history.faceEarned,
    };

    await _historyBox!.put(key, value);
    debugPrint('Hive: Search history saved with key: $key');
    return 1;
  }

  Future<List<SearchHistory>> getSearchHistory({int limit = 50}) async {
    await init();
    final history = <SearchHistory>[];

    // Get all entries sorted by key (timestamp) descending
    final sortedKeys = _historyBox!.keys.toList()
      ..sort((a, b) => (b as String).compareTo(a as String));

    for (var i = 0; i < sortedKeys.length && i < limit; i++) {
      final entry = _historyBox!.get(sortedKeys[i]);
      if (entry != null) {
        try {
          history.add(SearchHistory.fromJson({
            'id': entry['id'],
            'user_id': entry['user_id'],
            'wine_id': entry['wine_id'],
            'wine_fingerprint': entry['wine_fingerprint'],
            'wine_name': entry['wine_name'],
            'cuisine_context': entry['cuisine_context'],
            'budget_context': entry['budget_context'],
            'scanned_at': entry['scanned_at'],
            'face_earned': entry['face_earned'],
          }));
        } catch (e) {
          debugPrint('Hive: Error parsing history: $e');
        }
      }
    }

    return history;
  }

  Future<VaultStats> getVaultStats() async {
    await init();

    final history = await getSearchHistory(limit: 10000);
    final totalScans = history.length;

    if (totalScans == 0) {
      return VaultStats.empty();
    }

    double totalFace = 0;
    double totalValue = 0;
    String topCuisine = '-';
    String topTier = 'Explorer';

    // Calculate stats
    final cuisineCounts = <String, int>{};
    for (final entry in history) {
      if (entry.faceEarned != null) {
        totalFace += entry.faceEarned!;
      }
      if (entry.cuisineContext != null) {
        cuisineCounts[entry.cuisineContext!] = (cuisineCounts[entry.cuisineContext!] ?? 0) + 1;
      }
    }

    // Find most scanned cuisine
    if (cuisineCounts.isNotEmpty) {
      topCuisine = cuisineCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    // Determine tier based on total face earned
    if (totalFace >= 1000) {
      topTier = 'Connoisseur';
    } else if (totalFace >= 500) {
      topTier = 'Enthusiast';
    } else if (totalFace >= 100) {
      topTier = 'Explorer';
    } else {
      topTier = 'Novice';
    }

    return VaultStats(
      totalFaceEarned: totalFace,
      totalScannedValue: totalValue,
      totalScans: totalScans,
      topConsumptionTier: topTier,
      mostScannedCuisine: topCuisine,
      recentScans: history.take(20).toList(),
    );
  }

  Future<void> clearAll() async {
    await init();
    await _winesBox!.clear();
    await _usersBox!.clear();
    await _historyBox!.clear();
  }

  // ==================== DEBUG / STATS ====================

  Future<Map<String, dynamic>> getStats() async {
    await init();
    
    return {
      'cachedWines': _winesBox?.length ?? 0,
      'historyCount': _historyBox?.length ?? 0,
      'hasUser': _usersBox?.containsKey('current_user') ?? false,
      'winesKeys': _winesBox?.keys.toList() ?? [],
      'historyKeys': _historyBox?.keys.toList() ?? [],
    };
  }
}
