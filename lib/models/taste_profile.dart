class TasteProfile {
  final int lightBold;
  final int smoothTannic;
  final int drySweet;
  final int softAcidic;

  const TasteProfile({
    required this.lightBold,
    required this.smoothTannic,
    required this.drySweet,
    required this.softAcidic,
  });

  factory TasteProfile.fromJson(Map<String, dynamic> json) {
    return TasteProfile(
      lightBold: ((json['light_bold'] as num?)?.toInt() ?? 50).clamp(0, 100),
      smoothTannic:
          ((json['smooth_tannic'] as num?)?.toInt() ?? 50).clamp(0, 100),
      drySweet: ((json['dry_sweet'] as num?)?.toInt() ?? 50).clamp(0, 100),
      softAcidic:
          ((json['soft_acidic'] as num?)?.toInt() ?? 50).clamp(0, 100),
    );
  }

  Map<String, dynamic> toJson() => {
        'light_bold': lightBold,
        'smooth_tannic': smoothTannic,
        'dry_sweet': drySweet,
        'soft_acidic': softAcidic,
      };
}
