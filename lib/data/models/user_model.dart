/// User Data Model
class User {
  final String? id;
  final String occupation;
  final int typicalBudget;
  final String consumptionTier;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.occupation,
    required this.typicalBudget,
    this.consumptionTier = 'Explorer',
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      occupation: json['occupation'] ?? '',
      typicalBudget: json['typical_budget'] ?? 500,
      consumptionTier: json['consumption_tier'] ?? 'Explorer',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'occupation': occupation,
      'typical_budget': typicalBudget,
      'consumption_tier': consumptionTier,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Calculate consumption tier based on typical budget
  static String calculateTier(int budget) {
    if (budget < 300) return 'Casual';
    if (budget < 800) return 'Explorer';
    if (budget < 2000) return 'Enthusiast';
    if (budget < 5000) return 'Connoisseur';
    return 'Collector';
  }

  User copyWith({
    String? id,
    String? occupation,
    int? typicalBudget,
    String? consumptionTier,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      occupation: occupation ?? this.occupation,
      typicalBudget: typicalBudget ?? this.typicalBudget,
      consumptionTier: consumptionTier ?? this.consumptionTier,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
