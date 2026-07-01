class EligibiliteModel {
  final double       score;
  final String       niveau;
  final List<String> conseils;

  EligibiliteModel({
    required this.score,
    required this.niveau,
    required this.conseils,
  });

  factory EligibiliteModel.fromJson(Map<String, dynamic> json) {
    return EligibiliteModel(
      score:    double.tryParse(json['score']?.toString() ?? '0') ?? 0,
      niveau:   json['niveau']?.toString() ?? 'ROUGE',
      conseils: List<String>.from(json['conseils'] ?? []),
    );
  }
}