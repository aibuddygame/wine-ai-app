import 'wine_model.dart';

class SearchHistory {
  final String? id;
  final String? userId;
  final String wineId;
  final String wineFingerprint;
  final String? wineName;
  final String? cuisineContext;
  final int? budgetContext;
  final DateTime scannedAt;
  final double? faceEarned;

  const SearchHistory({
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
      wineId: (json['wine_id']?.toString()) ?? '',
      wineFingerprint: (json['wine_fingerprint'] as String?) ?? '',
      wineName: json['wine_name'] as String?,
      cuisineContext: json['cuisine_context'] as String?,
      budgetContext: (json['budget_context'] as num?)?.toInt(),
      scannedAt: json['scanned_at'] != null
          ? DateTime.tryParse(json['scanned_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      faceEarned: (json['face_earned'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (userId != null) 'user_id': userId,
        'wine_id': wineId,
        'wine_fingerprint': wineFingerprint,
        if (wineName != null) 'wine_name': wineName,
        if (cuisineContext != null) 'cuisine_context': cuisineContext,
        if (budgetContext != null) 'budget_context': budgetContext,
        'scanned_at': scannedAt.toIso8601String(),
        if (faceEarned != null) 'face_earned': faceEarned,
      };

  static double calculateFaceEarned(Wine wine) {
    double face = 0;

    // Base from global ranking (higher = rarer = more face)
    face += (100 - wine.benchmarks.globalTopPercent) * 0.5;

    // Bonus for high-end wines
    if (wine.benchmarks.averagePrice > 1000) face += 20;
    if (wine.benchmarks.averagePrice > 5000) face += 30;

    // Critic score bonus
    final score = wine.benchmarks.criticScore;
    if (score != null && score > 85) {
      face += (score - 85).clamp(0, 15);
    }

    return face.clamp(5, 100);
  }
}

class VaultStats {
  final int totalScans;
  final double totalFaceEarned;
  final double totalScannedValue;
  final String mostScannedCuisine;
  final String topConsumptionTier;
  final List<SearchHistory> recentScans;

  const VaultStats({
    required this.totalScans,
    required this.totalFaceEarned,
    required this.totalScannedValue,
    required this.mostScannedCuisine,
    required this.topConsumptionTier,
    required this.recentScans,
  });

  factory VaultStats.empty() => const VaultStats(
        totalScans: 0,
        totalFaceEarned: 0,
        totalScannedValue: 0,
        mostScannedCuisine: '-',
        topConsumptionTier: 'Explorer',
        recentScans: [],
      );
}
