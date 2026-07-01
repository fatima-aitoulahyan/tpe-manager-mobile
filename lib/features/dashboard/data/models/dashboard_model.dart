double _safeDouble(dynamic value) =>
    double.tryParse(value?.toString() ?? '0') ?? 0.0;

int _safeInt(dynamic value) =>
    int.tryParse(value?.toString() ?? '0') ?? 0;

class CashflowSummary {
  final double recettesMois;
  final double depensesMois;
  final double solde;

  CashflowSummary({
    required this.recettesMois,
    required this.depensesMois,
    required this.solde,
  });

  factory CashflowSummary.fromJson(Map<String, dynamic> json) {
    return CashflowSummary(
      recettesMois: _safeDouble(json['recettes_mois']),
      depensesMois: _safeDouble(json['depenses_mois']),
      solde:        _safeDouble(json['solde']),
    );
  }
}

class DevisStats {
  final int    totalQuotes;
  final Map<String, int> byStatus;
  final String conversionRate;

  DevisStats({
    required this.totalQuotes,
    required this.byStatus,
    required this.conversionRate,
  });

  factory DevisStats.fromJson(Map<String, dynamic> json) {
    return DevisStats(
      totalQuotes:    _safeInt(json['total_quotes']),
      byStatus:       Map<String, int>.from(
        ((json['by_status'] as Map?) ?? {}).map(
              (k, v) => MapEntry(k.toString(), _safeInt(v)),
        ),
      ),
      conversionRate: json['conversion_rate']?.toString() ?? '0%',
    );
  }
}