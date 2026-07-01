import '../../../clients/data/models/client_model.dart';
import 'ligne_facure_model.dart';

class FactureModel {
  final int     id;
  final String  numero;
  final String  statut;
  final int?    clientId;
  final String  clientNom;
  final int?    devisId;
  final String? devisNumero;
  final bool    estIssueDevis;
  final DateTime dateEmission;
  final DateTime? dateEcheance;
  final double  tauxTva;
  final double  montantTotal;
  final double  montantHt;
  final double  montantPaye;
  final double  resteAPayer;
  final String? modePaiement;
  final String? conditions;
  final List<LigneFactureModel> lignes;
  final ClientModel? clientDetail;

  FactureModel({
    required this.id,
    required this.numero,
    required this.statut,
    this.clientId,
    required this.clientNom,
    this.devisId,
    this.devisNumero,
    required this.estIssueDevis,
    required this.dateEmission,
    this.dateEcheance,
    required this.tauxTva,
    required this.montantTotal,
    required this.montantHt,
    required this.montantPaye,
    required this.resteAPayer,
    this.modePaiement,
    this.conditions,
    required this.lignes,
    this.clientDetail,
  });

  factory FactureModel.fromJson(Map<String, dynamic> j) => FactureModel(
    id:            j['id'] as int? ?? 0,
    numero:        j['numero'] as String? ?? 'N° Inconnu',
    statut:        j['statut'] as String? ?? 'EN_ATTENTE',
    clientId:      j['client'] as int?,
    clientNom:     j['client_nom'] ??
        (j['client_detail'] != null
            ? (j['client_detail']['nom'] ?? '')
            : ''),
    devisId:       j['devis'] as int?,
    devisNumero:   j['devis_numero'] as String?,
    estIssueDevis: j['est_issue_devis'] ?? false,
    dateEmission:  j['date_emission'] != null
        ? DateTime.parse(j['date_emission'])
        : DateTime.now(),
    dateEcheance:  j['date_echeance'] != null
        ? DateTime.parse(j['date_echeance'])
        : null,
    tauxTva:       double.tryParse(j['taux_tva']?.toString() ?? '0') ?? 0.0,
    montantTotal:  double.tryParse((j['montant_ttc'] ?? j['montant_total'])?.toString() ?? '0') ?? 0.0,
    montantHt:     double.tryParse(j['montant_ht']?.toString() ?? '0') ?? 0.0,
    montantPaye:   double.tryParse(j['montant_paye']?.toString() ?? '0') ?? 0.0,
    resteAPayer:   double.tryParse(j['reste_a_payer']?.toString() ?? '0') ?? 0.0,
    modePaiement:  j['mode_paiement'] as String?,
    conditions:    j['conditions'] as String?,
    lignes:        (j['lignes'] as List? ?? [])
        .map((e) => LigneFactureModel.fromJson(e))
        .toList(),
    clientDetail:  j['client_detail'] != null
        ? ClientModel.fromJson(j['client_detail'])
        : null,
  );

  double get montantTtc => montantTotal;
  String get clientName => clientNom;
  String? get clientTelephone => clientDetail?.telephone;
  String? get clientEmail     => clientDetail?.email;
}