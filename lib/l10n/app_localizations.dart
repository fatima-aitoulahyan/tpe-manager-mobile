import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour gérer votre activité'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In fr, this message translates to:
  /// **'vous@exemple.com'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In fr, this message translates to:
  /// **'Email requis'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe requis'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 8 caractères'**
  String get passwordMinLength;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @orDivider.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get orDivider;

  /// No description provided for @noAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? '**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre email. Nous vous enverrons un code pour réinitialiser votre mot de passe.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendCode.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le code'**
  String get sendCode;

  /// No description provided for @newPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPasswordTitle;

  /// No description provided for @newPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un mot de passe sécurisé d\'au moins 8 caractères.'**
  String get newPasswordSubtitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPasswordLabel;

  /// No description provided for @fieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get fieldRequired;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get passwordsDontMatch;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe réinitialisé avec succès !'**
  String get passwordResetSuccess;

  /// No description provided for @resetButton.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get resetButton;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Renseignez vos informations pour démarrer'**
  String get registerSubtitle;

  /// No description provided for @nomLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get nomLabel;

  /// No description provided for @nomHint.
  ///
  /// In fr, this message translates to:
  /// **'Benali'**
  String get nomHint;

  /// No description provided for @prenomLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get prenomLabel;

  /// No description provided for @prenomHint.
  ///
  /// In fr, this message translates to:
  /// **'Hassan'**
  String get prenomHint;

  /// No description provided for @phoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In fr, this message translates to:
  /// **'0612345678'**
  String get phoneHint;

  /// No description provided for @iceLabel.
  ///
  /// In fr, this message translates to:
  /// **'ICE (Maroc)'**
  String get iceLabel;

  /// No description provided for @iceHint.
  ///
  /// In fr, this message translates to:
  /// **'001234567000 (optionnel)'**
  String get iceHint;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get requiredField;

  /// No description provided for @statutFiscalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Statut fiscal'**
  String get statutFiscalLabel;

  /// No description provided for @statutFiscalHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un statut'**
  String get statutFiscalHint;

  /// No description provided for @statutAutoEntrepreneur.
  ///
  /// In fr, this message translates to:
  /// **'Auto-entrepreneur'**
  String get statutAutoEntrepreneur;

  /// No description provided for @statutTpe.
  ///
  /// In fr, this message translates to:
  /// **'TPE'**
  String get statutTpe;

  /// No description provided for @statutArtisan.
  ///
  /// In fr, this message translates to:
  /// **'Artisan'**
  String get statutArtisan;

  /// No description provided for @statutFreelance.
  ///
  /// In fr, this message translates to:
  /// **'Freelance'**
  String get statutFreelance;

  /// No description provided for @statutCommercant.
  ///
  /// In fr, this message translates to:
  /// **'Commerçant'**
  String get statutCommercant;

  /// No description provided for @createAccountButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get createAccountButton;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Compte créé ! Connectez-vous.'**
  String get accountCreatedSuccess;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginLink;

  /// No description provided for @verifyCodeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification du code'**
  String get verifyCodeTitle;

  /// No description provided for @verifyCodeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code à 6 chiffres envoyé à '**
  String get verifyCodeSubtitle;

  /// No description provided for @resendCode.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get resendCode;

  /// No description provided for @codeResentMessage.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau code envoyé'**
  String get codeResentMessage;

  /// No description provided for @registerAppBarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registerAppBarTitle;

  /// No description provided for @registerWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get registerWelcomeTitle;

  /// No description provided for @registerWelcomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Renseignez vos informations pour démarrer'**
  String get registerWelcomeSubtitle;

  /// No description provided for @lastNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get lastNameLabel;

  /// No description provided for @lastNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Benali'**
  String get lastNameHint;

  /// No description provided for @firstNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get firstNameLabel;

  /// No description provided for @firstNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Hassan'**
  String get firstNameHint;

  /// No description provided for @fiscalStatusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Statut Fiscal'**
  String get fiscalStatusLabel;

  /// No description provided for @fiscalStatusHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un statut'**
  String get fiscalStatusHint;

  /// No description provided for @registerButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get registerButton;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In fr, this message translates to:
  /// **'Compte créé ! Connectez-vous.'**
  String get registerSuccessMessage;

  /// No description provided for @loginAction.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginAction;

  /// No description provided for @statusAutoEntrepreneur.
  ///
  /// In fr, this message translates to:
  /// **'Auto-entrepreneur'**
  String get statusAutoEntrepreneur;

  /// No description provided for @statusTpe.
  ///
  /// In fr, this message translates to:
  /// **'TPE'**
  String get statusTpe;

  /// No description provided for @statusArtisan.
  ///
  /// In fr, this message translates to:
  /// **'Artisan'**
  String get statusArtisan;

  /// No description provided for @statusFreelance.
  ///
  /// In fr, this message translates to:
  /// **'Freelance'**
  String get statusFreelance;

  /// No description provided for @statusCommercant.
  ///
  /// In fr, this message translates to:
  /// **'Commerçant'**
  String get statusCommercant;

  /// No description provided for @codeResentSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau code envoyé'**
  String get codeResentSuccess;

  /// No description provided for @resendCodeAction.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get resendCodeAction;

  /// No description provided for @cashflowAppBarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Trésorerie'**
  String get cashflowAppBarTitle;

  /// No description provided for @selectedCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} sélectionné(s)'**
  String selectedCount(int count);

  /// No description provided for @multipleDeletionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Suppression multiple'**
  String get multipleDeletionTitle;

  /// No description provided for @multipleDeletionContent.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer les {count} transactions sélectionnées ?'**
  String multipleDeletionContent(int count);

  /// No description provided for @cancelAction.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelAction;

  /// No description provided for @deleteAction.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteAction;

  /// No description provided for @tabAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get tabAll;

  /// No description provided for @tabRecettes.
  ///
  /// In fr, this message translates to:
  /// **'Recettes'**
  String get tabRecettes;

  /// No description provided for @tabDepenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses'**
  String get tabDepenses;

  /// No description provided for @availableBalanceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Solde disponible'**
  String get availableBalanceLabel;

  /// No description provided for @noTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction'**
  String get noTransactions;

  /// No description provided for @paymentRecordedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Paiement enregistré ✓'**
  String get paymentRecordedSuccess;

  /// No description provided for @expenseRecordedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Dépense enregistrée ✓'**
  String get expenseRecordedSuccess;

  /// No description provided for @selectCategoryError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une catégorie'**
  String get selectCategoryError;

  /// No description provided for @registerPaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer un paiement'**
  String get registerPaymentTitle;

  /// No description provided for @newTransactionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle transaction'**
  String get newTransactionTitle;

  /// No description provided for @paymentLinkedToInvoice.
  ///
  /// In fr, this message translates to:
  /// **'Paiement lié à la facture'**
  String get paymentLinkedToInvoice;

  /// No description provided for @registerPaymentOrExpenseSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez un paiement ou une dépense'**
  String get registerPaymentOrExpenseSubtitle;

  /// No description provided for @transactionTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de transaction'**
  String get transactionTypeLabel;

  /// No description provided for @paymentReceivedType.
  ///
  /// In fr, this message translates to:
  /// **'Paiement reçu'**
  String get paymentReceivedType;

  /// No description provided for @expenseType.
  ///
  /// In fr, this message translates to:
  /// **'Dépense'**
  String get expenseType;

  /// No description provided for @categoryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get categoryLabel;

  /// No description provided for @catPaymentInvoice.
  ///
  /// In fr, this message translates to:
  /// **'Paiement facture'**
  String get catPaymentInvoice;

  /// No description provided for @catDeposit.
  ///
  /// In fr, this message translates to:
  /// **'Acompte'**
  String get catDeposit;

  /// No description provided for @catOtherIncome.
  ///
  /// In fr, this message translates to:
  /// **'Autre recette'**
  String get catOtherIncome;

  /// No description provided for @catEquipmentPurchase.
  ///
  /// In fr, this message translates to:
  /// **'Achat matériel'**
  String get catEquipmentPurchase;

  /// No description provided for @catRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer'**
  String get catRent;

  /// No description provided for @catSalary.
  ///
  /// In fr, this message translates to:
  /// **'Salaire'**
  String get catSalary;

  /// No description provided for @catTransport.
  ///
  /// In fr, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catOtherExpense.
  ///
  /// In fr, this message translates to:
  /// **'Autre dépense'**
  String get catOtherExpense;

  /// No description provided for @amountDhLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant (DH)'**
  String get amountDhLabel;

  /// No description provided for @fieldRequiredError.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire'**
  String get fieldRequiredError;

  /// No description provided for @invalidAmountError.
  ///
  /// In fr, this message translates to:
  /// **'Montant invalide'**
  String get invalidAmountError;

  /// No description provided for @greaterThanZeroError.
  ///
  /// In fr, this message translates to:
  /// **'Doit être > 0'**
  String get greaterThanZeroError;

  /// No description provided for @amountHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : 1500.00'**
  String get amountHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionRecetteHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : Paiement facture FAC-2026-001'**
  String get descriptionRecetteHint;

  /// No description provided for @descriptionDepenseHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : Achat fournitures bureau'**
  String get descriptionDepenseHint;

  /// No description provided for @transactionDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date de transaction'**
  String get transactionDateLabel;

  /// No description provided for @savePaymentButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le paiement'**
  String get savePaymentButton;

  /// No description provided for @saveExpenseButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la dépense'**
  String get saveExpenseButton;

  /// No description provided for @transactionAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant de la transaction'**
  String get transactionAmountLabel;

  /// No description provided for @paymentDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date du paiement'**
  String get paymentDateLabel;

  /// No description provided for @justificationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Justificatif'**
  String get justificationLabel;

  /// No description provided for @invoiceLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le lien de la facture.'**
  String get invoiceLoadError;

  /// No description provided for @viewInvoiceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Voir la facture'**
  String get viewInvoiceLabel;

  /// No description provided for @editClientTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le Client'**
  String get editClientTitle;

  /// No description provided for @newClientTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau Client'**
  String get newClientTitle;

  /// No description provided for @clientCreatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Client créé avec succès !'**
  String get clientCreatedSuccess;

  /// No description provided for @clientUpdatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Client mis à jour !'**
  String get clientUpdatedSuccess;

  /// No description provided for @companyNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'entreprise'**
  String get companyNameLabel;

  /// No description provided for @companyNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ma Société (optionnel)'**
  String get companyNameHint;

  /// No description provided for @emailAddressLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse Email'**
  String get emailAddressLabel;

  /// No description provided for @emailAddressHint.
  ///
  /// In fr, this message translates to:
  /// **'client@email.com'**
  String get emailAddressHint;

  /// No description provided for @invalidEmailError.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email invalide'**
  String get invalidEmailError;

  /// No description provided for @saveChangesButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer les modifications'**
  String get saveChangesButton;

  /// No description provided for @createClientButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer le client'**
  String get createClientButton;

  /// No description provided for @clientsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Clients'**
  String get clientsTitle;

  /// No description provided for @searchClientHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher par nom, entreprise...'**
  String get searchClientHint;

  /// No description provided for @clientDeletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Client supprimé avec succès'**
  String get clientDeletedSuccess;

  /// No description provided for @noClientsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun client trouvé'**
  String get noClientsFound;

  /// No description provided for @deleteClientTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le client'**
  String get deleteClientTitle;

  /// No description provided for @deleteClientConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr ? Cela peut impacter les devis associés à ce client.'**
  String get deleteClientConfirmation;

  /// No description provided for @cancelButton.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteButton;

  /// No description provided for @editOption.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get editOption;

  /// No description provided for @deleteOption.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteOption;

  /// No description provided for @newClientOption.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau client'**
  String get newClientOption;

  /// No description provided for @selectClientPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un client'**
  String get selectClientPrompt;

  /// No description provided for @noClientsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucun client disponible'**
  String get noClientsAvailable;

  /// No description provided for @financingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Financement'**
  String get financingTitle;

  /// No description provided for @deleteRequestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la demande'**
  String get deleteRequestTitle;

  /// No description provided for @deleteRequestConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer cette demande de financement ? Cette action est irréversible.'**
  String get deleteRequestConfirmation;

  /// No description provided for @eligibilityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre éligibilité'**
  String get eligibilityTitle;

  /// No description provided for @improveScoreTipsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conseils pour améliorer votre score'**
  String get improveScoreTipsTitle;

  /// No description provided for @myRequestsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes demandes'**
  String get myRequestsTitle;

  /// No description provided for @requestDeletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Demande supprimée'**
  String get requestDeletedSuccess;

  /// No description provided for @noFinancingRequests.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande de financement'**
  String get noFinancingRequests;

  /// No description provided for @newRequestAppBarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande'**
  String get newRequestAppBarTitle;

  /// No description provided for @consentRequiredError.
  ///
  /// In fr, this message translates to:
  /// **'Vous devez accepter la transmission de vos données.'**
  String get consentRequiredError;

  /// No description provided for @requestSubmittedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Demande soumise avec succès !'**
  String get requestSubmittedSuccess;

  /// No description provided for @typeFinancementLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de financement'**
  String get typeFinancementLabel;

  /// No description provided for @creditFonctionnementLabel.
  ///
  /// In fr, this message translates to:
  /// **'Crédit de fonctionnement'**
  String get creditFonctionnementLabel;

  /// No description provided for @creditInvestissementLabel.
  ///
  /// In fr, this message translates to:
  /// **'Crédit d\'investissement'**
  String get creditInvestissementLabel;

  /// No description provided for @avanceFactureLabel.
  ///
  /// In fr, this message translates to:
  /// **'Avance sur factures'**
  String get avanceFactureLabel;

  /// No description provided for @plafondLabel.
  ///
  /// In fr, this message translates to:
  /// **'Plafond'**
  String get plafondLabel;

  /// No description provided for @montantDemandeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant demandé (DH)'**
  String get montantDemandeLabel;

  /// No description provided for @invalidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant invalide'**
  String get invalidAmount;

  /// No description provided for @mustBeGreaterThanZero.
  ///
  /// In fr, this message translates to:
  /// **'Doit être > 0'**
  String get mustBeGreaterThanZero;

  /// No description provided for @montantHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : 50000'**
  String get montantHint;

  /// No description provided for @dureeSouhaiteeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Durée souhaitée'**
  String get dureeSouhaiteeLabel;

  /// No description provided for @monthsLabel.
  ///
  /// In fr, this message translates to:
  /// **'mois'**
  String get monthsLabel;

  /// No description provided for @objetFinancementLabel.
  ///
  /// In fr, this message translates to:
  /// **'Objet du financement'**
  String get objetFinancementLabel;

  /// No description provided for @objetHint.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez l\'utilisation prévue des fonds...'**
  String get objetHint;

  /// No description provided for @cndpConsentText.
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte la transmission de mes données financières aux partenaires financiers conformément à la réglementation CNDP.'**
  String get cndpConsentText;

  /// No description provided for @submitRequestButton.
  ///
  /// In fr, this message translates to:
  /// **'Soumettre la demande'**
  String get submitRequestButton;

  /// No description provided for @requestDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail de la demande'**
  String get requestDetailTitle;

  /// No description provided for @documentTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de document'**
  String get documentTypeLabel;

  /// No description provided for @bankStatementLabel.
  ///
  /// In fr, this message translates to:
  /// **'Relevé bancaire'**
  String get bankStatementLabel;

  /// No description provided for @documentAddedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Document ajouté avec succès'**
  String get documentAddedSuccess;

  /// No description provided for @overMonthsPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Sur'**
  String get overMonthsPrefix;

  /// No description provided for @rejectionReasonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Motif de refus'**
  String get rejectionReasonLabel;

  /// No description provided for @justificatifsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Justificatifs'**
  String get justificatifsLabel;

  /// No description provided for @addButton.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get addButton;

  /// No description provided for @noDocumentsAdded.
  ///
  /// In fr, this message translates to:
  /// **'Aucun document ajouté'**
  String get noDocumentsAdded;

  /// No description provided for @receivedOffersLabel.
  ///
  /// In fr, this message translates to:
  /// **'Offres reçues'**
  String get receivedOffersLabel;

  /// No description provided for @rateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Taux'**
  String get rateLabel;

  /// No description provided for @estimatedMonthlyPaymentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité'**
  String get estimatedMonthlyPaymentLabel;

  /// No description provided for @unableToOpenPortalError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir le portail partenaire'**
  String get unableToOpenPortalError;

  /// No description provided for @finalizeOnPortalButton.
  ///
  /// In fr, this message translates to:
  /// **'Finaliser sur le portail'**
  String get finalizeOnPortalButton;

  /// No description provided for @reasonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Motif'**
  String get reasonLabel;

  /// No description provided for @eligibilityHigh.
  ///
  /// In fr, this message translates to:
  /// **'Éligibilité élevée'**
  String get eligibilityHigh;

  /// No description provided for @eligibilityMedium.
  ///
  /// In fr, this message translates to:
  /// **'Éligibilité moyenne'**
  String get eligibilityMedium;

  /// No description provided for @eligibilityLow.
  ///
  /// In fr, this message translates to:
  /// **'Éligibilité faible'**
  String get eligibilityLow;

  /// No description provided for @eligibilityNotEvaluated.
  ///
  /// In fr, this message translates to:
  /// **'Non évalué'**
  String get eligibilityNotEvaluated;

  /// No description provided for @statusSoumise.
  ///
  /// In fr, this message translates to:
  /// **'Soumise'**
  String get statusSoumise;

  /// No description provided for @statusEnAnalyse.
  ///
  /// In fr, this message translates to:
  /// **'En analyse'**
  String get statusEnAnalyse;

  /// No description provided for @statusFavorable.
  ///
  /// In fr, this message translates to:
  /// **'Favorable'**
  String get statusFavorable;

  /// No description provided for @statusDefavorable.
  ///
  /// In fr, this message translates to:
  /// **'Défavorable'**
  String get statusDefavorable;

  /// No description provided for @statusIncomplet.
  ///
  /// In fr, this message translates to:
  /// **'Incomplet'**
  String get statusIncomplet;

  /// No description provided for @retryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retryButton;

  /// No description provided for @dashboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboardTitle;

  /// No description provided for @monthlyIncomeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Recettes du mois'**
  String get monthlyIncomeLabel;

  /// No description provided for @monthlyExpensesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses du mois'**
  String get monthlyExpensesLabel;

  /// No description provided for @flowAnalysisTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse des flux'**
  String get flowAnalysisTitle;

  /// No description provided for @flowVolumeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Volume des flux'**
  String get flowVolumeLabel;

  /// No description provided for @incomeLegendLabel.
  ///
  /// In fr, this message translates to:
  /// **'Recettes'**
  String get incomeLegendLabel;

  /// No description provided for @expensesLegendLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses'**
  String get expensesLegendLabel;

  /// No description provided for @currentBalanceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Solde actuel'**
  String get currentBalanceLabel;

  /// No description provided for @positiveStatusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Positif'**
  String get positiveStatusLabel;

  /// No description provided for @negativeStatusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Négatif'**
  String get negativeStatusLabel;

  /// No description provided for @quoteActivityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Activité des devis'**
  String get quoteActivityTitle;

  /// No description provided for @totalQuotesGeneratedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Total des devis générés'**
  String get totalQuotesGeneratedLabel;

  /// No description provided for @conversionRateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Conversion'**
  String get conversionRateLabel;

  /// No description provided for @quoteStatusAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Acceptés'**
  String get quoteStatusAccepted;

  /// No description provided for @quoteStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get quoteStatusPending;

  /// No description provided for @quoteStatusRefused.
  ///
  /// In fr, this message translates to:
  /// **'Refusés'**
  String get quoteStatusRefused;

  /// No description provided for @quoteStatusExpired.
  ///
  /// In fr, this message translates to:
  /// **'Expirés'**
  String get quoteStatusExpired;

  /// No description provided for @newQuoteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau Devis'**
  String get newQuoteTitle;

  /// No description provided for @selectClientError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner un client'**
  String get selectClientError;

  /// No description provided for @selectValidityDateError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une date de validité'**
  String get selectValidityDateError;

  /// No description provided for @selectAtLeastOneLineError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez ajouter au moins une ligne de prestation'**
  String get selectAtLeastOneLineError;

  /// No description provided for @quoteCreatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Devis {numero} créé !'**
  String quoteCreatedSuccess(String numero);

  /// No description provided for @clientLabel.
  ///
  /// In fr, this message translates to:
  /// **'Client'**
  String get clientLabel;

  /// No description provided for @validUntilLabel.
  ///
  /// In fr, this message translates to:
  /// **'Valable jusqu\'au'**
  String get validUntilLabel;

  /// No description provided for @selectValidityDateHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une date de validité'**
  String get selectValidityDateHint;

  /// No description provided for @vatRateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Taux de TVA (%)'**
  String get vatRateLabel;

  /// No description provided for @vatRateHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : 20'**
  String get vatRateHint;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mode de paiement'**
  String get paymentMethodLabel;

  /// No description provided for @addProductsOrServicesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter des produits / prestations'**
  String get addProductsOrServicesLabel;

  /// No description provided for @addedItemsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Éléments ajoutés'**
  String get addedItemsLabel;

  /// No description provided for @specialConditionsOptionalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Conditions particulières (optionnel)'**
  String get specialConditionsOptionalLabel;

  /// No description provided for @specialConditionsHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : Règlement sous 30 jours...'**
  String get specialConditionsHint;

  /// No description provided for @createQuoteButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer le devis'**
  String get createQuoteButton;

  /// No description provided for @quoteDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail du Devis'**
  String get quoteDetailTitle;

  /// No description provided for @quoteConvertedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Devis converti en facture avec succès'**
  String get quoteConvertedSuccess;

  /// No description provided for @generalInformationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations générales'**
  String get generalInformationTitle;

  /// No description provided for @validUntilPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Valable jusqu\'au'**
  String get validUntilPrefix;

  /// No description provided for @paymentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Règlement'**
  String get paymentLabel;

  /// No description provided for @servicesSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prestations'**
  String get servicesSectionTitle;

  /// No description provided for @financialSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résumé financier'**
  String get financialSummaryTitle;

  /// No description provided for @totalHtLabel.
  ///
  /// In fr, this message translates to:
  /// **'Total HT'**
  String get totalHtLabel;

  /// No description provided for @vatLabel.
  ///
  /// In fr, this message translates to:
  /// **'TVA ({rate}%)'**
  String vatLabel(num rate);

  /// No description provided for @totalTtcLabel.
  ///
  /// In fr, this message translates to:
  /// **'Total TTC'**
  String get totalTtcLabel;

  /// No description provided for @linkedInvoiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Facture liée'**
  String get linkedInvoiceTitle;

  /// No description provided for @linkedInvoiceDefault.
  ///
  /// In fr, this message translates to:
  /// **'Facture liée'**
  String get linkedInvoiceDefault;

  /// No description provided for @quoteConvertedToInvoiceInfo.
  ///
  /// In fr, this message translates to:
  /// **'Ce devis a été converti en facture'**
  String get quoteConvertedToInvoiceInfo;

  /// No description provided for @viewButton.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get viewButton;

  /// No description provided for @specialConditionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conditions particulières'**
  String get specialConditionsTitle;

  /// No description provided for @availableActionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Actions disponibles'**
  String get availableActionsTitle;

  /// No description provided for @editQuoteAction.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le devis'**
  String get editQuoteAction;

  /// No description provided for @markAsSentAction.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme Envoyé'**
  String get markAsSentAction;

  /// No description provided for @deleteQuoteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le devis'**
  String get deleteQuoteTitle;

  /// No description provided for @remindClientAction.
  ///
  /// In fr, this message translates to:
  /// **'Relancer le client'**
  String get remindClientAction;

  /// No description provided for @markAsAcceptedAction.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme Accepté'**
  String get markAsAcceptedAction;

  /// No description provided for @markAsRefusedAction.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme Refusé'**
  String get markAsRefusedAction;

  /// No description provided for @resetToDraftAction.
  ///
  /// In fr, this message translates to:
  /// **'Remettre en Brouillon'**
  String get resetToDraftAction;

  /// No description provided for @convertToInvoiceAction.
  ///
  /// In fr, this message translates to:
  /// **'Convertir en facture'**
  String get convertToInvoiceAction;

  /// No description provided for @convertToInvoiceDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Convertir en facture'**
  String get convertToInvoiceDialogTitle;

  /// No description provided for @convertToInvoiceDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'Un brouillon de facture sera créé à partir de ce devis. Continuer ?'**
  String get convertToInvoiceDialogContent;

  /// No description provided for @convertButton.
  ///
  /// In fr, this message translates to:
  /// **'Convertir'**
  String get convertButton;

  /// No description provided for @duplicateQuoteAction.
  ///
  /// In fr, this message translates to:
  /// **'Dupliquer le devis'**
  String get duplicateQuoteAction;

  /// No description provided for @archiveQuoteAction.
  ///
  /// In fr, this message translates to:
  /// **'Archiver le devis'**
  String get archiveQuoteAction;

  /// No description provided for @downloadSharePdfAction.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger / Partager le PDF'**
  String get downloadSharePdfAction;

  /// No description provided for @editQuoteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le Devis'**
  String get editQuoteTitle;

  /// No description provided for @quoteUpdatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Devis {numero} mis à jour avec succès !'**
  String quoteUpdatedSuccess(String numero);

  /// No description provided for @backToDetailButton.
  ///
  /// In fr, this message translates to:
  /// **'Retour au détail'**
  String get backToDetailButton;

  /// No description provided for @editDraftNotice.
  ///
  /// In fr, this message translates to:
  /// **'Vous modifiez actuellement un brouillon de devis. Les modifications seront enregistrées immédiatement.'**
  String get editDraftNotice;

  /// No description provided for @paymentModeCash.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get paymentModeCash;

  /// No description provided for @paymentModeBankTransfer.
  ///
  /// In fr, this message translates to:
  /// **'Virement'**
  String get paymentModeBankTransfer;

  /// No description provided for @paymentModeMobileMoney.
  ///
  /// In fr, this message translates to:
  /// **'Mobile Money'**
  String get paymentModeMobileMoney;

  /// No description provided for @quotesListTitle.
  ///
  /// In fr, this message translates to:
  /// **'Devis'**
  String get quotesListTitle;

  /// No description provided for @activeTabLabel.
  ///
  /// In fr, this message translates to:
  /// **'Actifs'**
  String get activeTabLabel;

  /// No description provided for @archivedTabLabel.
  ///
  /// In fr, this message translates to:
  /// **'Archivés'**
  String get archivedTabLabel;

  /// No description provided for @clearAllFiltersButton.
  ///
  /// In fr, this message translates to:
  /// **'Tout effacer'**
  String get clearAllFiltersButton;

  /// No description provided for @filterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get filterAll;

  /// No description provided for @filterDrafts.
  ///
  /// In fr, this message translates to:
  /// **'Brouillons'**
  String get filterDrafts;

  /// No description provided for @filterSent.
  ///
  /// In fr, this message translates to:
  /// **'Envoyées'**
  String get filterSent;

  /// No description provided for @filterAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Acceptés'**
  String get filterAccepted;

  /// No description provided for @filterRefused.
  ///
  /// In fr, this message translates to:
  /// **'Refusés'**
  String get filterRefused;

  /// No description provided for @filterExpired.
  ///
  /// In fr, this message translates to:
  /// **'Expirés'**
  String get filterExpired;

  /// No description provided for @quoteDeletedSuccessMessage.
  ///
  /// In fr, this message translates to:
  /// **'Devis supprimé'**
  String get quoteDeletedSuccessMessage;

  /// No description provided for @quoteDuplicatedSuccessMessage.
  ///
  /// In fr, this message translates to:
  /// **'Devis dupliqué'**
  String get quoteDuplicatedSuccessMessage;

  /// No description provided for @noArchivedQuotesFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun devis archivé'**
  String get noArchivedQuotesFound;

  /// No description provided for @noQuotesFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun devis trouvé'**
  String get noQuotesFound;

  /// No description provided for @clearFiltersButton.
  ///
  /// In fr, this message translates to:
  /// **'Effacer les filtres'**
  String get clearFiltersButton;

  /// No description provided for @deleteQuoteDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le devis'**
  String get deleteQuoteDialogTitle;

  /// No description provided for @deleteQuoteDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer ce devis ?'**
  String get deleteQuoteDialogContent;

  /// No description provided for @filtersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get filtersTitle;

  /// No description provided for @resetFilterButton.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get resetFilterButton;

  /// No description provided for @refineQuotesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Affiner la liste des devis'**
  String get refineQuotesSubtitle;

  /// No description provided for @clientFilterLabel.
  ///
  /// In fr, this message translates to:
  /// **'Client'**
  String get clientFilterLabel;

  /// No description provided for @allClientsOption.
  ///
  /// In fr, this message translates to:
  /// **'Tous les clients'**
  String get allClientsOption;

  /// No description provided for @periodFilterLabel.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get periodFilterLabel;

  /// No description provided for @startDatePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Date début'**
  String get startDatePlaceholder;

  /// No description provided for @endDatePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Date fin'**
  String get endDatePlaceholder;

  /// No description provided for @applyFiltersButton.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer les filtres'**
  String get applyFiltersButton;

  /// No description provided for @validUntilCardLabel.
  ///
  /// In fr, this message translates to:
  /// **'Valide : {date}'**
  String validUntilCardLabel(String date);

  /// No description provided for @statusDraft.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon'**
  String get statusDraft;

  /// No description provided for @statusSent.
  ///
  /// In fr, this message translates to:
  /// **'Envoyée'**
  String get statusSent;

  /// No description provided for @statusAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Accepté'**
  String get statusAccepted;

  /// No description provided for @statusRefused.
  ///
  /// In fr, this message translates to:
  /// **'Refusé'**
  String get statusRefused;

  /// No description provided for @statusExpired.
  ///
  /// In fr, this message translates to:
  /// **'Expiré'**
  String get statusExpired;

  /// No description provided for @statusArchived.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get statusArchived;

  /// No description provided for @newInvoiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle Facture'**
  String get newInvoiceTitle;

  /// No description provided for @invoiceCreatedDraftSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Facture {numero} créée en brouillon !'**
  String invoiceCreatedDraftSuccess(String numero);

  /// No description provided for @selectDueDateError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une date d\'échéance'**
  String get selectDueDateError;

  /// No description provided for @dueDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'échéance'**
  String get dueDateLabel;

  /// No description provided for @selectDueDateHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner la date limite de règlement'**
  String get selectDueDateHint;

  /// No description provided for @paymentMethodRequiredLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mode de règlement requis'**
  String get paymentMethodRequiredLabel;

  /// No description provided for @addedBillingItemsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Éléments de facturation ajoutés'**
  String get addedBillingItemsLabel;

  /// No description provided for @paymentConditionsLegalMentionsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Conditions de règlement ou mentions légales'**
  String get paymentConditionsLegalMentionsLabel;

  /// No description provided for @paymentConditionsHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : Pénalités de retard de 10% après échéance...'**
  String get paymentConditionsHint;

  /// No description provided for @generateInvoiceButton.
  ///
  /// In fr, this message translates to:
  /// **'Générer la facture'**
  String get generateInvoiceButton;

  /// No description provided for @invoicePaymentDescription.
  ///
  /// In fr, this message translates to:
  /// **'Paiement facture {numero}'**
  String invoicePaymentDescription(String numero);

  /// No description provided for @invoiceDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail de la Facture'**
  String get invoiceDetailTitle;

  /// No description provided for @invoiceUpdatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Facture mise à jour'**
  String get invoiceUpdatedSuccess;

  /// No description provided for @invoiceArchivedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Facture annulée'**
  String get invoiceArchivedSuccess;

  /// No description provided for @generalInfoSection.
  ///
  /// In fr, this message translates to:
  /// **'Informations générales'**
  String get generalInfoSection;

  /// No description provided for @dueDateRowLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'échéance : {date}'**
  String dueDateRowLabel(String date);

  /// No description provided for @paymentMethodRowLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mode de règlement : {method}'**
  String paymentMethodRowLabel(String method);

  /// No description provided for @prestationsSection.
  ///
  /// In fr, this message translates to:
  /// **'Prestations'**
  String get prestationsSection;

  /// No description provided for @financialSummarySection.
  ///
  /// In fr, this message translates to:
  /// **'Résumé financier'**
  String get financialSummarySection;

  /// No description provided for @amountPaidLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant Payé'**
  String get amountPaidLabel;

  /// No description provided for @remainingDueLabel.
  ///
  /// In fr, this message translates to:
  /// **'Reste à payer'**
  String get remainingDueLabel;

  /// No description provided for @issuedFromQuoteLabel.
  ///
  /// In fr, this message translates to:
  /// **'Issu du devis {numero}'**
  String issuedFromQuoteLabel(String numero);

  /// No description provided for @availableActionsSection.
  ///
  /// In fr, this message translates to:
  /// **'Actions disponibles'**
  String get availableActionsSection;

  /// No description provided for @editInvoiceButton.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la facture'**
  String get editInvoiceButton;

  /// No description provided for @validateAndSendButton.
  ///
  /// In fr, this message translates to:
  /// **'Valider et Envoyer'**
  String get validateAndSendButton;

  /// No description provided for @deleteInvoiceDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la facture'**
  String get deleteInvoiceDialogTitle;

  /// No description provided for @registerPaymentButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer un paiement'**
  String get registerPaymentButton;

  /// No description provided for @remindForUnpaidButton.
  ///
  /// In fr, this message translates to:
  /// **'Relancer pour impayé'**
  String get remindForUnpaidButton;

  /// No description provided for @toBePaidBeforeDate.
  ///
  /// In fr, this message translates to:
  /// **'à régler avant le {date}'**
  String toBePaidBeforeDate(String date);

  /// No description provided for @asSoonAsPossible.
  ///
  /// In fr, this message translates to:
  /// **'dès que possible'**
  String get asSoonAsPossible;

  /// No description provided for @archiveInvoiceButton.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la facture'**
  String get archiveInvoiceButton;

  /// No description provided for @archiveInvoiceDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la facture'**
  String get archiveInvoiceDialogTitle;

  /// No description provided for @archiveInvoiceDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'Cette facture sera déplacée dans les factures annulées. Continuer ?'**
  String get archiveInvoiceDialogContent;

  /// No description provided for @archiveButton.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get archiveButton;

  /// No description provided for @downloadOrSharePdfButton.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger / Partager le PDF'**
  String get downloadOrSharePdfButton;

  /// No description provided for @invoicesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Factures'**
  String get invoicesTitle;

  /// No description provided for @tabActive.
  ///
  /// In fr, this message translates to:
  /// **'Actives'**
  String get tabActive;

  /// No description provided for @tabArchived.
  ///
  /// In fr, this message translates to:
  /// **'Annulées'**
  String get tabArchived;

  /// No description provided for @filterPaid.
  ///
  /// In fr, this message translates to:
  /// **'Payées'**
  String get filterPaid;

  /// No description provided for @filterPartial.
  ///
  /// In fr, this message translates to:
  /// **'Partielles'**
  String get filterPartial;

  /// No description provided for @filterArchived.
  ///
  /// In fr, this message translates to:
  /// **'Archivées'**
  String get filterArchived;

  /// No description provided for @invoiceDeletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Facture supprimée'**
  String get invoiceDeletedSuccess;

  /// No description provided for @noArchivedInvoicesFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune facture archivée'**
  String get noArchivedInvoicesFound;

  /// No description provided for @noInvoicesFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune facture trouvée'**
  String get noInvoicesFound;

  /// No description provided for @deleteInvoiceDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer cette facture ?'**
  String get deleteInvoiceDialogContent;

  /// No description provided for @statusPaid.
  ///
  /// In fr, this message translates to:
  /// **'Payée'**
  String get statusPaid;

  /// No description provided for @statusPartial.
  ///
  /// In fr, this message translates to:
  /// **'Partielle'**
  String get statusPartial;

  /// No description provided for @statusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get statusPending;

  /// No description provided for @unknownNumber.
  ///
  /// In fr, this message translates to:
  /// **'N° Inconnu'**
  String get unknownNumber;

  /// No description provided for @unknownClient.
  ///
  /// In fr, this message translates to:
  /// **'Client inconnu'**
  String get unknownClient;

  /// No description provided for @notificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @selectedCountTitle.
  ///
  /// In fr, this message translates to:
  /// **'{count} sélectionné(s)'**
  String selectedCountTitle(int count);

  /// No description provided for @deleteNotificationsDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer les notifications'**
  String get deleteNotificationsDialogTitle;

  /// No description provided for @deleteNotificationsDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer les {count} notifications sélectionnées ?'**
  String deleteNotificationsDialogContent(int count);

  /// No description provided for @markAllAsReadButton.
  ///
  /// In fr, this message translates to:
  /// **'Tout marquer comme lu ({count})'**
  String markAllAsReadButton(int count);

  /// No description provided for @emptyNotificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre historique est propre'**
  String get emptyNotificationsTitle;

  /// No description provided for @emptyNotificationsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Nous vous préviendrons dès qu\'une facture ou un devis nécessitera votre attention.'**
  String get emptyNotificationsSubtitle;

  /// No description provided for @closeButton.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get closeButton;

  /// No description provided for @timeJustNow.
  ///
  /// In fr, this message translates to:
  /// **'À l\'instant'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In fr, this message translates to:
  /// **'Il y a {minutes} min'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In fr, this message translates to:
  /// **'Il y a {hours} h'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeDaysAgo.
  ///
  /// In fr, this message translates to:
  /// **'Il y a {days} j'**
  String timeDaysAgo(int days);

  /// No description provided for @fillAllEmailFieldsError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir tous les champs email'**
  String get fillAllEmailFieldsError;

  /// No description provided for @emailConfigSavedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Configuration email enregistrée !'**
  String get emailConfigSavedSuccess;

  /// No description provided for @errorPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {error}'**
  String errorPrefix(String error);

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Coordonnées mises à jour !'**
  String get profileUpdatedSuccess;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe changé avec succès !'**
  String get passwordChangedSuccess;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @editCoordinatesHeader.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mes coordonnées'**
  String get editCoordinatesHeader;

  /// No description provided for @saveProfileButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le profil'**
  String get saveProfileButton;

  /// No description provided for @smtpConfigHeader.
  ///
  /// In fr, this message translates to:
  /// **'Configuration SMTP Email'**
  String get smtpConfigHeader;

  /// No description provided for @smtpGoogleInfoHint.
  ///
  /// In fr, this message translates to:
  /// **'Validation 2 étapes Google requise. Utilisez un \"Mot de passe d\'application\" généré sur votre compte Google.'**
  String get smtpGoogleInfoHint;

  /// No description provided for @profGmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse Gmail Professionnelle'**
  String get profGmailLabel;

  /// No description provided for @googleAppPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe d\'application Google'**
  String get googleAppPasswordLabel;

  /// No description provided for @linkingButton.
  ///
  /// In fr, this message translates to:
  /// **'Liaison...'**
  String get linkingButton;

  /// No description provided for @linkGmailButton.
  ///
  /// In fr, this message translates to:
  /// **'Lier mon compte Gmail'**
  String get linkGmailButton;

  /// No description provided for @autoRemindersHeader.
  ///
  /// In fr, this message translates to:
  /// **'Rappels automatiques'**
  String get autoRemindersHeader;

  /// No description provided for @unpaidInvoiceReminderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel facture impayée'**
  String get unpaidInvoiceReminderTitle;

  /// No description provided for @unpaidInvoiceReminderSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous serez averti des factures en retard'**
  String get unpaidInvoiceReminderSubtitle;

  /// No description provided for @reminderAfterLabel.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer un rappel après'**
  String get reminderAfterLabel;

  /// No description provided for @expiringQuoteReminderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel devis expirant'**
  String get expiringQuoteReminderTitle;

  /// No description provided for @expiringQuoteReminderSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Alerte avant expiration du devis'**
  String get expiringQuoteReminderSubtitle;

  /// No description provided for @warnBeforeExpirationLabel.
  ///
  /// In fr, this message translates to:
  /// **'M\'avertir avant expiration'**
  String get warnBeforeExpirationLabel;

  /// No description provided for @taxDeclarationReminderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel déclaration fiscale'**
  String get taxDeclarationReminderTitle;

  /// No description provided for @taxDeclarationReminderSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel trimestriel auto-entrepreneur / TPE'**
  String get taxDeclarationReminderSubtitle;

  /// No description provided for @cnssReminderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel cotisation CNSS'**
  String get cnssReminderTitle;

  /// No description provided for @cnssReminderSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel mensuel de paiement de cotisations'**
  String get cnssReminderSubtitle;

  /// No description provided for @creditRequestNotifTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications demande de crédit'**
  String get creditRequestNotifTitle;

  /// No description provided for @creditRequestNotifSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Changement de statut de dossier de crédit'**
  String get creditRequestNotifSubtitle;

  /// No description provided for @receptionModesHeader.
  ///
  /// In fr, this message translates to:
  /// **'Modes de réception'**
  String get receptionModesHeader;

  /// No description provided for @inAppNotifTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notification dans l\'application'**
  String get inAppNotifTitle;

  /// No description provided for @pushNotifTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notification Push'**
  String get pushNotifTitle;

  /// No description provided for @smsNotifTitle.
  ///
  /// In fr, this message translates to:
  /// **'SMS'**
  String get smsNotifTitle;

  /// No description provided for @smsNotifSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Frais opérateur possibles'**
  String get smsNotifSubtitle;

  /// No description provided for @noPreferencesFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune préférence trouvée.'**
  String get noPreferencesFound;

  /// No description provided for @savingLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde...'**
  String get savingLabel;

  /// No description provided for @securityButton.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get securityButton;

  /// No description provided for @logoutButton.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logoutButton;

  /// No description provided for @passwordsDoNotMatchError.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get passwordsDoNotMatchError;

  /// No description provided for @changePasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le mot de passe'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un mot de passe sécurisé d\'au moins 8 caractères.'**
  String get changePasswordSubtitle;

  /// No description provided for @oldPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ancien mot de passe'**
  String get oldPasswordLabel;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le nouveau mot de passe'**
  String get confirmNewPasswordLabel;

  /// No description provided for @requiredFieldError.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get requiredFieldError;

  /// No description provided for @minCharactersError.
  ///
  /// In fr, this message translates to:
  /// **'Minimum {count} caractères'**
  String minCharactersError(int count);

  /// No description provided for @validateButton.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validateButton;

  /// No description provided for @deleteConfirmationMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible.'**
  String get deleteConfirmationMessage;

  /// No description provided for @openPdfOption.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le PDF'**
  String get openPdfOption;

  /// No description provided for @sharePdfOption.
  ///
  /// In fr, this message translates to:
  /// **'Partager (WhatsApp, Email...)'**
  String get sharePdfOption;

  /// No description provided for @documentSubject.
  ///
  /// In fr, this message translates to:
  /// **'Document {numero}'**
  String documentSubject(String numero);

  /// No description provided for @documentShareText.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez trouver ci-joint le document {numero}.'**
  String documentShareText(String numero);

  /// No description provided for @remindClientTitle.
  ///
  /// In fr, this message translates to:
  /// **'Relancer le client'**
  String get remindClientTitle;

  /// No description provided for @sendViaWhatsApp.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer via WhatsApp'**
  String get sendViaWhatsApp;

  /// No description provided for @noPhoneNumber.
  ///
  /// In fr, this message translates to:
  /// **'Aucun numéro'**
  String get noPhoneNumber;

  /// No description provided for @whatsappReminderMessage.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {clientNom},\n\nNous espérons que vous allez bien.\n\nNous vous rappelons que le document *{docNumero}* d\'un montant de *{montant}* ({dateInfo}) est toujours en attente.\n\nMerci de bien vouloir le consulter dès que possible.\n\nCordialement,\nTPE Manager'**
  String whatsappReminderMessage(
    String clientNom,
    String docNumero,
    String montant,
    String dateInfo,
  );

  /// No description provided for @sendViaEmail.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer par Email'**
  String get sendViaEmail;

  /// No description provided for @noEmailAddress.
  ///
  /// In fr, this message translates to:
  /// **'Aucune adresse'**
  String get noEmailAddress;

  /// No description provided for @emailReminderSubject.
  ///
  /// In fr, this message translates to:
  /// **'Rappel - {docNumero}'**
  String emailReminderSubject(String docNumero);

  /// No description provided for @emailReminderBody.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {clientNom},\n\nNous espérons que vous allez bien.\n\nNous vous rappelons que le document {docNumero} d\'un montant de {montant} ({dateInfo}) est toujours en attente.\n\nNous vous remercions de bien vouloir effectuer les démarches nécessaires.\n\nCordialement,\nL\'équipe TPE Manager'**
  String emailReminderBody(
    String clientNom,
    String docNumero,
    String montant,
    String dateInfo,
  );

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navDevis.
  ///
  /// In fr, this message translates to:
  /// **'Devis'**
  String get navDevis;

  /// No description provided for @navFactures.
  ///
  /// In fr, this message translates to:
  /// **'Factures'**
  String get navFactures;

  /// No description provided for @navTresorerie.
  ///
  /// In fr, this message translates to:
  /// **'Trésorerie'**
  String get navTresorerie;

  /// No description provided for @navCredit.
  ///
  /// In fr, this message translates to:
  /// **'Crédit'**
  String get navCredit;

  /// No description provided for @selectDateHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une date'**
  String get selectDateHint;

  /// No description provided for @addLineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une ligne'**
  String get addLineTitle;

  /// No description provided for @designationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Désignation / Description'**
  String get designationLabel;

  /// No description provided for @unitPriceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prix unitaire (DH)'**
  String get unitPriceLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get quantityLabel;

  /// No description provided for @totalLineDisplay.
  ///
  /// In fr, this message translates to:
  /// **'Total : {total} DH'**
  String totalLineDisplay(String total);

  /// No description provided for @addToDocumentButton.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au document'**
  String get addToDocumentButton;

  /// No description provided for @paymentVirementLabel.
  ///
  /// In fr, this message translates to:
  /// **'Virement'**
  String get paymentVirementLabel;

  /// No description provided for @paymentVirementSub.
  ///
  /// In fr, this message translates to:
  /// **'Bancaire'**
  String get paymentVirementSub;

  /// No description provided for @paymentEspecesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get paymentEspecesLabel;

  /// No description provided for @paymentEspecesSub.
  ///
  /// In fr, this message translates to:
  /// **'En main propre'**
  String get paymentEspecesSub;

  /// No description provided for @paymentMobileLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mobile'**
  String get paymentMobileLabel;

  /// No description provided for @paymentMobileSub.
  ///
  /// In fr, this message translates to:
  /// **'Money'**
  String get paymentMobileSub;

  /// No description provided for @languageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageLabel;

  /// No description provided for @conseilVolumeEleve.
  ///
  /// In fr, this message translates to:
  /// **'Augmentez votre volume de facturation pour améliorer votre score.'**
  String get conseilVolumeEleve;

  /// No description provided for @conseilVolumeFaible.
  ///
  /// In fr, this message translates to:
  /// **'Votre volume de facturation est encore faible.'**
  String get conseilVolumeFaible;

  /// No description provided for @conseilVolumeDebut.
  ///
  /// In fr, this message translates to:
  /// **'Commencez à facturer régulièrement pour construire votre historique.'**
  String get conseilVolumeDebut;

  /// No description provided for @conseilAncienneteRecente.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte est encore récent. L\'ancienneté améliore l\'éligibilité.'**
  String get conseilAncienneteRecente;

  /// No description provided for @conseilAncienneteSuite.
  ///
  /// In fr, this message translates to:
  /// **'Continuez à utiliser l\'application pour augmenter votre ancienneté.'**
  String get conseilAncienneteSuite;

  /// No description provided for @conseilFacturesAttente.
  ///
  /// In fr, this message translates to:
  /// **'Régularisez vos factures en attente pour améliorer votre score.'**
  String get conseilFacturesAttente;

  /// No description provided for @conseilFacturesImpayees.
  ///
  /// In fr, this message translates to:
  /// **'Trop de factures impayées. Régularisez-les en priorité.'**
  String get conseilFacturesImpayees;

  /// No description provided for @conseilFacturesAbsentes.
  ///
  /// In fr, this message translates to:
  /// **'Émettez et encaissez des factures pour évaluer votre régularité.'**
  String get conseilFacturesAbsentes;

  /// No description provided for @conseilProfilFiscal.
  ///
  /// In fr, this message translates to:
  /// **'Complétez votre profil fiscal pour améliorer votre éligibilité.'**
  String get conseilProfilFiscal;

  /// No description provided for @searchTransactionsHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une transaction...'**
  String get searchTransactionsHint;

  /// No description provided for @noSearchResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat trouvé'**
  String get noSearchResults;

  /// No description provided for @archiveMotifLabel.
  ///
  /// In fr, this message translates to:
  /// **'Motif d\'annulation'**
  String get archiveMotifLabel;

  /// No description provided for @archiveMotifHint.
  ///
  /// In fr, this message translates to:
  /// **'Expliquez pourquoi cette facture est annulée...'**
  String get archiveMotifHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
