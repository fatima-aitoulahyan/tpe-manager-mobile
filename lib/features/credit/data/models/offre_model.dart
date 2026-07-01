class OffreModel {
  final int    id;
  final String partenaireNom;
  final double tauxInteret;
  final int    dureeMois;
  final double mensualiteEstimee;
  final String? urlPortail;

  OffreModel({
    required this.id,
    required this.partenaireNom,
    required this.tauxInteret,
    required this.dureeMois,
    required this.mensualiteEstimee,
    this.urlPortail,
  });

  factory OffreModel.fromJson(Map<String, dynamic> json) {
    return OffreModel(
      id:                 int.tryParse(json['id'].toString()) ?? 0,
      partenaireNom:      json['partenaire_nom']?.toString() ?? '',
      tauxInteret:        double.tryParse(
          json['taux_interet']?.toString() ?? '0') ?? 0,
      dureeMois:          int.tryParse(
          json['duree_mois']?.toString() ?? '0') ?? 0,
      mensualiteEstimee:  double.tryParse(
          json['mensualite_estimee']?.toString() ?? '0') ?? 0,
      urlPortail:         json['url_portail']?.toString(),
    );
  }
}