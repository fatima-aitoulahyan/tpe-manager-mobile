import '../../../clients/data/models/client_model.dart';
import 'ligne_devis_model.dart';

class DevisModel {
  final int id;
  final String numero;
  final String statut;
  final String dateCreation;
  final String dateValidite;
  final double tauxTva;
  final double montantTotal;
  final double montantHt;
  final double montantTtc;
  final String modePaiement;
  final String? conditions;
  final ClientModel clientDetail;
  final List<LigneDevisModel> lignes;
  final bool peutConvertir;
  final int?    factureId;
  final String? factureNumero;

  DevisModel({
    required this.id,
    required this.numero,
    required this.statut,
    required this.dateCreation,
    required this.dateValidite,
    required this.tauxTva,
    required this.montantTotal,
    required this.montantHt,
    required this.montantTtc,
    required this.modePaiement,
    this.conditions,
    required this.clientDetail,
    required this.lignes,
    required this.peutConvertir,
    this.factureId,
    this.factureNumero,
  });

  factory DevisModel.fromJson(Map<String, dynamic> json) {
    return DevisModel(
      id:            json['id'],
      numero:        json['numero'],
      statut:        json['statut'],
      dateCreation:  json['date_creation'],
      dateValidite:  json['date_validite'],
      tauxTva:       double.parse(json['taux_tva'].toString()),
      montantTotal:  double.parse(json['montant_total'].toString()),
      montantHt:     double.parse(json['montant_ht'].toString()),
      montantTtc:    double.parse(json['montant_ttc'].toString()),
      modePaiement:  json['mode_paiement'],
      conditions:    json['conditions'],
      clientDetail:  ClientModel.fromJson(json['client_detail']),
      lignes:        (json['lignes'] as List)
          .map((l) => LigneDevisModel.fromJson(l))
          .toList(),
      peutConvertir: json['peut_convertir'] ?? false,
      factureId:     json['facture_id'] as int?,
      factureNumero: json['facture_numero'] as String?,
    );
  }
}

class DevisListModel {
  final int id;
  final String numero;
  final String statut;
  final String dateCreation;
  final String dateValidite;
  final String clientNom;
  final double montantTtc;

  DevisListModel({
    required this.id,
    required this.numero,
    required this.statut,
    required this.dateCreation,
    required this.dateValidite,
    required this.clientNom,
    required this.montantTtc,
  });

  factory DevisListModel.fromJson(Map<String, dynamic> json) {
    return DevisListModel(
      id:           json['id'],
      numero:       json['numero'],
      statut:       json['statut'],
      dateCreation: json['date_creation'],
      dateValidite: json['date_validite'],
      clientNom:    json['client_nom'],
      montantTtc:   double.parse(json['montant_ttc'].toString()),
    );
  }
}