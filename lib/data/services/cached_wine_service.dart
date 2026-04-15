import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../models/wine_model.dart';
import '../repositories/hive_database_helper.dart';
import 'kimi_service.dart';

/// Result of wine analysis containing the wine and cache status
class WineAnalysisResult {
  final Wine wine;
  final bool wasFromCache;

  const WineAnalysisResult({required this.wine, required this.wasFromCache});
}

/// Wine field completeness tracker
/// Used to determine which fields need to be generated
class WineFieldStatus {
  final bool hasIdentity;
  final bool hasBenchmarks;
  final bool hasTasteProfile;
  final bool hasServingIntel;
  final bool hasSocialScripts;
  final bool hasRegionStyle;
  final bool hasGrapeEducation;
  final bool hasFlavorProfile;
  final bool hasCommunityReview;
  final bool hasPairings;

  const WineFieldStatus({
    this.hasIdentity = false,
    this.hasBenchmarks = false,
    this.hasTasteProfile = false,
    this.hasServingIntel = false,
    this.hasSocialScripts = false,
    this.hasRegionStyle = false,
    this.hasGrapeEducation = false,
    this.hasFlavorProfile = false,
    this.hasCommunityReview = false,
    this.hasPairings = false,
  });

  factory WineFieldStatus.fromWine(Wine wine) {
    return WineFieldStatus(
      hasIdentity:
          wine.identity.fullName.isNotEmpty &&
          wine.identity.producer.isNotEmpty,
      hasBenchmarks: wine.benchmarks.averagePrice > 0,
      hasTasteProfile: wine.tasteProfile.lightBold > 0,
      hasServingIntel: wine.servingIntel.temperatureC > 0,
      hasSocialScripts:
          wine.socialScripts.theHook.isNotEmpty &&
          wine.socialScripts.theGrape.isNotEmpty &&
          wine.socialScripts.theRegion.isNotEmpty &&
          wine.socialScripts.theVintage.isNotEmpty &&
          wine.socialScripts.theTaste.isNotEmpty,
      hasRegionStyle:
          wine.regionStyle != null && wine.regionStyle!.description.isNotEmpty,
      hasGrapeEducation: wine.grapeEducation.isNotEmpty,
      hasFlavorProfile:
          wine.flavorProfile != null && wine.flavorProfile!.primary.isNotEmpty,
      hasCommunityReview:
          wine.communityReview != null &&
          wine.communityReview!.reviewText.isNotEmpty,
      hasPairings: wine.pairings.length >= 5,
    );
  }

  /// Calculate completeness percentage
  int get completenessPercentage {
    int total = 10;
    int complete = 0;
    if (hasIdentity) complete++;
    if (hasBenchmarks) complete++;
    if (hasTasteProfile) complete++;
    if (hasServingIntel) complete++;
    if (hasSocialScripts) complete++;
    if (hasRegionStyle) complete++;
    if (hasGrapeEducation) complete++;
    if (hasFlavorProfile) complete++;
    if (hasCommunityReview) complete++;
    if (hasPairings) complete++;
    return (complete / total * 100).round();
  }

  /// Check if wine is complete enough to serve from cache
  bool get isComplete => completenessPercentage >= 80;

  /// Get list of missing field names
  List<String> get missingFields {
    final missing = <String>[];
    if (!hasIdentity) missing.add('identity');
    if (!hasBenchmarks) missing.add('benchmarks');
    if (!hasTasteProfile) missing.add('taste_profile');
    if (!hasServingIntel) missing.add('serving_intel');
    if (!hasSocialScripts) missing.add('social_scripts');
    if (!hasRegionStyle) missing.add('region_style');
    if (!hasGrapeEducation) missing.add('grape_education');
    if (!hasFlavorProfile) missing.add('flavor_profile');
    if (!hasCommunityReview) missing.add('community_review');
    if (!hasPairings) missing.add('pairings');
    return missing;
  }
}

/// Cached Wine Service
///
/// Implements smart caching strategy:
/// 1. First scan: Generate all content via AI, cache in database
/// 2. Subsequent scans: Retrieve from database, only generate missing fields
/// 3. Progressive enhancement: Fill missing fields over time
class CachedWineService {
  final KimiService _kimiService;
  final HiveDatabaseHelper _db;

  CachedWineService({required String apiKey, HiveDatabaseHelper? db})
    : _kimiService = KimiService(apiKey: apiKey),
      _db = db ?? HiveDatabaseHelper();

  bool get hasApiKey => _kimiService.hasApiKey;

  /// Main entry point: Analyze wine with smart caching
  ///
  /// Flow:
  /// 1. Generate fingerprint from image (via AI identity detection)
  /// 2. Check database for existing wine
  /// 3. If found and complete: return cached wine
  /// 4. If found but incomplete: merge + generate missing fields
  /// 5. If not found: generate all fields via AI
  Future<WineAnalysisResult> analyzeWine(
    Uint8List imageBytes, {
    String? occupation,
    int? budget,
    String? cuisine,
  }) async {
    if (!hasApiKey) {
      throw const KimiServiceException(
        'API key not configured. Set KIMI_API_KEY in your .env file.',
      );
    }

    // Step 1: Get wine analysis from AI (identity needed for fingerprint)
    debugPrint('CachedWineService: Getting wine identity from AI...');
    final quickResult = await _kimiService.analyzeWineImageStage1(
      imageBytes,
      occupation: occupation,
      budget: budget,
    );
    // Create WineIdentity from quick result for fingerprinting
    final identity = WineIdentity(
      fullName: '${quickResult.winery} ${quickResult.wineName}',
      vintage: quickResult.vintage,
      producer: quickResult.winery,
      region: quickResult.region,
      subRegion: '',
      country: quickResult.country,
      wineType: quickResult.wineType,
      grapeVariety: quickResult.grape,
      grapes: [quickResult.grape],
    );
    final fingerprint = Wine.generateFingerprint(identity);

    debugPrint('CachedWineService: Generated fingerprint: $fingerprint');

    // Step 2: Check database for existing wine
    final cachedWine = await _db.getWineByFingerprint(fingerprint);

    if (cachedWine != null && !cachedWine.isCacheExpired) {
      debugPrint('CachedWineService: Found wine in database (not expired)');

      // Step 3: Check completeness
      final status = WineFieldStatus.fromWine(cachedWine);
      debugPrint(
        'CachedWineService: Wine completeness: ${status.completenessPercentage}%',
      );

      if (status.isComplete) {
        // Wine is complete, return from cache
        debugPrint('CachedWineService: Wine is complete, serving from cache');
        return WineAnalysisResult(wine: cachedWine, wasFromCache: true);
      } else {
        // Wine exists but incomplete - generate missing fields
        debugPrint(
          'CachedWineService: Wine incomplete. Missing: ${status.missingFields.join(', ')}',
        );
        // Enrich the quick result to get full wine data
        final enrichedWine = await _kimiService.enrichWineData(
          quickResult,
          occupation: occupation,
          budget: budget,
          cuisine: cuisine,
        );
        final enhancedWine = await _enhanceWine(
          cachedWine: cachedWine,
          imageBytes: imageBytes,
          analyzedWine: enrichedWine,
          missingFields: status.missingFields,
        );
        return WineAnalysisResult(wine: enhancedWine, wasFromCache: false);
      }
    }

    // Step 4: No cached wine or cache expired - generate all fields
    debugPrint('CachedWineService: Generating full wine content...');
    // Enrich the quick result to get full wine data
    final enrichedWine = await _kimiService.enrichWineData(
      quickResult,
      occupation: occupation,
      budget: budget,
      cuisine: cuisine,
    );
    final newWine = await _generateFullWine(
      imageBytes: imageBytes,
      analyzedWine: enrichedWine,
      fingerprint: fingerprint,
    );
    return WineAnalysisResult(wine: newWine, wasFromCache: false);
  }

  /// Step 4: Generate full wine content (first scan)
  Future<Wine> _generateFullWine({
    required Uint8List imageBytes,
    required Wine analyzedWine,
    required String fingerprint,
  }) async {
    debugPrint('CachedWineService: Generating full wine content via AI...');

    // Encode image to base64 for storage
    final base64Image = base64Encode(imageBytes);

    // Ensure fingerprint is set, cache timestamp is recorded, and image is stored
    final completeWine = analyzedWine.copyWith(
      fingerprint: fingerprint,
      cachedAt: DateTime.now(),
      scannedImageBase64: base64Image,
    );

    // Save to database
    try {
      await _db.insertWine(completeWine);
      debugPrint('CachedWineService: Full wine saved to database');
    } catch (e) {
      debugPrint('CachedWineService: Failed to save wine: $e');
    }

    return completeWine;
  }

  /// Step 3b: Enhance existing wine with missing fields
  Future<Wine> _enhanceWine({
    required Wine cachedWine,
    required Uint8List imageBytes,
    required Wine analyzedWine,
    required List<String> missingFields,
  }) async {
    debugPrint('CachedWineService: Enhancing wine with missing fields...');

    // Encode image to base64 for storage (if not already present)
    final base64Image =
        cachedWine.scannedImageBase64 ?? base64Encode(imageBytes);

    // Merge: Keep cached data, fill in missing fields from new data
    // Also update the cachedAt timestamp since we're refreshing the data
    // Preserve or add the scanned image
    final enhancedWine = _mergeWines(
      cached: cachedWine,
      fresh: analyzedWine,
      missingFields: missingFields,
    ).copyWith(cachedAt: DateTime.now(), scannedImageBase64: base64Image);

    // Save enhanced version back to database
    try {
      await _db.insertWine(enhancedWine);
      debugPrint('CachedWineService: Enhanced wine saved to database');
    } catch (e) {
      debugPrint('CachedWineService: Failed to save enhanced wine: $e');
    }

    return enhancedWine;
  }

  /// Merge two wine objects, keeping cached data and filling missing fields
  Wine _mergeWines({
    required Wine cached,
    required Wine fresh,
    required List<String> missingFields,
  }) {
    // Start with cached wine as base
    var merged = cached;

    // Fill in missing fields from fresh data
    if (missingFields.contains('identity') &&
        fresh.identity.fullName.isNotEmpty) {
      merged = merged.copyWith(identity: fresh.identity);
    }
    if (missingFields.contains('benchmarks') &&
        fresh.benchmarks.averagePrice > 0) {
      merged = merged.copyWith(benchmarks: fresh.benchmarks);
    }
    if (missingFields.contains('taste_profile') &&
        fresh.tasteProfile.lightBold > 0) {
      merged = merged.copyWith(tasteProfile: fresh.tasteProfile);
    }
    if (missingFields.contains('serving_intel') &&
        fresh.servingIntel.temperatureC > 0) {
      merged = merged.copyWith(servingIntel: fresh.servingIntel);
    }
    if (missingFields.contains('social_scripts') &&
        fresh.socialScripts.theHook.isNotEmpty) {
      merged = merged.copyWith(socialScripts: fresh.socialScripts);
    }
    if (missingFields.contains('region_style') && fresh.regionStyle != null) {
      merged = merged.copyWith(regionStyle: fresh.regionStyle);
    }
    if (missingFields.contains('grape_education') &&
        fresh.grapeEducation.isNotEmpty) {
      merged = merged.copyWith(grapeEducation: fresh.grapeEducation);
    }
    if (missingFields.contains('flavor_profile') &&
        fresh.flavorProfile != null) {
      merged = merged.copyWith(flavorProfile: fresh.flavorProfile);
    }
    if (missingFields.contains('community_review') &&
        fresh.communityReview != null) {
      merged = merged.copyWith(communityReview: fresh.communityReview);
    }
    if (missingFields.contains('pairings') && fresh.pairings.isNotEmpty) {
      // Merge pairings: keep existing, add new
      final mergedPairings = Map<String, DynamicPairing>.from(cached.pairings);
      for (final entry in fresh.pairings.entries) {
        if (!mergedPairings.containsKey(entry.key) ||
            mergedPairings[entry.key]?.pairingScore == 0) {
          mergedPairings[entry.key] = entry.value;
        }
      }
      merged = merged.copyWith(pairings: mergedPairings);
    }

    return merged;
  }

  /// Get cache statistics for debugging
  Future<Map<String, dynamic>> getCacheStats() async {
    final allWines = await _db.getAllWines();

    int completeCount = 0;
    int partialCount = 0;
    int totalCompleteness = 0;

    for (final wine in allWines) {
      final status = WineFieldStatus.fromWine(wine);
      totalCompleteness += status.completenessPercentage;

      if (status.isComplete) {
        completeCount++;
      } else {
        partialCount++;
      }
    }

    return {
      'totalWines': allWines.length,
      'completeWines': completeCount,
      'partialWines': partialCount,
      'averageCompleteness': allWines.isNotEmpty
          ? totalCompleteness ~/ allWines.length
          : 0,
    };
  }

  void dispose() {
    _kimiService.dispose();
  }
}
