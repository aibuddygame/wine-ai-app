import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/wine_model.dart';
import '../models/user_model.dart';
import '../models/search_history_model.dart';
import '../../core/constants/app_constants.dart';

/// Database Helper for SQLite operations
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
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Wines table
    await db.execute('''
      CREATE TABLE wines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fingerprint TEXT UNIQUE NOT NULL,
        metadata TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Users table
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

    // Search history table
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

    // Create indexes
    await db.execute('CREATE INDEX idx_wines_fingerprint ON wines(fingerprint)');
    await db.execute('CREATE INDEX idx_history_user ON search_history(user_id)');
    await db.execute('CREATE INDEX idx_history_scanned ON search_history(scanned_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
  }

  // ==================== WINE OPERATIONS ====================

  /// Insert or update a wine
  Future<int> insertWine(Wine wine) async {
    final db = await database;
    final metadata = jsonEncode(wine.toJson());
    
    return await db.insert(
      'wines',
      {
        'fingerprint': wine.fingerprint,
        'metadata': metadata,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get wine by fingerprint
  Future<Wine?> getWineByFingerprint(String fingerprint) async {
    final db = await database;
    final results = await db.query(
      'wines',
      where: 'fingerprint = ?',
      whereArgs: [fingerprint],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final metadata = jsonDecode(results.first['metadata'] as String);
    return Wine.fromJson({
      ...metadata,
      'id': results.first['id'],
      'fingerprint': results.first['fingerprint'],
      'created_at': results.first['created_at'],
    });
  }

  /// Get all wines
  Future<List<Wine>> getAllWines() async {
    final db = await database;
    final results = await db.query('wines', orderBy: 'created_at DESC');

    return results.map((row) {
      final metadata = jsonDecode(row['metadata'] as String);
      return Wine.fromJson({
        ...metadata,
        'id': row['id'],
        'fingerprint': row['fingerprint'],
        'created_at': row['created_at'],
      });
    }).toList();
  }

  // ==================== USER OPERATIONS ====================

  /// Insert or update user (singleton - only one user)
  Future<int> saveUser(User user) async {
    final db = await database;
    
    // Check if user exists
    final existing = await db.query('users', limit: 1);
    
    if (existing.isNotEmpty) {
      // Update
      return await db.update(
        'users',
        {
          'occupation': user.occupation,
          'typical_budget': user.typicalBudget,
          'consumption_tier': user.consumptionTier,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      // Insert
      return await db.insert('users', {
        'occupation': user.occupation,
        'typical_budget': user.typicalBudget,
        'consumption_tier': user.consumptionTier,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Get current user
  Future<User?> getUser() async {
    final db = await database;
    final results = await db.query('users', limit: 1);

    if (results.isEmpty) return null;

    return User.fromJson({
      'id': results.first['id'],
      'occupation': results.first['occupation'],
      'typical_budget': results.first['typical_budget'],
      'consumption_tier': results.first['consumption_tier'],
      'created_at': results.first['created_at'],
      'updated_at': results.first['updated_at'],
    });
  }

  // ==================== SEARCH HISTORY OPERATIONS ====================

  /// Insert search history entry
  Future<int> insertSearchHistory(SearchHistory history) async {
    final db = await database;
    return await db.insert('search_history', {
      'user_id': history.userId,
      'wine_id': history.wineId,
      'wine_fingerprint': history.wineFingerprint,
      'wine_name': history.wineName,
      'cuisine_context': history.cuisineContext,
      'budget_context': history.budgetContext,
      'scanned_at': history.scannedAt.toIso8601String(),
      'face_earned': history.faceEarned,
    });
  }

  /// Get all search history
  Future<List<SearchHistory>> getSearchHistory({int limit = 50}) async {
    final db = await database;
    final results = await db.query(
      'search_history',
      orderBy: 'scanned_at DESC',
      limit: limit,
    );

    return results.map((row) => SearchHistory.fromJson({
      'id': row['id'],
      'user_id': row['user_id'],
      'wine_id': row['wine_id'],
      'wine_fingerprint': row['wine_fingerprint'],
      'wine_name': row['wine_name'],
      'cuisine_context': row['cuisine_context'],
      'budget_context': row['budget_context'],
      'scanned_at': row['scanned_at'],
      'face_earned': row['face_earned'],
    })).toList();
  }

  /// Get vault statistics
  Future<VaultStats> getVaultStats() async {
    final db = await database;

    // Total scans
    final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM search_history');
    final totalScans = Sqflite.firstIntValue(countResult) ?? 0;

    if (totalScans == 0) {
      return VaultStats.empty();
    }

    // Total face earned
    final faceResult = await db.rawQuery('SELECT SUM(face_earned) as total FROM search_history');
    final totalFace = (faceResult.first['total'] as num?)?.toDouble() ?? 0;

    // Total scanned value (estimated from wines)
    final valueResult = await db.rawQuery('''
      SELECT SUM(
        CAST(json_extract(metadata, '\$.benchmarks.average_price') AS REAL)
      ) as total 
      FROM wines w
      INNER JOIN search_history sh ON w.fingerprint = sh.wine_fingerprint
    ''');
    final totalValue = (valueResult.first['total'] as num?)?.toDouble() ?? 0;

    // Most scanned cuisine
    final cuisineResult = await db.rawQuery('''
      SELECT cuisine_context, COUNT(*) as count 
      FROM search_history 
      WHERE cuisine_context IS NOT NULL
      GROUP BY cuisine_context 
      ORDER BY count DESC 
      LIMIT 1
    ''');
    final mostCuisine = cuisineResult.isNotEmpty 
        ? (cuisineResult.first['cuisine_context'] as String? ?? '-')
        : '-';

    // Recent scans
    final recent = await getSearchHistory(limit: 10);

    // Get user tier
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

  /// Clear all data (for testing)
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('search_history');
    await db.delete('wines');
    await db.delete('users');
  }

  /// Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
