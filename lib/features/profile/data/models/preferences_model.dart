class PreferencesModel {
  final bool rappelFactureImpayee;
  final int  rappelFactureJours;
  final bool rappelDevisExpirant;
  final int  rappelDevisJoursAvant;
  final bool rappelDeclarationFiscale;
  final bool rappelCotisationCnss;
  final bool notificationDemandeCredit;
  final bool canalInApp;
  final bool canalPush;
  final bool canalSms;

  PreferencesModel({
    required this.rappelFactureImpayee,
    required this.rappelFactureJours,
    required this.rappelDevisExpirant,
    required this.rappelDevisJoursAvant,
    required this.rappelDeclarationFiscale,
    required this.rappelCotisationCnss,
    required this.notificationDemandeCredit,
    required this.canalInApp,
    required this.canalPush,
    required this.canalSms,
  });

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      rappelFactureImpayee: json['rappel_facture_impayee'] ?? true,
      rappelFactureJours:   int.tryParse(
          json['rappel_facture_jours']?.toString() ?? '3') ?? 3,
      rappelDevisExpirant:  json['rappel_devis_expirant'] ?? true,
      rappelDevisJoursAvant: int.tryParse(
          json['rappel_devis_jours_avant']?.toString() ?? '3') ?? 3,
      rappelDeclarationFiscale:
      json['rappel_declaration_fiscale'] ?? true,
      rappelCotisationCnss:
      json['rappel_cotisation_cnss'] ?? false,
      notificationDemandeCredit:
      json['notification_demande_credit'] ?? true,
      canalInApp: json['canal_in_app'] ?? true,
      canalPush:  json['canal_push']   ?? true,
      canalSms:   json['canal_sms']    ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'rappel_facture_impayee':     rappelFactureImpayee,
    'rappel_facture_jours':       rappelFactureJours,
    'rappel_devis_expirant':      rappelDevisExpirant,
    'rappel_devis_jours_avant':   rappelDevisJoursAvant,
    'rappel_declaration_fiscale': rappelDeclarationFiscale,
    'rappel_cotisation_cnss':     rappelCotisationCnss,
    'notification_demande_credit': notificationDemandeCredit,
    'canal_in_app': canalInApp,
    'canal_push':   canalPush,
    'canal_sms':    canalSms,
  };

  PreferencesModel copyWith({
    bool? rappelFactureImpayee,
    int?  rappelFactureJours,
    bool? rappelDevisExpirant,
    int?  rappelDevisJoursAvant,
    bool? rappelDeclarationFiscale,
    bool? rappelCotisationCnss,
    bool? notificationDemandeCredit,
    bool? canalInApp,
    bool? canalPush,
    bool? canalSms,
  }) {
    return PreferencesModel(
      rappelFactureImpayee: rappelFactureImpayee ?? this.rappelFactureImpayee,
      rappelFactureJours:   rappelFactureJours   ?? this.rappelFactureJours,
      rappelDevisExpirant:  rappelDevisExpirant  ?? this.rappelDevisExpirant,
      rappelDevisJoursAvant: rappelDevisJoursAvant ?? this.rappelDevisJoursAvant,
      rappelDeclarationFiscale:
      rappelDeclarationFiscale ?? this.rappelDeclarationFiscale,
      rappelCotisationCnss:
      rappelCotisationCnss ?? this.rappelCotisationCnss,
      notificationDemandeCredit:
      notificationDemandeCredit ?? this.notificationDemandeCredit,
      canalInApp: canalInApp ?? this.canalInApp,
      canalPush:  canalPush  ?? this.canalPush,
      canalSms:   canalSms   ?? this.canalSms,
    );
  }
}