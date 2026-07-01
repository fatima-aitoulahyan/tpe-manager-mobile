class TransactionModel {
  final int     id;
  final String  type;
  final double  montant;
  final String  description;
  final String? categorie;
  final String  date;
  final String  createdAt;

  final int?    factureId;
  final String? factureNumero;

  TransactionModel({
    required this.id,
    required this.type,
    required this.montant,
    required this.description,
    this.categorie,
    required this.date,
    required this.createdAt,
    this.factureId,
    this.factureNumero,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id:           int.parse(json['id'].toString()),
      type:         json['type'].toString(),
      montant:      double.parse(json['montant'].toString()),
      description:  json['description'].toString(),
      categorie:    json['categorie']?.toString(),
      date:         json['date'].toString(),
      createdAt:    json['created_at'].toString(),
      factureId:    json['facture'] as int?,
      factureNumero: json['facture_numero'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type':        type,
    'montant':     montant,
    'description': description,
    'categorie':   categorie,
    'date':        date,
  };

  bool get isRecette => type == 'RECETTE';
  bool get isDepense => type == 'DEPENSE';
}

class DashboardModel {
  final double recettesMois;
  final double depensesMois;
  final double solde;
  final Map<String, double> categoriesRecettes;
  final Map<String, double> categoriesDepenses;

  DashboardModel({
    required this.recettesMois,
    required this.depensesMois,
    required this.solde,
    required this.categoriesRecettes,
    required this.categoriesDepenses,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    Map<String, double> parseCategories(dynamic raw) {
      if (raw == null) return {};
      return Map<String, double>.from(
          (raw as Map).map((k, v) =>
              MapEntry(k.toString(), double.parse(v.toString()))
          )
      );
    }

    return DashboardModel(
      recettesMois:       double.parse(
          json['recettes_mois'].toString()),
      depensesMois:       double.parse(
          json['depenses_mois'].toString()),
      solde:              double.parse(
          json['solde'].toString()),
      categoriesRecettes: parseCategories(
          json['categories_recettes']),
      categoriesDepenses: parseCategories(
          json['categories_depenses']),
    );
  }
}