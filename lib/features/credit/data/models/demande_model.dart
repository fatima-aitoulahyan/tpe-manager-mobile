import 'justificatif_model.dart';
import 'offre_model.dart';

class DemandeListModel {
  final int     id;
  final String  typeFinancementDisplay;
  final double  montantDemande;
  final int     dureeMois;
  final String  statut;
  final String  statutDisplay;
  final String? motifRefus;
  final String  dateDemande;

  DemandeListModel({
    required this.id,
    required this.typeFinancementDisplay,
    required this.montantDemande,
    required this.dureeMois,
    required this.statut,
    required this.statutDisplay,
    this.motifRefus,
    required this.dateDemande,
  });

  factory DemandeListModel.fromJson(Map<String, dynamic> json) {
    return DemandeListModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      typeFinancementDisplay:
      json['type_financement_display']?.toString() ?? '',
      montantDemande: double.tryParse(
          json['montant_demande']?.toString() ?? '0') ?? 0,
      dureeMois: int.tryParse(
          json['duree_mois']?.toString() ?? '0') ?? 0,
      statut:        json['statut']?.toString() ?? '',
      statutDisplay: json['statut_display']?.toString() ?? '',
      motifRefus:    json['motif_refus']?.toString(),
      dateDemande:   json['date_demande']?.toString() ?? '',
    );
  }
}

class DemandeModel {
  final int     id;
  final String  typeFinancement;
  final String  typeFinancementDisplay;
  final double  montantDemande;
  final int     dureeMois;
  final String  objetFinancement;
  final String  statut;
  final String  statutDisplay;
  final String? motifRefus;
  final double  scoreEligibilite;
  final String? niveauEligibilite;
  final bool    consentementCndp;
  final String? dateConsentement;
  final String  dateDemande;
  final List<JustificatifModel> justificatifs;
  final List<OffreModel>        offres;

  DemandeModel({
    required this.id,
    required this.typeFinancement,
    required this.typeFinancementDisplay,
    required this.montantDemande,
    required this.dureeMois,
    required this.objetFinancement,
    required this.statut,
    required this.statutDisplay,
    this.motifRefus,
    required this.scoreEligibilite,
    this.niveauEligibilite,
    required this.consentementCndp,
    this.dateConsentement,
    required this.dateDemande,
    required this.justificatifs,
    required this.offres,
  });

  factory DemandeModel.fromJson(Map<String, dynamic> json) {
    return DemandeModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      typeFinancement: json['type_financement']?.toString() ?? '',
      typeFinancementDisplay:
      json['type_financement_display']?.toString() ?? '',
      montantDemande: double.tryParse(
          json['montant_demande']?.toString() ?? '0') ?? 0,
      dureeMois: int.tryParse(
          json['duree_mois']?.toString() ?? '0') ?? 0,
      objetFinancement: json['objet_financement']?.toString() ?? '',
      statut:           json['statut']?.toString() ?? '',
      statutDisplay:    json['statut_display']?.toString() ?? '',
      motifRefus:       json['motif_refus']?.toString(),
      scoreEligibilite: double.tryParse(
          json['score_eligibilite']?.toString() ?? '0') ?? 0,
      niveauEligibilite: json['niveau_eligibilite']?.toString(),
      consentementCndp:  json['consentement_cndp'] ?? false,
      dateConsentement:  json['date_consentement']?.toString(),
      dateDemande:       json['date_demande']?.toString() ?? '',
      justificatifs: (json['justificatifs'] as List? ?? [])
          .map((j) => JustificatifModel.fromJson(j)).toList(),
      offres: (json['offres'] as List? ?? [])
          .map((o) => OffreModel.fromJson(o)).toList(),
    );
  }
}