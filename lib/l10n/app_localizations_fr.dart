// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get loginTitle => 'Bon retour';

  @override
  String get loginSubtitle => 'Connectez-vous pour gérer votre activité';

  @override
  String get emailLabel => 'Adresse email';

  @override
  String get emailHint => 'vous@exemple.com';

  @override
  String get emailRequired => 'Email requis';

  @override
  String get emailInvalid => 'Email invalide';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordRequired => 'Mot de passe requis';

  @override
  String get passwordMinLength => 'Minimum 8 caractères';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get orDivider => 'ou';

  @override
  String get noAccount => 'Pas encore de compte ? ';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get forgotPasswordSubtitle =>
      'Entrez votre email. Nous vous enverrons un code pour réinitialiser votre mot de passe.';

  @override
  String get sendCode => 'Envoyer le code';

  @override
  String get newPasswordTitle => 'Nouveau mot de passe';

  @override
  String get newPasswordSubtitle =>
      'Choisissez un mot de passe sécurisé d\'au moins 8 caractères.';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get fieldRequired => 'Requis';

  @override
  String get passwordsDontMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordResetSuccess => 'Mot de passe réinitialisé avec succès !';

  @override
  String get resetButton => 'Réinitialiser';

  @override
  String get registerTitle => 'Bienvenue';

  @override
  String get registerSubtitle => 'Renseignez vos informations pour démarrer';

  @override
  String get nomLabel => 'Nom';

  @override
  String get nomHint => 'Benali';

  @override
  String get prenomLabel => 'Prénom';

  @override
  String get prenomHint => 'Hassan';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get phoneHint => '0612345678';

  @override
  String get iceLabel => 'ICE (Maroc)';

  @override
  String get iceHint => '001234567000 (optionnel)';

  @override
  String get requiredField => 'Requis';

  @override
  String get statutFiscalLabel => 'Statut fiscal';

  @override
  String get statutFiscalHint => 'Sélectionner un statut';

  @override
  String get statutAutoEntrepreneur => 'Auto-entrepreneur';

  @override
  String get statutTpe => 'TPE';

  @override
  String get statutArtisan => 'Artisan';

  @override
  String get statutFreelance => 'Freelance';

  @override
  String get statutCommercant => 'Commerçant';

  @override
  String get createAccountButton => 'Créer mon compte';

  @override
  String get accountCreatedSuccess => 'Compte créé ! Connectez-vous.';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? ';

  @override
  String get loginLink => 'Se connecter';

  @override
  String get verifyCodeTitle => 'Vérification du code';

  @override
  String get verifyCodeSubtitle => 'Entrez le code à 6 chiffres envoyé à ';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get codeResentMessage => 'Nouveau code envoyé';

  @override
  String get registerAppBarTitle => 'Créer un compte';

  @override
  String get registerWelcomeTitle => 'Bienvenue';

  @override
  String get registerWelcomeSubtitle =>
      'Renseignez vos informations pour démarrer';

  @override
  String get lastNameLabel => 'Nom';

  @override
  String get lastNameHint => 'Benali';

  @override
  String get firstNameLabel => 'Prénom';

  @override
  String get firstNameHint => 'Hassan';

  @override
  String get fiscalStatusLabel => 'Statut Fiscal';

  @override
  String get fiscalStatusHint => 'Sélectionner un statut';

  @override
  String get registerButton => 'Créer mon compte';

  @override
  String get registerSuccessMessage => 'Compte créé ! Connectez-vous.';

  @override
  String get loginAction => 'Se connecter';

  @override
  String get statusAutoEntrepreneur => 'Auto-entrepreneur';

  @override
  String get statusTpe => 'TPE';

  @override
  String get statusArtisan => 'Artisan';

  @override
  String get statusFreelance => 'Freelance';

  @override
  String get statusCommercant => 'Commerçant';

  @override
  String get codeResentSuccess => 'Nouveau code envoyé';

  @override
  String get resendCodeAction => 'Renvoyer le code';

  @override
  String get cashflowAppBarTitle => 'Trésorerie';

  @override
  String selectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get multipleDeletionTitle => 'Suppression multiple';

  @override
  String multipleDeletionContent(int count) {
    return 'Voulez-vous vraiment supprimer les $count transactions sélectionnées ?';
  }

  @override
  String get cancelAction => 'Annuler';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get tabAll => 'Tout';

  @override
  String get tabRecettes => 'Recettes';

  @override
  String get tabDepenses => 'Dépenses';

  @override
  String get availableBalanceLabel => 'Solde disponible';

  @override
  String get noTransactions => 'Aucune transaction';

  @override
  String get paymentRecordedSuccess => 'Paiement enregistré ✓';

  @override
  String get expenseRecordedSuccess => 'Dépense enregistrée ✓';

  @override
  String get selectCategoryError => 'Veuillez sélectionner une catégorie';

  @override
  String get registerPaymentTitle => 'Enregistrer un paiement';

  @override
  String get newTransactionTitle => 'Nouvelle transaction';

  @override
  String get paymentLinkedToInvoice => 'Paiement lié à la facture';

  @override
  String get registerPaymentOrExpenseSubtitle =>
      'Enregistrez un paiement ou une dépense';

  @override
  String get transactionTypeLabel => 'Type de transaction';

  @override
  String get paymentReceivedType => 'Paiement reçu';

  @override
  String get expenseType => 'Dépense';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get catPaymentInvoice => 'Paiement facture';

  @override
  String get catDeposit => 'Acompte';

  @override
  String get catOtherIncome => 'Autre recette';

  @override
  String get catEquipmentPurchase => 'Achat matériel';

  @override
  String get catRent => 'Loyer';

  @override
  String get catSalary => 'Salaire';

  @override
  String get catTransport => 'Transport';

  @override
  String get catOtherExpense => 'Autre dépense';

  @override
  String get amountDhLabel => 'Montant (DH)';

  @override
  String get fieldRequiredError => 'Ce champ est obligatoire';

  @override
  String get invalidAmountError => 'Montant invalide';

  @override
  String get greaterThanZeroError => 'Doit être > 0';

  @override
  String get amountHint => 'Ex : 1500.00';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionRecetteHint => 'Ex : Paiement facture FAC-2026-001';

  @override
  String get descriptionDepenseHint => 'Ex : Achat fournitures bureau';

  @override
  String get transactionDateLabel => 'Date de transaction';

  @override
  String get savePaymentButton => 'Enregistrer le paiement';

  @override
  String get saveExpenseButton => 'Enregistrer la dépense';

  @override
  String get transactionAmountLabel => 'Montant de la transaction';

  @override
  String get paymentDateLabel => 'Date du paiement';

  @override
  String get justificationLabel => 'Justificatif';

  @override
  String get invoiceLoadError => 'Impossible de charger le lien de la facture.';

  @override
  String get viewInvoiceLabel => 'Voir la facture';

  @override
  String get editClientTitle => 'Modifier le Client';

  @override
  String get newClientTitle => 'Nouveau Client';

  @override
  String get clientCreatedSuccess => 'Client créé avec succès !';

  @override
  String get clientUpdatedSuccess => 'Client mis à jour !';

  @override
  String get companyNameLabel => 'Nom de l\'entreprise';

  @override
  String get companyNameHint => 'Ma Société (optionnel)';

  @override
  String get emailAddressLabel => 'Adresse Email';

  @override
  String get emailAddressHint => 'client@email.com';

  @override
  String get invalidEmailError => 'Adresse email invalide';

  @override
  String get saveChangesButton => 'Enregistrer les modifications';

  @override
  String get createClientButton => 'Créer le client';

  @override
  String get clientsTitle => 'Clients';

  @override
  String get searchClientHint => 'Rechercher par nom, entreprise...';

  @override
  String get clientDeletedSuccess => 'Client supprimé avec succès';

  @override
  String get noClientsFound => 'Aucun client trouvé';

  @override
  String get deleteClientTitle => 'Supprimer le client';

  @override
  String get deleteClientConfirmation =>
      'Êtes-vous sûr ? Cela peut impacter les devis associés à ce client.';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get deleteButton => 'Supprimer';

  @override
  String get editOption => 'Modifier';

  @override
  String get deleteOption => 'Supprimer';

  @override
  String get newClientOption => 'Nouveau client';

  @override
  String get selectClientPrompt => 'Sélectionner un client';

  @override
  String get noClientsAvailable => 'Aucun client disponible';

  @override
  String get financingTitle => 'Financement';

  @override
  String get deleteRequestTitle => 'Supprimer la demande';

  @override
  String get deleteRequestConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cette demande de financement ? Cette action est irréversible.';

  @override
  String get eligibilityTitle => 'Votre éligibilité';

  @override
  String get improveScoreTipsTitle => 'Conseils pour améliorer votre score';

  @override
  String get myRequestsTitle => 'Mes demandes';

  @override
  String get requestDeletedSuccess => 'Demande supprimée';

  @override
  String get noFinancingRequests => 'Aucune demande de financement';

  @override
  String get newRequestAppBarTitle => 'Nouvelle demande';

  @override
  String get consentRequiredError =>
      'Vous devez accepter la transmission de vos données.';

  @override
  String get requestSubmittedSuccess => 'Demande soumise avec succès !';

  @override
  String get typeFinancementLabel => 'Type de financement';

  @override
  String get creditFonctionnementLabel => 'Crédit de fonctionnement';

  @override
  String get creditInvestissementLabel => 'Crédit d\'investissement';

  @override
  String get avanceFactureLabel => 'Avance sur factures';

  @override
  String get plafondLabel => 'Plafond';

  @override
  String get montantDemandeLabel => 'Montant demandé (DH)';

  @override
  String get invalidAmount => 'Montant invalide';

  @override
  String get mustBeGreaterThanZero => 'Doit être > 0';

  @override
  String get montantHint => 'Ex : 50000';

  @override
  String get dureeSouhaiteeLabel => 'Durée souhaitée';

  @override
  String get monthsLabel => 'mois';

  @override
  String get objetFinancementLabel => 'Objet du financement';

  @override
  String get objetHint => 'Décrivez l\'utilisation prévue des fonds...';

  @override
  String get cndpConsentText =>
      'J\'accepte la transmission de mes données financières aux partenaires financiers conformément à la réglementation CNDP.';

  @override
  String get submitRequestButton => 'Soumettre la demande';

  @override
  String get requestDetailTitle => 'Détail de la demande';

  @override
  String get documentTypeLabel => 'Type de document';

  @override
  String get bankStatementLabel => 'Relevé bancaire';

  @override
  String get documentAddedSuccess => 'Document ajouté avec succès';

  @override
  String get overMonthsPrefix => 'Sur';

  @override
  String get rejectionReasonLabel => 'Motif de refus';

  @override
  String get justificatifsLabel => 'Justificatifs';

  @override
  String get addButton => 'Ajouter';

  @override
  String get noDocumentsAdded => 'Aucun document ajouté';

  @override
  String get receivedOffersLabel => 'Offres reçues';

  @override
  String get rateLabel => 'Taux';

  @override
  String get estimatedMonthlyPaymentLabel => 'Mensualité';

  @override
  String get unableToOpenPortalError =>
      'Impossible d\'ouvrir le portail partenaire';

  @override
  String get finalizeOnPortalButton => 'Finaliser sur le portail';

  @override
  String get reasonLabel => 'Motif';

  @override
  String get eligibilityHigh => 'Éligibilité élevée';

  @override
  String get eligibilityMedium => 'Éligibilité moyenne';

  @override
  String get eligibilityLow => 'Éligibilité faible';

  @override
  String get eligibilityNotEvaluated => 'Non évalué';

  @override
  String get statusSoumise => 'Soumise';

  @override
  String get statusEnAnalyse => 'En analyse';

  @override
  String get statusFavorable => 'Favorable';

  @override
  String get statusDefavorable => 'Défavorable';

  @override
  String get statusIncomplet => 'Incomplet';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get monthlyIncomeLabel => 'Recettes du mois';

  @override
  String get monthlyExpensesLabel => 'Dépenses du mois';

  @override
  String get flowAnalysisTitle => 'Analyse des flux';

  @override
  String get flowVolumeLabel => 'Volume des flux';

  @override
  String get incomeLegendLabel => 'Recettes';

  @override
  String get expensesLegendLabel => 'Dépenses';

  @override
  String get currentBalanceLabel => 'Solde actuel';

  @override
  String get positiveStatusLabel => 'Positif';

  @override
  String get negativeStatusLabel => 'Négatif';

  @override
  String get quoteActivityTitle => 'Activité des devis';

  @override
  String get totalQuotesGeneratedLabel => 'Total des devis générés';

  @override
  String get conversionRateLabel => 'Conversion';

  @override
  String get quoteStatusAccepted => 'Acceptés';

  @override
  String get quoteStatusPending => 'En attente';

  @override
  String get quoteStatusRefused => 'Refusés';

  @override
  String get quoteStatusExpired => 'Expirés';

  @override
  String get newQuoteTitle => 'Nouveau Devis';

  @override
  String get selectClientError => 'Veuillez sélectionner un client';

  @override
  String get selectValidityDateError =>
      'Veuillez sélectionner une date de validité';

  @override
  String get selectAtLeastOneLineError =>
      'Veuillez ajouter au moins une ligne de prestation';

  @override
  String quoteCreatedSuccess(String numero) {
    return 'Devis $numero créé !';
  }

  @override
  String get clientLabel => 'Client';

  @override
  String get validUntilLabel => 'Valable jusqu\'au';

  @override
  String get selectValidityDateHint => 'Sélectionner une date de validité';

  @override
  String get vatRateLabel => 'Taux de TVA (%)';

  @override
  String get vatRateHint => 'Ex : 20';

  @override
  String get paymentMethodLabel => 'Mode de paiement';

  @override
  String get addProductsOrServicesLabel => 'Ajouter des produits / prestations';

  @override
  String get addedItemsLabel => 'Éléments ajoutés';

  @override
  String get specialConditionsOptionalLabel =>
      'Conditions particulières (optionnel)';

  @override
  String get specialConditionsHint => 'Ex : Règlement sous 30 jours...';

  @override
  String get createQuoteButton => 'Créer le devis';

  @override
  String get quoteDetailTitle => 'Détail du Devis';

  @override
  String get quoteConvertedSuccess => 'Devis converti en facture avec succès';

  @override
  String get generalInformationTitle => 'Informations générales';

  @override
  String get validUntilPrefix => 'Valable jusqu\'au';

  @override
  String get paymentLabel => 'Règlement';

  @override
  String get servicesSectionTitle => 'Prestations';

  @override
  String get financialSummaryTitle => 'Résumé financier';

  @override
  String get totalHtLabel => 'Total HT';

  @override
  String vatLabel(num rate) {
    return 'TVA ($rate%)';
  }

  @override
  String get totalTtcLabel => 'Total TTC';

  @override
  String get linkedInvoiceTitle => 'Facture liée';

  @override
  String get linkedInvoiceDefault => 'Facture liée';

  @override
  String get quoteConvertedToInvoiceInfo =>
      'Ce devis a été converti en facture';

  @override
  String get viewButton => 'Voir';

  @override
  String get specialConditionsTitle => 'Conditions particulières';

  @override
  String get availableActionsTitle => 'Actions disponibles';

  @override
  String get editQuoteAction => 'Modifier le devis';

  @override
  String get markAsSentAction => 'Marquer comme Envoyé';

  @override
  String get deleteQuoteTitle => 'Supprimer le devis';

  @override
  String get remindClientAction => 'Relancer le client';

  @override
  String get markAsAcceptedAction => 'Marquer comme Accepté';

  @override
  String get markAsRefusedAction => 'Marquer comme Refusé';

  @override
  String get resetToDraftAction => 'Remettre en Brouillon';

  @override
  String get convertToInvoiceAction => 'Convertir en facture';

  @override
  String get convertToInvoiceDialogTitle => 'Convertir en facture';

  @override
  String get convertToInvoiceDialogContent =>
      'Un brouillon de facture sera créé à partir de ce devis. Continuer ?';

  @override
  String get convertButton => 'Convertir';

  @override
  String get duplicateQuoteAction => 'Dupliquer le devis';

  @override
  String get archiveQuoteAction => 'Archiver le devis';

  @override
  String get downloadSharePdfAction => 'Télécharger / Partager le PDF';

  @override
  String get editQuoteTitle => 'Modifier le Devis';

  @override
  String quoteUpdatedSuccess(String numero) {
    return 'Devis $numero mis à jour avec succès !';
  }

  @override
  String get backToDetailButton => 'Retour au détail';

  @override
  String get editDraftNotice =>
      'Vous modifiez actuellement un brouillon de devis. Les modifications seront enregistrées immédiatement.';

  @override
  String get paymentModeCash => 'Espèces';

  @override
  String get paymentModeBankTransfer => 'Virement';

  @override
  String get paymentModeMobileMoney => 'Mobile Money';

  @override
  String get quotesListTitle => 'Devis';

  @override
  String get activeTabLabel => 'Actifs';

  @override
  String get archivedTabLabel => 'Archivés';

  @override
  String get clearAllFiltersButton => 'Tout effacer';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterDrafts => 'Brouillons';

  @override
  String get filterSent => 'Envoyées';

  @override
  String get filterAccepted => 'Acceptés';

  @override
  String get filterRefused => 'Refusés';

  @override
  String get filterExpired => 'Expirés';

  @override
  String get quoteDeletedSuccessMessage => 'Devis supprimé';

  @override
  String get quoteDuplicatedSuccessMessage => 'Devis dupliqué';

  @override
  String get noArchivedQuotesFound => 'Aucun devis archivé';

  @override
  String get noQuotesFound => 'Aucun devis trouvé';

  @override
  String get clearFiltersButton => 'Effacer les filtres';

  @override
  String get deleteQuoteDialogTitle => 'Supprimer le devis';

  @override
  String get deleteQuoteDialogContent =>
      'Êtes-vous sûr de vouloir supprimer ce devis ?';

  @override
  String get filtersTitle => 'Filtres';

  @override
  String get resetFilterButton => 'Réinitialiser';

  @override
  String get refineQuotesSubtitle => 'Affiner la liste des devis';

  @override
  String get clientFilterLabel => 'Client';

  @override
  String get allClientsOption => 'Tous les clients';

  @override
  String get periodFilterLabel => 'Période';

  @override
  String get startDatePlaceholder => 'Date début';

  @override
  String get endDatePlaceholder => 'Date fin';

  @override
  String get applyFiltersButton => 'Appliquer les filtres';

  @override
  String validUntilCardLabel(String date) {
    return 'Valide : $date';
  }

  @override
  String get statusDraft => 'Brouillon';

  @override
  String get statusSent => 'Envoyée';

  @override
  String get statusAccepted => 'Accepté';

  @override
  String get statusRefused => 'Refusé';

  @override
  String get statusExpired => 'Expiré';

  @override
  String get statusArchived => 'Annulée';

  @override
  String get newInvoiceTitle => 'Nouvelle Facture';

  @override
  String invoiceCreatedDraftSuccess(String numero) {
    return 'Facture $numero créée en brouillon !';
  }

  @override
  String get selectDueDateError => 'Veuillez sélectionner une date d\'échéance';

  @override
  String get dueDateLabel => 'Date d\'échéance';

  @override
  String get selectDueDateHint => 'Sélectionner la date limite de règlement';

  @override
  String get paymentMethodRequiredLabel => 'Mode de règlement requis';

  @override
  String get addedBillingItemsLabel => 'Éléments de facturation ajoutés';

  @override
  String get paymentConditionsLegalMentionsLabel =>
      'Conditions de règlement ou mentions légales';

  @override
  String get paymentConditionsHint =>
      'Ex : Pénalités de retard de 10% après échéance...';

  @override
  String get generateInvoiceButton => 'Générer la facture';

  @override
  String invoicePaymentDescription(String numero) {
    return 'Paiement facture $numero';
  }

  @override
  String get invoiceDetailTitle => 'Détail de la Facture';

  @override
  String get invoiceUpdatedSuccess => 'Facture mise à jour';

  @override
  String get invoiceArchivedSuccess => 'Facture annulée';

  @override
  String get generalInfoSection => 'Informations générales';

  @override
  String dueDateRowLabel(String date) {
    return 'Date d\'échéance : $date';
  }

  @override
  String paymentMethodRowLabel(String method) {
    return 'Mode de règlement : $method';
  }

  @override
  String get prestationsSection => 'Prestations';

  @override
  String get financialSummarySection => 'Résumé financier';

  @override
  String get amountPaidLabel => 'Montant Payé';

  @override
  String get remainingDueLabel => 'Reste à payer';

  @override
  String issuedFromQuoteLabel(String numero) {
    return 'Issu du devis $numero';
  }

  @override
  String get availableActionsSection => 'Actions disponibles';

  @override
  String get editInvoiceButton => 'Modifier la facture';

  @override
  String get validateAndSendButton => 'Valider et Envoyer';

  @override
  String get deleteInvoiceDialogTitle => 'Supprimer la facture';

  @override
  String get registerPaymentButton => 'Enregistrer un paiement';

  @override
  String get remindForUnpaidButton => 'Relancer pour impayé';

  @override
  String toBePaidBeforeDate(String date) {
    return 'à régler avant le $date';
  }

  @override
  String get asSoonAsPossible => 'dès que possible';

  @override
  String get archiveInvoiceButton => 'Annuler la facture';

  @override
  String get archiveInvoiceDialogTitle => 'Annuler la facture';

  @override
  String get archiveInvoiceDialogContent =>
      'Cette facture sera déplacée dans les factures annulées. Continuer ?';

  @override
  String get archiveButton => 'Continuer';

  @override
  String get downloadOrSharePdfButton => 'Télécharger / Partager le PDF';

  @override
  String get invoicesTitle => 'Factures';

  @override
  String get tabActive => 'Actives';

  @override
  String get tabArchived => 'Annulées';

  @override
  String get filterPaid => 'Payées';

  @override
  String get filterPartial => 'Partielles';

  @override
  String get filterArchived => 'Archivées';

  @override
  String get invoiceDeletedSuccess => 'Facture supprimée';

  @override
  String get noArchivedInvoicesFound => 'Aucune facture archivée';

  @override
  String get noInvoicesFound => 'Aucune facture trouvée';

  @override
  String get deleteInvoiceDialogContent =>
      'Êtes-vous sûr de vouloir supprimer cette facture ?';

  @override
  String get statusPaid => 'Payée';

  @override
  String get statusPartial => 'Partielle';

  @override
  String get statusPending => 'En attente';

  @override
  String get unknownNumber => 'N° Inconnu';

  @override
  String get unknownClient => 'Client inconnu';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String selectedCountTitle(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get deleteNotificationsDialogTitle => 'Supprimer les notifications';

  @override
  String deleteNotificationsDialogContent(int count) {
    return 'Voulez-vous vraiment supprimer les $count notifications sélectionnées ?';
  }

  @override
  String markAllAsReadButton(int count) {
    return 'Tout marquer comme lu ($count)';
  }

  @override
  String get emptyNotificationsTitle => 'Votre historique est propre';

  @override
  String get emptyNotificationsSubtitle =>
      'Nous vous préviendrons dès qu\'une facture ou un devis nécessitera votre attention.';

  @override
  String get closeButton => 'Fermer';

  @override
  String get timeJustNow => 'À l\'instant';

  @override
  String timeMinutesAgo(int minutes) {
    return 'Il y a $minutes min';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'Il y a $hours h';
  }

  @override
  String timeDaysAgo(int days) {
    return 'Il y a $days j';
  }

  @override
  String get fillAllEmailFieldsError =>
      'Veuillez remplir tous les champs email';

  @override
  String get emailConfigSavedSuccess => 'Configuration email enregistrée !';

  @override
  String errorPrefix(String error) {
    return 'Erreur : $error';
  }

  @override
  String get profileUpdatedSuccess => 'Coordonnées mises à jour !';

  @override
  String get passwordChangedSuccess => 'Mot de passe changé avec succès !';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get editCoordinatesHeader => 'Modifier mes coordonnées';

  @override
  String get saveProfileButton => 'Enregistrer le profil';

  @override
  String get smtpConfigHeader => 'Configuration SMTP Email';

  @override
  String get smtpGoogleInfoHint =>
      'Validation 2 étapes Google requise. Utilisez un \"Mot de passe d\'application\" généré sur votre compte Google.';

  @override
  String get profGmailLabel => 'Adresse Gmail Professionnelle';

  @override
  String get googleAppPasswordLabel => 'Mot de passe d\'application Google';

  @override
  String get linkingButton => 'Liaison...';

  @override
  String get linkGmailButton => 'Lier mon compte Gmail';

  @override
  String get autoRemindersHeader => 'Rappels automatiques';

  @override
  String get unpaidInvoiceReminderTitle => 'Rappel facture impayée';

  @override
  String get unpaidInvoiceReminderSubtitle =>
      'Vous serez averti des factures en retard';

  @override
  String get reminderAfterLabel => 'Envoyer un rappel après';

  @override
  String get expiringQuoteReminderTitle => 'Rappel devis expirant';

  @override
  String get expiringQuoteReminderSubtitle =>
      'Alerte avant expiration du devis';

  @override
  String get warnBeforeExpirationLabel => 'M\'avertir avant expiration';

  @override
  String get taxDeclarationReminderTitle => 'Rappel déclaration fiscale';

  @override
  String get taxDeclarationReminderSubtitle =>
      'Rappel trimestriel auto-entrepreneur / TPE';

  @override
  String get cnssReminderTitle => 'Rappel cotisation CNSS';

  @override
  String get cnssReminderSubtitle =>
      'Rappel mensuel de paiement de cotisations';

  @override
  String get creditRequestNotifTitle => 'Notifications demande de crédit';

  @override
  String get creditRequestNotifSubtitle =>
      'Changement de statut de dossier de crédit';

  @override
  String get receptionModesHeader => 'Modes de réception';

  @override
  String get inAppNotifTitle => 'Notification dans l\'application';

  @override
  String get pushNotifTitle => 'Notification Push';

  @override
  String get smsNotifTitle => 'SMS';

  @override
  String get smsNotifSubtitle => 'Frais opérateur possibles';

  @override
  String get noPreferencesFound => 'Aucune préférence trouvée.';

  @override
  String get savingLabel => 'Sauvegarde...';

  @override
  String get securityButton => 'Sécurité';

  @override
  String get logoutButton => 'Déconnexion';

  @override
  String get passwordsDoNotMatchError =>
      'Les mots de passe ne correspondent pas';

  @override
  String get changePasswordTitle => 'Modifier le mot de passe';

  @override
  String get changePasswordSubtitle =>
      'Choisissez un mot de passe sécurisé d\'au moins 8 caractères.';

  @override
  String get oldPasswordLabel => 'Ancien mot de passe';

  @override
  String get confirmNewPasswordLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get requiredFieldError => 'Requis';

  @override
  String minCharactersError(int count) {
    return 'Minimum $count caractères';
  }

  @override
  String get validateButton => 'Valider';

  @override
  String get deleteConfirmationMessage =>
      'Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible.';

  @override
  String get openPdfOption => 'Ouvrir le PDF';

  @override
  String get sharePdfOption => 'Partager (WhatsApp, Email...)';

  @override
  String documentSubject(String numero) {
    return 'Document $numero';
  }

  @override
  String documentShareText(String numero) {
    return 'Veuillez trouver ci-joint le document $numero.';
  }

  @override
  String get remindClientTitle => 'Relancer le client';

  @override
  String get sendViaWhatsApp => 'Envoyer via WhatsApp';

  @override
  String get noPhoneNumber => 'Aucun numéro';

  @override
  String whatsappReminderMessage(
    String clientNom,
    String docNumero,
    String montant,
    String dateInfo,
  ) {
    return 'Bonjour $clientNom,\n\nNous espérons que vous allez bien.\n\nNous vous rappelons que le document *$docNumero* d\'un montant de *$montant* ($dateInfo) est toujours en attente.\n\nMerci de bien vouloir le consulter dès que possible.\n\nCordialement,\nTPE Manager';
  }

  @override
  String get sendViaEmail => 'Envoyer par Email';

  @override
  String get noEmailAddress => 'Aucune adresse';

  @override
  String emailReminderSubject(String docNumero) {
    return 'Rappel - $docNumero';
  }

  @override
  String emailReminderBody(
    String clientNom,
    String docNumero,
    String montant,
    String dateInfo,
  ) {
    return 'Bonjour $clientNom,\n\nNous espérons que vous allez bien.\n\nNous vous rappelons que le document $docNumero d\'un montant de $montant ($dateInfo) est toujours en attente.\n\nNous vous remercions de bien vouloir effectuer les démarches nécessaires.\n\nCordialement,\nL\'équipe TPE Manager';
  }

  @override
  String get navHome => 'Accueil';

  @override
  String get navDevis => 'Devis';

  @override
  String get navFactures => 'Factures';

  @override
  String get navTresorerie => 'Trésorerie';

  @override
  String get navCredit => 'Crédit';

  @override
  String get selectDateHint => 'Sélectionner une date';

  @override
  String get addLineTitle => 'Ajouter une ligne';

  @override
  String get designationLabel => 'Désignation / Description';

  @override
  String get unitPriceLabel => 'Prix unitaire (DH)';

  @override
  String get quantityLabel => 'Quantité';

  @override
  String totalLineDisplay(String total) {
    return 'Total : $total DH';
  }

  @override
  String get addToDocumentButton => 'Ajouter au document';

  @override
  String get paymentVirementLabel => 'Virement';

  @override
  String get paymentVirementSub => 'Bancaire';

  @override
  String get paymentEspecesLabel => 'Espèces';

  @override
  String get paymentEspecesSub => 'En main propre';

  @override
  String get paymentMobileLabel => 'Mobile';

  @override
  String get paymentMobileSub => 'Money';

  @override
  String get languageLabel => 'Langue';

  @override
  String get conseilVolumeEleve =>
      'Augmentez votre volume de facturation pour améliorer votre score.';

  @override
  String get conseilVolumeFaible =>
      'Votre volume de facturation est encore faible.';

  @override
  String get conseilVolumeDebut =>
      'Commencez à facturer régulièrement pour construire votre historique.';

  @override
  String get conseilAncienneteRecente =>
      'Votre compte est encore récent. L\'ancienneté améliore l\'éligibilité.';

  @override
  String get conseilAncienneteSuite =>
      'Continuez à utiliser l\'application pour augmenter votre ancienneté.';

  @override
  String get conseilFacturesAttente =>
      'Régularisez vos factures en attente pour améliorer votre score.';

  @override
  String get conseilFacturesImpayees =>
      'Trop de factures impayées. Régularisez-les en priorité.';

  @override
  String get conseilFacturesAbsentes =>
      'Émettez et encaissez des factures pour évaluer votre régularité.';

  @override
  String get conseilProfilFiscal =>
      'Complétez votre profil fiscal pour améliorer votre éligibilité.';

  @override
  String get searchTransactionsHint => 'Rechercher une transaction...';

  @override
  String get noSearchResults => 'Aucun résultat trouvé';

  @override
  String get archiveMotifLabel => 'Motif d\'annulation';

  @override
  String get archiveMotifHint =>
      'Expliquez pourquoi cette facture est annulée...';
}
