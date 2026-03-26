import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/wine.dart';
import '../models/cuisine_pairing.dart';
import '../core/constants/app_constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path;
    if (kIsWeb) {
      path = 'wine_ai_v2.db';
    } else {
      final dbPath = await getDatabasesPath();
      path = p.join(dbPath, 'wine_ai_v2.db');
    }

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE wines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fingerprint TEXT UNIQUE NOT NULL,
        wine_name TEXT NOT NULL,
        vintage TEXT,
        winery TEXT,
        region TEXT,
        country TEXT,
        grape_variety TEXT,
        alcohol_content TEXT,
        taste_profile_json TEXT,
        rankings_json TEXT,
        raw_response_json TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE cuisine_pairings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        wine_id INTEGER,
        cuisine TEXT NOT NULL,
        compatibility_score INTEGER,
        social_script_json TEXT,
        recommended_dishes_json TEXT,
        FOREIGN KEY (wine_id) REFERENCES wines(id),
        UNIQUE(wine_id, cuisine)
      )
    ''');

    await db.execute(
        'CREATE INDEX idx_wines_fingerprint ON wines(fingerprint)');
    await db.execute(
        'CREATE INDEX idx_pairings_wine ON cuisine_pairings(wine_id)');
  }

  // ==================== WINE OPERATIONS ====================

  Future<int> insertWine(Wine wine) async {
    final db = await database;
    return db.insert(
      'wines',
      {
        'fingerprint': wine.fingerprint,
        'wine_name': wine.wineName,
        'vintage': wine.vintage,
        'winery': wine.winery,
        'region': wine.region,
        'country': wine.country,
        'grape_variety': wine.grapeVariety,
        'alcohol_content': wine.alcoholContent,
        'taste_profile_json': jsonEncode(wine.tasteProfile.toJson()),
        'rankings_json': jsonEncode({
          'world_percentile': wine.worldPercentile,
          'region_percentile': wine.regionPercentile,
        }),
        'raw_response_json': wine.rawResponseJson,
        'created_at': DateTime.now().toIso8601String(),
        'last_accessed': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

    // Update last_accessed
    await db.update(
      'wines',
      {'last_accessed': DateTime.now().toIso8601String()},
      where: 'fingerprint = ?',
      whereArgs: [fingerprint],
    );

    return _wineFromRow(results.first);
  }

  Wine _wineFromRow(Map<String, dynamic> row) {
    Map<String, dynamic> tasteJson = {};
    if (row['taste_profile_json'] != null) {
      tasteJson =
          jsonDecode(row['taste_profile_json'] as String) as Map<String, dynamic>;
    }

    Map<String, dynamic> rankingsJson = {};
    if (row['rankings_json'] != null) {
      rankingsJson =
          jsonDecode(row['rankings_json'] as String) as Map<String, dynamic>;
    }

    return Wine(
      id: row['id'] as int?,
      fingerprint: (row['fingerprint'] as String?) ?? '',
      wineName: (row['wine_name'] as String?) ?? '',
      vintage: (row['vintage'] as String?) ?? '',
      winery: (row['winery'] as String?) ?? '',
      region: (row['region'] as String?) ?? '',
      country: (row['country'] as String?) ?? '',
      grapeVariety: (row['grape_variety'] as String?) ?? '',
      alcoholContent: (row['alcohol_content'] as String?) ?? '',
      tasteProfile:
          tasteJson.isNotEmpty ? TasteProfile.fromJson(tasteJson) : const TasteProfile(lightBold: 50, smoothTannic: 50, drySweet: 50, softAcidic: 50),
      worldPercentile:
          (rankingsJson['world_percentile'] as num?)?.toInt() ?? 0,
      regionPercentile:
          (rankingsJson['region_percentile'] as num?)?.toInt() ?? 0,
      rawResponseJson: row['raw_response_json'] as String?,
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'].toString())
          : null,
      lastAccessed: row['last_accessed'] != null
          ? DateTime.tryParse(row['last_accessed'].toString())
          : null,
    );
  }

  // ==================== CUISINE PAIRING OPERATIONS ====================

  Future<int> insertCuisinePairing(int wineId, CuisinePairing pairing) async {
    final db = await database;
    return db.insert(
      'cuisine_pairings',
      {
        'wine_id': wineId,
        'cuisine': pairing.cuisine,
        'compatibility_score': pairing.compatibilityScore,
        'social_script_json': jsonEncode(pairing.socialScript.toJson()),
        'recommended_dishes_json':
            jsonEncode(pairing.recommendedDishes.map((d) => d.toJson()).toList()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CuisinePairing?> getCuisinePairing(
      int wineId, String cuisine) async {
    final db = await database;
    final results = await db.query(
      'cuisine_pairings',
      where: 'wine_id = ? AND cuisine = ?',
      whereArgs: [wineId, cuisine],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _pairingFromRow(results.first);
  }

  CuisinePairing _pairingFromRow(Map<String, dynamic> row) {
    Map<String, dynamic> socialJson = {};
    if (row['social_script_json'] != null) {
      socialJson =
          jsonDecode(row['social_script_json'] as String) as Map<String, dynamic>;
    }

    List<dynamic> dishesJson = [];
    if (row['recommended_dishes_json'] != null) {
      dishesJson =
          jsonDecode(row['recommended_dishes_json'] as String) as List<dynamic>;
    }

    return CuisinePairing(
      id: row['id'] as int?,
      wineId: row['wine_id'] as int?,
      cuisine: (row['cuisine'] as String?) ?? '',
      compatibilityScore:
          (row['compatibility_score'] as num?)?.toInt() ?? 0,
      socialScript: SocialSurvivalScript.fromJson(socialJson),
      recommendedDishes: dishesJson
          .map((d) => RecommendedDish.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
