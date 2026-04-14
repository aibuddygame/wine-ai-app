/// Lightweight Stage 1 wine scan result
/// Fast identification only - no heavy analysis
class WineScanQuickResult {
  final String wineName;
  final String winery;
  final String vintage;
  final String country;
  final String region;
  final String wineType;
  final String grape;
  final double confidence;
  final String shortSummaryZh;
  final String tonightFitZh;

  WineScanQuickResult({
    required this.wineName,
    required this.winery,
    required this.vintage,
    required this.country,
    required this.region,
    required this.wineType,
    required this.grape,
    required this.confidence,
    required this.shortSummaryZh,
    required this.tonightFitZh,
  });

  factory WineScanQuickResult.fromJson(Map<String, dynamic> json) {
    return WineScanQuickResult(
      wineName: json['wine_name'] ?? '',
      winery: json['winery'] ?? '',
      vintage: json['vintage'] ?? '',
      country: json['country'] ?? '',
      region: json['region'] ?? '',
      wineType: json['wine_type'] ?? 'unknown',
      grape: json['grape'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      shortSummaryZh: json['short_summary_zh'] ?? '',
      tonightFitZh: json['tonight_fit_zh'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wine_name': wineName,
      'winery': winery,
      'vintage': vintage,
      'country': country,
      'region': region,
      'wine_type': wineType,
      'grape': grape,
      'confidence': confidence,
      'short_summary_zh': shortSummaryZh,
      'tonight_fit_zh': tonightFitZh,
    };
  }

  /// Check if result is valid (has minimum required fields)
  bool get isValid => wineName.isNotEmpty && winery.isNotEmpty && confidence > 0.3;

  /// Get display title
  String get displayTitle => '$winery $wineName';

  /// Get subtitle with vintage
  String get displaySubtitle => '$vintage · $region, $country';
}