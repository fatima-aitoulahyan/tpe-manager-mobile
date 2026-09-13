// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get loginTitle => 'مرحباً بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول لإدارة نشاطك';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'vous@exemple.com';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'بريد إلكتروني غير صالح';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordMinLength => '8 أحرف على الأقل';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get orDivider => 'أو';

  @override
  String get noAccount => 'ليس لديك حساب؟ ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني. سنرسل لك رمزاً لإعادة تعيين كلمة المرور.';

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get newPasswordTitle => 'كلمة مرور جديدة';

  @override
  String get newPasswordSubtitle =>
      'اختر كلمة مرور آمنة مكونة من 8 أحرف على الأقل.';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get fieldRequired => 'مطلوب';

  @override
  String get passwordsDontMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordResetSuccess => 'تمت إعادة تعيين كلمة المرور بنجاح!';

  @override
  String get resetButton => 'إعادة التعيين';

  @override
  String get registerTitle => 'مرحباً';

  @override
  String get registerSubtitle => 'أدخل بياناتك للبدء';

  @override
  String get nomLabel => 'الاسم العائلي';

  @override
  String get nomHint => 'بنعلي';

  @override
  String get prenomLabel => 'الاسم الشخصي';

  @override
  String get prenomHint => 'حسن';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get phoneHint => '0612345678';

  @override
  String get iceLabel => 'رقم التعريف الضريبي (ICE)';

  @override
  String get iceHint => '001234567000 (اختياري)';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get statutFiscalLabel => 'الوضع الضريبي';

  @override
  String get statutFiscalHint => 'اختر وضعاً';

  @override
  String get statutAutoEntrepreneur => 'مقاول ذاتي';

  @override
  String get statutTpe => 'مقاولة صغيرة جداً';

  @override
  String get statutArtisan => 'حرفي';

  @override
  String get statutFreelance => 'عمل حر';

  @override
  String get statutCommercant => 'تاجر';

  @override
  String get createAccountButton => 'إنشاء حسابي';

  @override
  String get accountCreatedSuccess => 'تم إنشاء الحساب! سجّل الدخول.';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get loginLink => 'تسجيل الدخول';

  @override
  String get verifyCodeTitle => 'التحقق من الرمز';

  @override
  String get verifyCodeSubtitle => 'أدخل الرمز المكون من 6 أرقام المرسل إلى ';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get codeResentMessage => 'تم إرسال رمز جديد';

  @override
  String get registerAppBarTitle => 'إنشاء حساب';

  @override
  String get registerWelcomeTitle => 'مرحباً';

  @override
  String get registerWelcomeSubtitle => 'أدخل معلوماتك للبدء';

  @override
  String get lastNameLabel => 'الاسم العائلي';

  @override
  String get lastNameHint => 'بنعلي';

  @override
  String get firstNameLabel => 'الاسم الشخصي';

  @override
  String get firstNameHint => 'حسن';

  @override
  String get fiscalStatusLabel => 'الوضع الضريبي';

  @override
  String get fiscalStatusHint => 'اختر الحالة';

  @override
  String get registerButton => 'إنشاء حسابي';

  @override
  String get registerSuccessMessage => 'تم إنشاء الحساب! قم تسجيل الدخول.';

  @override
  String get loginAction => 'تسجيل الدخول';

  @override
  String get statusAutoEntrepreneur => 'مقاول ذاتي';

  @override
  String get statusTpe => 'شركة صغيرة جداً';

  @override
  String get statusArtisan => 'حرفي';

  @override
  String get statusFreelance => 'مستقل';

  @override
  String get statusCommercant => 'تاجر';

  @override
  String get codeResentSuccess => 'تم إرسال رمز جديد';

  @override
  String get resendCodeAction => 'إعادة إرسال الرمز';

  @override
  String get cashflowAppBarTitle => 'التدفق النقدي';

  @override
  String selectedCount(int count) {
    return 'تم تحديد $count';
  }

  @override
  String get multipleDeletionTitle => 'حذف متعدد';

  @override
  String multipleDeletionContent(int count) {
    return 'هل أنت متأكد أنك تريد حذف المعاملات الـ $count المحددة؟';
  }

  @override
  String get cancelAction => 'إلغاء';

  @override
  String get deleteAction => 'حذف';

  @override
  String get tabAll => 'الكل';

  @override
  String get tabRecettes => 'المداخيل';

  @override
  String get tabDepenses => 'المصاريف';

  @override
  String get availableBalanceLabel => 'الرصيد المتاح';

  @override
  String get noTransactions => 'لا توجد معاملات';

  @override
  String get paymentRecordedSuccess => 'تم تسجيل الدفع ✓';

  @override
  String get expenseRecordedSuccess => 'تم تسجيل المصروف ✓';

  @override
  String get selectCategoryError => 'الرجاء اختيار فئة';

  @override
  String get registerPaymentTitle => 'تسجيل دفع';

  @override
  String get newTransactionTitle => 'معاملة جديدة';

  @override
  String get paymentLinkedToInvoice => 'الدفع مرتبط بالفاتورة';

  @override
  String get registerPaymentOrExpenseSubtitle => 'تسجيل دفعة أو مصروف';

  @override
  String get transactionTypeLabel => 'نوع المعاملة';

  @override
  String get paymentReceivedType => 'دفعة مستلمة';

  @override
  String get expenseType => 'مصروف';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get catPaymentInvoice => 'دفع الفاتورة';

  @override
  String get catDeposit => 'عربون / دفعة مقدمة';

  @override
  String get catOtherIncome => 'إيرادات أخرى';

  @override
  String get catEquipmentPurchase => 'شراء معدات';

  @override
  String get catRent => 'إيجار';

  @override
  String get catSalary => 'راتب';

  @override
  String get catTransport => 'نقل';

  @override
  String get catOtherExpense => 'مصروف آخر';

  @override
  String get amountDhLabel => 'المبلغ (درهم)';

  @override
  String get fieldRequiredError => 'هذا الحقل إجباري';

  @override
  String get invalidAmountError => 'مبلغ غير صالح';

  @override
  String get greaterThanZeroError => 'يجب أن يكون أكبر من 0';

  @override
  String get amountHint => 'مثال: 1500.00';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get descriptionRecetteHint => 'مثال: دفع الفاتورة FAC-2026-001';

  @override
  String get descriptionDepenseHint => 'مثال: شراء لوازم المكتب';

  @override
  String get transactionDateLabel => 'تاريخ المعاملة';

  @override
  String get savePaymentButton => 'حفظ الدفع';

  @override
  String get saveExpenseButton => 'حفظ المصروف';

  @override
  String get transactionAmountLabel => 'مبلغ المعاملة';

  @override
  String get paymentDateLabel => 'تاريخ الدفع';

  @override
  String get justificationLabel => 'المستند المبرر';

  @override
  String get invoiceLoadError => 'تعذر تحميل رابط الفاتورة.';

  @override
  String get viewInvoiceLabel => 'عرض الفاتورة';

  @override
  String get editClientTitle => 'تعديل العميل';

  @override
  String get newClientTitle => 'عميل جديد';

  @override
  String get clientCreatedSuccess => 'تم إنشاء العميل بنجاح!';

  @override
  String get clientUpdatedSuccess => 'تم تحديث العميل!';

  @override
  String get companyNameLabel => 'اسم الشركة';

  @override
  String get companyNameHint => 'شركتي (اختياري)';

  @override
  String get emailAddressLabel => 'البريد الإلكتروني';

  @override
  String get emailAddressHint => 'client@email.com';

  @override
  String get invalidEmailError => 'بريد إلكتروني غير صالح';

  @override
  String get saveChangesButton => 'حفظ التعديلات';

  @override
  String get createClientButton => 'إنشاء العميل';

  @override
  String get clientsTitle => 'العملاء';

  @override
  String get searchClientHint => 'البحث بالاسم، الشركة...';

  @override
  String get clientDeletedSuccess => 'تم حذف العميل بنجاح';

  @override
  String get noClientsFound => 'لم يتم العثور على أي عميل';

  @override
  String get deleteClientTitle => 'حذف العميل';

  @override
  String get deleteClientConfirmation =>
      'هل أنت متأكد؟ قد يؤثر ذلك على عروض الأسعار المرتبطة بهذا العميل.';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get deleteButton => 'حذف';

  @override
  String get editOption => 'تعديل';

  @override
  String get deleteOption => 'حذف';

  @override
  String get newClientOption => 'عميل جديد';

  @override
  String get selectClientPrompt => 'اختر عميلاً';

  @override
  String get noClientsAvailable => 'لا يوجد عملاء متاحون';

  @override
  String get financingTitle => 'التمويل';

  @override
  String get deleteRequestTitle => 'حذف الطلب';

  @override
  String get deleteRequestConfirmation =>
      'هل أنت متأكد من رغبتك في حذف طلب التمويل هذا؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get eligibilityTitle => 'أهليتك';

  @override
  String get improveScoreTipsTitle => 'نصائح لتحسين درجاتك';

  @override
  String get myRequestsTitle => 'طلباتي';

  @override
  String get requestDeletedSuccess => 'تم حذف الطلب';

  @override
  String get noFinancingRequests => 'لا توجد طلبات تمويل';

  @override
  String get newRequestAppBarTitle => 'طلب جديد';

  @override
  String get consentRequiredError => 'يجب عليك الموافقة على نقل بياناتك.';

  @override
  String get requestSubmittedSuccess => 'تم تقديم الطلب بنجاح!';

  @override
  String get typeFinancementLabel => 'نوع التمويل';

  @override
  String get creditFonctionnementLabel => 'قرض التشغيل';

  @override
  String get creditInvestissementLabel => 'قرض الاستثمار';

  @override
  String get avanceFactureLabel => 'سلفة على الفواتير';

  @override
  String get plafondLabel => 'الحد الأقصى';

  @override
  String get montantDemandeLabel => 'المبلغ المطلوب (درهم)';

  @override
  String get invalidAmount => 'مبلغ غير صالح';

  @override
  String get mustBeGreaterThanZero => 'يجب أن يكون أكبر من 0';

  @override
  String get montantHint => 'مثال : 50000';

  @override
  String get dureeSouhaiteeLabel => 'المدة المطلوبة';

  @override
  String get monthsLabel => 'أشهر';

  @override
  String get objetFinancementLabel => 'غرض التمويل';

  @override
  String get objetHint => 'صف الاستخدام المقصود للتمويل...';

  @override
  String get cndpConsentText =>
      'أوافق على نقل بياناتي المالية إلى الشركاء الماليين وفقاً لوائح اللجنة الوطنية لحماية المعطيات ذات الطابع الشخصي (CNDP).';

  @override
  String get submitRequestButton => 'تقديم الطلب';

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
  String get reasonLabel => 'السبب';

  @override
  String get eligibilityHigh => 'أهلية عالية';

  @override
  String get eligibilityMedium => 'أهلية متوسطة';

  @override
  String get eligibilityLow => 'أهلية ضعيفة';

  @override
  String get eligibilityNotEvaluated => 'لم يتم التقييم';

  @override
  String get statusSoumise => 'تم التقديم';

  @override
  String get statusEnAnalyse => 'قيد التحليل';

  @override
  String get statusFavorable => 'موافق عليها';

  @override
  String get statusDefavorable => 'مرفوضة';

  @override
  String get statusIncomplet => 'غير مكتمل';

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String get dashboardTitle => 'لوحة القيادة';

  @override
  String get monthlyIncomeLabel => 'مداخل الشهر';

  @override
  String get monthlyExpensesLabel => 'مصاريف الشهر';

  @override
  String get flowAnalysisTitle => 'تحليل التدفقات المالية';

  @override
  String get flowVolumeLabel => 'حجم التدفقات';

  @override
  String get incomeLegendLabel => 'المداخيل';

  @override
  String get expensesLegendLabel => 'المصاريف';

  @override
  String get currentBalanceLabel => 'الرصيد الحالي';

  @override
  String get positiveStatusLabel => 'إيجابي';

  @override
  String get negativeStatusLabel => 'سلبي';

  @override
  String get quoteActivityTitle => 'نشاط عروض الأسعار';

  @override
  String get totalQuotesGeneratedLabel => 'إجمالي عروض الأسعار المُنشأة';

  @override
  String get conversionRateLabel => 'معدل التحويل';

  @override
  String get quoteStatusAccepted => 'مقبولة';

  @override
  String get quoteStatusPending => 'قيد الانتظار';

  @override
  String get quoteStatusRefused => 'مرفوضة';

  @override
  String get quoteStatusExpired => 'منتهية الصلاحية';

  @override
  String get newQuoteTitle => 'عرض سعر جديد';

  @override
  String get selectClientError => 'المرجو اختيار الزميـل أو العميل';

  @override
  String get selectValidityDateError => 'المرجو تحديد تاريخ صلاحية العرض';

  @override
  String get selectAtLeastOneLineError =>
      'المرجو إضافة سطر خدمة واحد على الأقل';

  @override
  String quoteCreatedSuccess(String numero) {
    return 'تم إنشاء عرض السعر $numero بنجاح!';
  }

  @override
  String get clientLabel => 'العميل';

  @override
  String get validUntilLabel => 'صالح لغاية';

  @override
  String get selectValidityDateHint => 'اختر تاريخ الصلاحية';

  @override
  String get vatRateLabel => 'نسبة الضريبة على القيمة المضافة (%)';

  @override
  String get vatRateHint => 'مثال: 20';

  @override
  String get paymentMethodLabel => 'طريقة الدفع';

  @override
  String get addProductsOrServicesLabel => 'إضافة منتجات / خدمات';

  @override
  String get addedItemsLabel => 'العناصر المضافة';

  @override
  String get specialConditionsOptionalLabel => 'شروط خاصّة (اختياري)';

  @override
  String get specialConditionsHint => 'مثال: الأداء في غضون 30 يوماً...';

  @override
  String get createQuoteButton => 'إنشاء عرض السعر';

  @override
  String get quoteDetailTitle => 'تفاصيل عرض السعر';

  @override
  String get quoteConvertedSuccess => 'تم تحويل عرض السعر إلى فاتورة بنجاح';

  @override
  String get generalInformationTitle => 'معلومات عامة';

  @override
  String get validUntilPrefix => 'صالح لغاية';

  @override
  String get paymentLabel => 'طريقة الدفع';

  @override
  String get servicesSectionTitle => 'الخدمات';

  @override
  String get financialSummaryTitle => 'الملخص المالي';

  @override
  String get totalHtLabel => 'المجموع بدون اضافة الرسوم (HT)';

  @override
  String vatLabel(num rate) {
    return 'الضريبة ($rate%)';
  }

  @override
  String get totalTtcLabel => 'المجموع مع احتساب الرسوم (TTC)';

  @override
  String get linkedInvoiceTitle => 'الفاتورة المرتبطة';

  @override
  String get linkedInvoiceDefault => 'فاتورة مرتبطة';

  @override
  String get quoteConvertedToInvoiceInfo => 'تم تحويل عرض السعر هذا إلى فاتورة';

  @override
  String get viewButton => 'عرض';

  @override
  String get specialConditionsTitle => 'شروط خاصّة';

  @override
  String get availableActionsTitle => 'الإجراءات المتاحة';

  @override
  String get editQuoteAction => 'تعديل عرض السعر';

  @override
  String get markAsSentAction => 'وضع كـ \'مُرسل\'';

  @override
  String get deleteQuoteTitle => 'حذف عرض السعر';

  @override
  String get remindClientAction => 'تذكير العميل';

  @override
  String get markAsAcceptedAction => 'وضع كـ \'مقبول\'';

  @override
  String get markAsRefusedAction => 'وضع كـ \'مرفوض\'';

  @override
  String get resetToDraftAction => 'إعادة مسودة';

  @override
  String get convertToInvoiceAction => 'تحويل إلى فاتورة';

  @override
  String get convertToInvoiceDialogTitle => 'تحويل إلى فاتورة';

  @override
  String get convertToInvoiceDialogContent =>
      'سيتم إنشاء مسودة فاتورة بناءً على عرض السعر هذا. هل تريد المتابعة؟';

  @override
  String get convertButton => 'تحويل';

  @override
  String get duplicateQuoteAction => 'نسخ عرض السعر';

  @override
  String get archiveQuoteAction => 'أرشفة عرض السعر';

  @override
  String get downloadSharePdfAction => 'تحميل / مشاركة ملف PDF';

  @override
  String get editQuoteTitle => 'تعديل عرض السعر';

  @override
  String quoteUpdatedSuccess(String numero) {
    return 'تم تحديث عرض السعر $numero بنجاح!';
  }

  @override
  String get backToDetailButton => 'العودة إلى التفاصيل';

  @override
  String get editDraftNotice =>
      'أنت تقوم حالياً بتعديل مسودة عرض سعر. سيتم حفظ التعديلات فوراً.';

  @override
  String get paymentModeCash => 'نقداً';

  @override
  String get paymentModeBankTransfer => 'تحويل بنكي';

  @override
  String get paymentModeMobileMoney => 'موبايل موني';

  @override
  String get quotesListTitle => 'عروض الأسعار';

  @override
  String get activeTabLabel => 'النشطة';

  @override
  String get archivedTabLabel => 'المؤرشفة';

  @override
  String get clearAllFiltersButton => 'مسح الكل';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterDrafts => 'مسودات';

  @override
  String get filterSent => 'مُرسلة';

  @override
  String get filterAccepted => 'المقبولة';

  @override
  String get filterRefused => 'المرفوضة';

  @override
  String get filterExpired => 'المنتهية';

  @override
  String get quoteDeletedSuccessMessage => 'تم حذف عرض السعر';

  @override
  String get quoteDuplicatedSuccessMessage => 'تم نسخ عرض السعر';

  @override
  String get noArchivedQuotesFound => 'لا توجد عروض أسعار مؤرشفة';

  @override
  String get noQuotesFound => 'لم يتم العثور على أي عروض أسعار';

  @override
  String get clearFiltersButton => 'مسح الفلاتر';

  @override
  String get deleteQuoteDialogTitle => 'حذف عرض السعر';

  @override
  String get deleteQuoteDialogContent =>
      'هل أنت متأكد أنك تريد حذف عرض السعر هذا؟';

  @override
  String get filtersTitle => 'التصفية';

  @override
  String get resetFilterButton => 'إعادة تعيين';

  @override
  String get refineQuotesSubtitle => 'تحسين قائمة عروض الأسعار';

  @override
  String get clientFilterLabel => 'العميل';

  @override
  String get allClientsOption => 'جميع العملاء';

  @override
  String get periodFilterLabel => 'الفترة';

  @override
  String get startDatePlaceholder => 'تاريخ البدء';

  @override
  String get endDatePlaceholder => 'تاريخ الانتهاء';

  @override
  String get applyFiltersButton => 'تطبيق الفلاتر';

  @override
  String validUntilCardLabel(String date) {
    return 'صالح حتى: $date';
  }

  @override
  String get statusDraft => 'مسودة';

  @override
  String get statusSent => 'مُرسلة';

  @override
  String get statusAccepted => 'مقبول';

  @override
  String get statusRefused => 'مرفوض';

  @override
  String get statusExpired => 'منتهي الصلاحية';

  @override
  String get statusArchived => 'مؤرشفة';

  @override
  String get newInvoiceTitle => 'فاتورة جديدة';

  @override
  String invoiceCreatedDraftSuccess(String numero) {
    return 'تم إنشاء الفاتورة $numero كمسودة!';
  }

  @override
  String get selectDueDateError => 'الرجاء اختيار تاريخ الاستحقاق';

  @override
  String get dueDateLabel => 'تاريخ الاستحقاق';

  @override
  String get selectDueDateHint => 'اختر الموعد النهائي للدفع';

  @override
  String get paymentMethodRequiredLabel => 'طريقة الدفع المطلوبة';

  @override
  String get addedBillingItemsLabel => 'عناصر الفوترة المضافة';

  @override
  String get paymentConditionsLegalMentionsLabel =>
      'شروط الدفع أو الإشعارات القانونية';

  @override
  String get paymentConditionsHint =>
      'مثال: غرامات تأخير بنسبة 10% بعد تاريخ الاستحقاق...';

  @override
  String get generateInvoiceButton => 'إنشاء الفاتورة';

  @override
  String invoicePaymentDescription(String numero) {
    return 'دفع الفاتورة $numero';
  }

  @override
  String get invoiceDetailTitle => 'تفاصيل الفاتورة';

  @override
  String get invoiceUpdatedSuccess => 'تم تحديث الفاتورة';

  @override
  String get invoiceArchivedSuccess => 'تم إلغاء الفاتورة';

  @override
  String get generalInfoSection => 'المعلومات العامة';

  @override
  String dueDateRowLabel(String date) {
    return 'تاريخ الاستحقاق: $date';
  }

  @override
  String paymentMethodRowLabel(String method) {
    return 'طريقة الدفع: $method';
  }

  @override
  String get prestationsSection => 'الخدمات';

  @override
  String get financialSummarySection => 'الملخص المالي';

  @override
  String get amountPaidLabel => 'المبلغ المدفوع';

  @override
  String get remainingDueLabel => 'المبلغ المتبقي';

  @override
  String issuedFromQuoteLabel(String numero) {
    return 'مأخوذ من عرض السعر $numero';
  }

  @override
  String get availableActionsSection => 'الإجراءات المتاحة';

  @override
  String get editInvoiceButton => 'تعديل الفاتورة';

  @override
  String get validateAndSendButton => 'تحقق وإرسال';

  @override
  String get deleteInvoiceDialogTitle => 'حذف الفاتورة';

  @override
  String get registerPaymentButton => 'تسجيل الدفع';

  @override
  String get remindForUnpaidButton => 'التذكير بالمبلغ غير المدفوع';

  @override
  String toBePaidBeforeDate(String date) {
    return 'الدفع قبل $date';
  }

  @override
  String get asSoonAsPossible => 'في أسرع وقت ممكن';

  @override
  String get archiveInvoiceButton => 'إلغاء الفاتورة';

  @override
  String get archiveInvoiceDialogTitle => 'Annuler la facture';

  @override
  String get archiveInvoiceDialogContent =>
      'سيتم نقل هذه الفاتورة إلى الفواتير الملغاة. هل تريد المتابعة؟';

  @override
  String get archiveButton => 'متابعة';

  @override
  String get downloadOrSharePdfButton => 'تحميل / مشاركة ملف PDF';

  @override
  String get invoicesTitle => 'الفواتير';

  @override
  String get tabActive => 'النشطة';

  @override
  String get tabArchived => 'الملغاة';

  @override
  String get filterPaid => 'مدفوعة';

  @override
  String get filterPartial => 'جزئية';

  @override
  String get filterArchived => 'مؤرشفة';

  @override
  String get invoiceDeletedSuccess => 'تم حذف الفاتورة';

  @override
  String get noArchivedInvoicesFound => 'لا توجد فواتير مؤرشفة';

  @override
  String get noInvoicesFound => 'لم يتم العثور على فواتير';

  @override
  String get deleteInvoiceDialogContent =>
      'هل أنت متأكد أنك تريد حذف هذه الفاتورة؟';

  @override
  String get statusPaid => 'مدفوعة';

  @override
  String get statusPartial => 'جزئية';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get unknownNumber => 'رقم غير معروف';

  @override
  String get unknownClient => 'عميل غير معروف';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String selectedCountTitle(int count) {
    return 'تم تحديد $count';
  }

  @override
  String get deleteNotificationsDialogTitle => 'حذف الإشعارات';

  @override
  String deleteNotificationsDialogContent(int count) {
    return 'هل تريد حقاً حذف الإشعارات الـ $count المحددة؟';
  }

  @override
  String markAllAsReadButton(int count) {
    return 'تحديد الكل كمقروء ($count)';
  }

  @override
  String get emptyNotificationsTitle => 'سجلك نظيف';

  @override
  String get emptyNotificationsSubtitle =>
      'سنقوم بتنبيهك بمجرد أن تتطلب أي فاتورة أو عرض سعر انتباهك.';

  @override
  String get closeButton => 'إغلاق';

  @override
  String get timeJustNow => 'الآن';

  @override
  String timeMinutesAgo(int minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'منذ $hours ساعة';
  }

  @override
  String timeDaysAgo(int days) {
    return 'منذ $days يوم';
  }

  @override
  String get fillAllEmailFieldsError => 'يرجى ملء جميع حقول البريد الإلكتروني';

  @override
  String get emailConfigSavedSuccess => 'تم حفظ إعدادات البريد الإلكتروني!';

  @override
  String errorPrefix(String error) {
    return 'خطأ: $error';
  }

  @override
  String get profileUpdatedSuccess => 'تم تحديث المعلومات!';

  @override
  String get passwordChangedSuccess => 'تم تغيير كلمة المرور بنجاح!';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get editCoordinatesHeader => 'تعديل معلوماتي الشخصية';

  @override
  String get saveProfileButton => 'حفظ الملف الشخصي';

  @override
  String get smtpConfigHeader => 'إعدادات SMTP للبريد الإلكتروني';

  @override
  String get smtpGoogleInfoHint =>
      'التحقق بخطوتين من جوجل مطلوب. استخدم \"كلمة مرور التطبيق\" المُنشأة على حساب جوجل الخاص بك.';

  @override
  String get profGmailLabel => 'عنوان جيميل المهني';

  @override
  String get googleAppPasswordLabel => 'كلمة مرور التطبيق من جوجل';

  @override
  String get linkingButton => 'جاري الربط...';

  @override
  String get linkGmailButton => 'ربط حساب جيميل الخاص بي';

  @override
  String get autoRemindersHeader => 'التذكيرات التلقائية';

  @override
  String get unpaidInvoiceReminderTitle => 'تذكير بالفواتير غير المدفوعة';

  @override
  String get unpaidInvoiceReminderSubtitle => 'سيتم تنبيهك بالفواتير المتأخرة';

  @override
  String get reminderAfterLabel => 'إرسال تذكير بعد';

  @override
  String get expiringQuoteReminderTitle => 'تذكير بانتهاء صلاحية عروض الأسعار';

  @override
  String get expiringQuoteReminderSubtitle =>
      'تنبيه قبل انتهاء صلاحية عرض السعر';

  @override
  String get warnBeforeExpirationLabel => 'تنبيهي قبل انتهاء الصلاحية';

  @override
  String get taxDeclarationReminderTitle => 'تذكير بالقرار الضريبي';

  @override
  String get taxDeclarationReminderSubtitle =>
      'تذكير ربع سنوي للمقاول الذاتي / الشركات الصغيرة جداً';

  @override
  String get cnssReminderTitle => 'تذكير باشتراكات الضمان الاجتماعي CNSS';

  @override
  String get cnssReminderSubtitle => 'تذكير شهري لدفع الاشتراكات';

  @override
  String get creditRequestNotifTitle => 'إشعارات طلبات القروض';

  @override
  String get creditRequestNotifSubtitle => 'تغير حالة ملف القرض';

  @override
  String get receptionModesHeader => 'طرق الاستلام';

  @override
  String get inAppNotifTitle => 'الإشعارات داخل التطبيق';

  @override
  String get pushNotifTitle => 'الإشعارات الفورية (Push)';

  @override
  String get smsNotifTitle => 'رسائل نصية قصيرة (SMS)';

  @override
  String get smsNotifSubtitle => 'قد تطبق رسوم المشغل';

  @override
  String get noPreferencesFound => 'لم يتم العثور على أي تفضيلات.';

  @override
  String get savingLabel => 'جاري الحفظ...';

  @override
  String get securityButton => 'الأمان';

  @override
  String get logoutButton => 'تسجيل الخروج';

  @override
  String get passwordsDoNotMatchError => 'كلمات المرور غير متطابقة';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get changePasswordSubtitle =>
      'اختر كلمة مرور آمنة تتكون من 8 أحرف على الأقل.';

  @override
  String get oldPasswordLabel => 'كلمة المرور القديمة';

  @override
  String get confirmNewPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get requiredFieldError => 'مطلوب';

  @override
  String minCharactersError(int count) {
    return 'الحد الأدنى $count أحرف';
  }

  @override
  String get validateButton => 'تأكيد';

  @override
  String get deleteConfirmationMessage =>
      'هل أنت متأكد أنك تريد حذف هذا العنصر؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get openPdfOption => 'فتح ملف PDF';

  @override
  String get sharePdfOption => 'مشاركة (واتساب، بريد إلكتروني...)';

  @override
  String documentSubject(String numero) {
    return 'مستند $numero';
  }

  @override
  String documentShareText(String numero) {
    return 'يرجى العثور على المستند $numero مرفقاً.';
  }

  @override
  String get remindClientTitle => 'تذكير العميل';

  @override
  String get sendViaWhatsApp => 'الإرسال عبر واتساب';

  @override
  String get noPhoneNumber => 'لا يوجد رقم';

  @override
  String whatsappReminderMessage(
    String clientNom,
    String docNumero,
    String montant,
    String dateInfo,
  ) {
    return 'مرحباً $clientNom,\n\nنأمل أن تكون بخير.\n\nنذكركم أن المستند *$docNumero* بقيمة *$montant* ($dateInfo) لا يزال معلقاً.\n\nيرجى مراجعته في أقرب وقت ممكن.\n\nمع خالص التحية،\nTPE Manager';
  }

  @override
  String get sendViaEmail => 'الإرسال عبر البريد الإلكتروني';

  @override
  String get noEmailAddress => 'لا توجد عنوان بريد';

  @override
  String emailReminderSubject(String docNumero) {
    return 'تذكير - $docNumero';
  }

  @override
  String emailReminderBody(
    String clientNom,
    String docNumero,
    String montant,
    String dateInfo,
  ) {
    return 'مرحباً $clientNom,\n\nنأمل أن تكون بخير.\n\nنذكركم أن المستند $docNumero بقيمة $montant ($dateInfo) لا يزال معلقاً.\n\nنشكركم على اتخاذ الإجراءات اللازمة.\n\nمع خالص التحية،\nفريق TPE Manager';
  }

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navDevis => 'عروض الأسعار';

  @override
  String get navFactures => 'الفواتير';

  @override
  String get navTresorerie => 'الخزينة';

  @override
  String get navCredit => 'الرصيد/القرض';

  @override
  String get selectDateHint => 'تحديد التاريخ';

  @override
  String get addLineTitle => 'إضافة سطر';

  @override
  String get designationLabel => 'التعيين / الوصف';

  @override
  String get unitPriceLabel => 'السعر الفردي (درهم)';

  @override
  String get quantityLabel => 'الكمية';

  @override
  String totalLineDisplay(String total) {
    return 'المجموع : $total درهم';
  }

  @override
  String get addToDocumentButton => 'إضافة إلى المستند';

  @override
  String get paymentVirementLabel => 'تحويل';

  @override
  String get paymentVirementSub => 'بنكي';

  @override
  String get paymentEspecesLabel => 'نقداً';

  @override
  String get paymentEspecesSub => 'باليد';

  @override
  String get paymentMobileLabel => 'موبايل';

  @override
  String get paymentMobileSub => 'موني';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get conseilVolumeEleve =>
      'قم زيادة حجم الفوترة الخاص بك لتحسين نقاطك.';

  @override
  String get conseilVolumeFaible => 'حجم الفوترة لديك لا يزال منخفضاً.';

  @override
  String get conseilVolumeDebut =>
      'ابدأ في إصدار الفواتير بانتظام لبناء سجل تاريخي.';

  @override
  String get conseilAncienneteRecente =>
      'حسابك لا يزال جديداً. الأقدمية تحسن الأهلية.';

  @override
  String get conseilAncienneteSuite =>
      'استمر في استخدام التطبيق لزيادة أقدميتك.';

  @override
  String get conseilFacturesAttente =>
      'قم بتسوية فواتيرك المعلقة لتحسين نقاطك.';

  @override
  String get conseilFacturesImpayees =>
      'عدد كبير من الفواتير غير المدفوعة. يرجى تسويتها كأولوية.';

  @override
  String get conseilFacturesAbsentes =>
      'قم بإصدار وتحصيل الفواتير لتقييم انتظامك.';

  @override
  String get conseilProfilFiscal => 'أكمل ملفك الضريبي لتحسين أهلبتك.';

  @override
  String get searchTransactionsHint => 'البحث عن معاملة...';

  @override
  String get noSearchResults => 'لم يتم العثور على أي نتائج';

  @override
  String get archiveMotifLabel => 'سبب الإلغاء';

  @override
  String get archiveMotifHint => 'اشرح سبب إلغاء هذه الفاتورة...';
}
