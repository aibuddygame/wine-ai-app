import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/wine_model.dart';
import '../models/user_model.dart';
import '../models/search_history_model.dart';
import '../../core/constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path;
    if (kIsWeb) {
      path = AppConstants.dbName;
    } else {
      final dbPath = await getDatabasesPath();
      path = p.join(dbPath, AppConstants.dbName);
    }

    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE wines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fingerprint TEXT UNIQUE NOT NULL,
        metadata TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        occupation TEXT NOT NULL,
        typical_budget INTEGER NOT NULL,
        consumption_tier TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        wine_id INTEGER,
        wine_fingerprint TEXT NOT NULL,
        wine_name TEXT,
        cuisine_context TEXT,
        budget_context INTEGER,
        scanned_at TEXT DEFAULT CURRENT_TIMESTAMP,
        face_earned REAL,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (wine_id) REFERENCES wines(id)
      )
    ''');

    await db.execute(
        'CREATE INDEX idx_wines_fingerprint ON wines(fingerprint)');
    await db.execute(
        'CREATE INDEX idx_history_user ON search_history(user_id)');
    await db.execute(
        'CREATE INDEX idx_history_scanned ON search_history(scanned_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future migrations go here
  }

  // ==================== WINE OPERATIONS ====================

  Future<int> insertWine(Wine wine) async {
    final db = await database;
    final metadata = jsonEncode(wine.toJson());

    try {
      // Use rawInsert for better web compatibility
      final now = DateTime.now().toIso8601String();
      await db.execute(
        'INSERT OR REPLACE INTO wines (fingerprint, metadata, created_at) VALUES (?, ?, ?)',
        [wine.fingerprint, metadata, now],
      );
      
      // Get the ID of the inserted/updated row
      final results = await db.query(
        'wines',
        where: 'fingerprint = ?',
        whereArgs: [wine.fingerprint],
        limit: 1,
      );
      
      if (results.isNotEmpty && results.first['id'] != null) {
        return results.first['id'] as int;
      }
      
      // Fallback for web
      return 1;
    } catch (e) {
      debugPrint('DatabaseHelper.insertWine error: $e');
      // For web, return a fallback ID
      return 1;
    }
  }

  Future<Wine?> getWineByFingerprint(String fingerprint) async {
    final db = await database;
    final results = await db.query(
      'wines',
      where: 'fingerprint = ?',
      whereArgs: [fingerprint],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final row = results.first;
    final metadata =
        jsonDecode(row['metadata'] as String) as Map<String, dynamic>;
    return Wine.fromJson({
      ...metadata,
      'id': row['id'],
      'fingerprint': row['fingerprint'],
      'created_at': row['created_at'],
    });
  }

  Future<List<Wine>> getAllWines() async {
    final db = await database;
    final results = await db.query('wines', orderBy: 'created_at DESC');

    return results.map((row) {
      final metadata =
          jsonDecode(row['metadata'] as String) as Map<String, dynamic>;
      return Wine.fromJson({
        ...metadata,
        'id': row['id'],
        'fingerprint': row['fingerprint'],
        'created_at': row['created_at'],
      });
    }).toList();
  }

  // ==================== USER OPERATIONS ====================

  Future<int> saveUser(User user) async {
    final db = await database;
    final existing = await db.query('users', limit: 1);
    final now = DateTime.now().toIso8601String();

    if (existing.isNotEmpty) {
      return db.update(
        'users',
        {
          'occupation': user.occupation,
          'typical_budget': user.typicalBudget,
          'consumption_tier': user.consumptionTier,
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    }

    return db.insert('users', {
      'occupation': user.occupation,
      'typical_budget': user.typicalBudget,
      'consumption_tier': user.consumptionTier,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<User?> getUser() async {
    final db = await database;
    final results = await db.query('users', limit: 1);
    if (results.isEmpty) return null;

    final row = results.first;
    return User.fromJson({
      'id': row['id'],
      'occupation': row['occupation'],
      'typical_budget': row['typical_budget'],
      'consumption_tier': row['consumption_tier'],
      'created_at': row['created_at'],
      'updated_at': row['updated_at'],
    });
  }

  // ==================== SEARCH HISTORY OPERATIONS ====================

  Future<int> insertSearchHistory(SearchHistory history) async {
    final db = await database;
    try {
      // Use rawInsert for better web compatibility
      final id = await db.rawInsert(
        'INSERT INTO search_history (user_id, wine_id, wine_fingerprint, wine_name, cuisine_context, budget_context, scanned_at, face_earned) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          history.userId,
          history.wineId,
          history.wineFingerprint,
          history.wineName,
          history.cuisineContext,
          history.budgetContext,
          history.scannedAt.toIso8601String(),
          history.faceEarned,
        ],
      );
      
      // Handle web where insert might return null
      return id ?? 1;
    } catch (e) {
      debugPrint('DatabaseHelper.insertSearchHistory error: $e');
      return 1; // Fallback ID for web
    }
  }

  Future<List<SearchHistory>> getSearchHistory({int limit = 50}) async {
    final db = await database;
    final results = await db.query(
      'search_history',
      orderBy: 'scanned_at DESC',
      limit: limit,
    );

    return results
        .map((row) => SearchHistory.fromJson({
              'id': row['id'],
              'user_id': row['user_id'],
              'wine_id': row['wine_id'],
              'wine_fingerprint': row['wine_fingerprint'],
              'wine_name': row['wine_name'],
              'cuisine_context': row['cuisine_context'],
              'budget_context': row['budget_context'],
              'scanned_at': row['scanned_at'],
              'face_earned': row['face_earned'],
            }))
        .toList();
  }

  Future<VaultStats> getVaultStats() async {
    final db = await database;

    final countResult =
        await db.rawQuery('SELECT COUNT(*) as count FROM search_history');
    final totalScans = Sqflite.firstIntValue(countResult) ?? 0;

    if (totalScans == 0) return VaultStats.empty();

    final faceResult = await db
        .rawQuery('SELECT SUM(face_earned) as total FROM search_history');
    final totalFace = (faceResult.first['total'] as num?)?.toDouble() ?? 0;

    // Sum scanned values via join
    double totalValue = 0;
    try {
      final valueResult = await db.rawQuery('''
        SELECT SUM(
          CAST(json_extract(w.metadata, '\$.benchmarks.average_price') AS REAL)
        ) as total
        FROM wines w
        INNER JOIN search_history sh ON w.fingerprint = sh.wine_fingerprint
      ''');
      totalValue = (valueResult.first['total'] as num?)?.toDouble() ?? 0;
    } catch (_) {
      // json_extract may not be available on all platforms
    }

    final cuisineResult = await db.rawQuery('''
      SELECT cuisine_context, COUNT(*) as count
      FROM search_history
      WHERE cuisine_context IS NOT NULL
      GROUP BY cuisine_context
      ORDER BY count DESC
      LIMIT 1
    ''');
    final mostCuisine = cuisineResult.isNotEmpty
        ? (cuisineResult.first['cuisine_context'] as String?) ?? '-'
        : '-';

    final recent = await getSearchHistory(limit: 10);
    final user = await getUser();

    return VaultStats(
      totalScans: totalScans,
      totalFaceEarned: totalFace,
      totalScannedValue: totalValue,
      mostScannedCuisine: mostCuisine,
      topConsumptionTier: user?.consumptionTier ?? 'Explorer',
      recentScans: recent,
    );
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('search_history');
    await db.delete('wines');
    await db.delete('users');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
