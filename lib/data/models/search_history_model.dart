import 'wine_model.dart';

/// Search History Data Model
class SearchHistory {
  final String? id;
  final String? userId;
  final String wineId;
  final String wineFingerprint;
  final String? wineName;
  final String? cuisineContext;
  final int? budgetContext;
  final DateTime scannedAt;
  final double? faceEarned; // Calculated score based on wine prestige

  SearchHistory({
    this.id,
    this.userId,
    required this.wineId,
    required this.wineFingerprint,
    this.wineName,
    this.cuisineContext,
    this.budgetContext,
    required this.scannedAt,
    this.faceEarned,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      wineId: json['wine_id']?.toString() ?? '',
      wineFingerprint: json['wine_fingerprint'] ?? '',
      wineName: json['wine_name'],
      cuisineContext: json['cuisine_context'],
      budgetContext: json['budget_context'],
      scannedAt: json['scanned_at'] != null
          ? DateTime.parse(json['scanned_at'])
          : DateTime.now(),
      faceEarned: json['face_earned']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'wine_id': wineId,
      'wine_fingerprint': wineFingerprint,
      'wine_name': wineName,
      'cuisine_context': cuisineContext,
      'budget_context': budgetContext,
      'scanned_at': scannedAt.toIso8601String(),
      'face_earned': faceEarned,
    };
  }

  /// Calculate face earned based on wine benchmarks
  static double calculateFaceEarned(Wine wine) {
    double face = 0;
    
    // Base from global ranking
    face += (100 - wine.benchmarks.globalTopPercent) * 0.5;
    
    // Bonus for high-end wines
    if (wine.benchmarks.averagePrice > 1000) face += 20;
    if (wine.benchmarks.averagePrice > 5000) face += 30;
    
    // Critic score bonus
    if (wine.benchmarks.criticScore != null) {
      face += (wine.benchmarks.criticScore! - 85).clamp(0, 15);
    }
    
    return face.clamp(5, 100);
  }
}

/// Vault Statistics Model
class VaultStats {
  final int totalScans;
  final double totalFaceEarned;
  final double totalScannedValue;
  final String mostScannedCuisine;
  final String topConsumptionTier;
  final List<SearchHistory> recentScans;

  VaultStats({
    required this.totalScans,
    required this.totalFaceEarned,
    required this.totalScannedValue,
    required this.mostScannedCuisine,
    required this.topConsumptionTier,
    required this.recentScans,
  });

  factory VaultStats.empty() {
    return VaultStats(
      totalScans: 0,
      totalFaceEarned: 0,
      totalScannedValue: 0,
      mostScannedCuisine: '-',
      topConsumptionTier: 'Explorer',
      recentScans: [],
    );
  }
}
