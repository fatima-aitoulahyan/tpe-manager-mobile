class LigneFactureModel {
  final int? id;
  final String libelle;
  final double prixUnitaire;
  final double quantite;
  final double? total;

  LigneFactureModel({
    this.id,
    required this.libelle,
    required this.prixUnitaire,
    required this.quantite,
    this.total,
  });

  factory LigneFactureModel.fromJson(Map<String, dynamic> json) {
    return LigneFactureModel(
      id:            json['id'],
      libelle:       json['libelle'],
      prixUnitaire:  double.parse(json['prix_unitaire'].toString()),
      quantite:      double.parse(json['quantite'].toString()),
      total:         double.parse(json['total'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'libelle':       libelle,
    'prix_unitaire': prixUnitaire,
    'quantite':      quantite,
  };

  double get calculatedTotal => prixUnitaire * quantite;
}