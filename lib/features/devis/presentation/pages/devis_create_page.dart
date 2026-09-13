import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../clients/data/datasources/client_remote_datasource.dart';
import '../../../clients/data/models/client_model.dart';
import '../../../clients/presentation/pages/client_create_page.dart'; // ← adapte le chemin réel si différent
import '../../../clients/presentation/widgets/client_dropdown_selector.dart';
import '../../../../shared/widgets/custom_date_picker_field.dart';
import '../../../../shared/widgets/document_line_item_row.dart';
import '../../../../shared/widgets/financial_totals_card.dart';
import '../../../../shared/widgets/payment_selector.dart';
import '../../../../shared/widgets/ligne_devis_form.dart';
import '../../data/datasources/devis_remote_datasource.dart';
import '../bloc/devis_bloc.dart';
import '../bloc/devis_event.dart';
import '../bloc/devis_state.dart';
import '../../../../l10n/app_localizations.dart';

class DevisCreatePage extends StatelessWidget {
  const DevisCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DevisBloc(DevisRemoteDataSource(), ClientRemoteDataSource())..add(LoadClients()),
      child: const _DevisCreateView(),
    );
  }
}

class _DevisCreateView extends StatefulWidget {
  const _DevisCreateView();

  @override
  State<_DevisCreateView> createState() => _DevisCreateViewState();
}

class _DevisCreateViewState extends State<_DevisCreateView> {
  final _formKey        = GlobalKey<FormState>();
  final _conditionsCtrl = TextEditingController();
  final _tvaCtrl        = TextEditingController(text: '20');
  DateTime? _dateValidite;
  String _modePaiement  = 'VIREMENT';
  ClientModel? _selectedClient;
  final List<Map<String, dynamic>> _lignes = [];
  bool _isGeneratingAi = false;

  // Mémorise le dernier texte envoyé à l'IA pour pouvoir relancer
  // automatiquement la génération une fois le client manquant créé.
  String? _dernierTexteAi;

  double get _totalHt => _lignes.fold(0.0, (sum, l) =>
  sum + (double.tryParse(l['prix_unitaire'].toString()) ?? 0.0)
      * (double.tryParse(l['quantite'].toString()) ?? 0.0));

  double get _totalTtc {
    final tva = double.tryParse(_tvaCtrl.text) ?? 0;
    return _totalHt * (1 + tva / 100);
  }

  void _submit(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectClientError)));
      return;
    }
    if (_dateValidite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectValidityDateError)));
      return;
    }
    if (_lignes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectAtLeastOneLineError)));
      return;
    }
    context.read<DevisBloc>().add(CreateDevis({
      'client':        _selectedClient!.id,
      'date_validite': _dateValidite!.toIso8601String().split('T')[0],
      'taux_tva':      double.tryParse(_tvaCtrl.text) ?? 0,
      'mode_paiement': _modePaiement,
      'conditions':    _conditionsCtrl.text.trim(),
      'lignes':        _lignes,
    }));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.newQuoteTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/devis'),
        ),
        actions: [
          // Bouton magique IA dans l'en-tête
          IconButton(
            icon: _isGeneratingAi
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.auto_awesome), // Icône IA standard
            tooltip: "Générer avec l'IA",
            onPressed: _isGeneratingAi ? null : () => _ouvrirDialogueAi(context),
          ),
        ],
      ),
      body: BlocConsumer<DevisBloc, DevisState>(
        listener: (context, state) {
          // 1. Désactiver le chargement IA dans les cas de fin (succès ou erreur)
          if (state is DevisAiGenerated ||
              state is DevisError ||
              state is DevisCreated ||
              state is DevisAiClientNotFound) {
            setState(() => _isGeneratingAi = false);
          }

          if (state is DevisCreated) {
            context.go('/devis');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.quoteCreatedSuccess(state.devis.numero))));
          }

          // 2. Le devis a déjà été créé côté backend par l'IA → redirection
          //    directe vers son détail, comme sur le web.
          if (state is DevisAiGenerated) {
            final responseData = state.data;
            final devisId = responseData['id'];

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Devis généré avec succès par l'IA !")),
            );

            if (devisId != null) {
              context.go('/devis/$devisId');
            } else {
              // Fallback de sécurité si jamais l'id n'est pas présent dans la réponse
              context.go('/devis');
            }
          }

          // 3. Client détecté par l'IA mais introuvable en base
          //    → on propose de l'ajouter directement, comme sur le web.
          if (state is DevisAiClientNotFound) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Client "${state.clientNom}" introuvable. Ajoutez-le pour continuer.'),
                backgroundColor: Colors.orange,
              ),
            );
            _naviguerVersAjoutClient(context, nomDetecte: state.clientNom);
          }

          if (state is DevisError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label(l10n.clientLabel),
                  ClientDropdownSelector(
                    selectedClient: _selectedClient,
                    onSelected: (c) => setState(() => _selectedClient = c),
                  ),
                  const SizedBox(height: 20),

                  _Label(l10n.validUntilLabel),
                  CustomDatePickerField(
                    date: _dateValidite,
                    hintText: l10n.selectValidityDateHint,
                    onPick: (d) => setState(() => _dateValidite = d),
                  ),
                  const SizedBox(height: 20),

                  _Label(l10n.vatRateLabel),
                  TextFormField(
                    controller: _tvaCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: _inputDecoration(hint: l10n.vatRateHint),
                  ),
                  const SizedBox(height: 20),

                  _Label(l10n.paymentMethodLabel),
                  PaymentSelector(
                    selected: _modePaiement,
                    onSelect: (v) => setState(() => _modePaiement = v),
                  ),
                  const SizedBox(height: 20),

                  _Label(l10n.addProductsOrServicesLabel),
                  LigneProduitFormWidget(
                    onAdd: (l) => setState(() => _lignes.add(l)),
                  ),
                  const SizedBox(height: 12),

                  if (_lignes.isNotEmpty) ...[
                    _Label(l10n.addedItemsLabel),
                    ..._lignes.asMap().entries.map((e) {
                      final i = e.key;
                      final l = e.value;
                      return DocumentLineItemRow(
                        libelle: l['libelle'].toString(),
                        prixUnitaire: double.tryParse(l['prix_unitaire'].toString()) ?? 0.0,
                        quantite: double.tryParse(l['quantite'].toString()) ?? 0.0,
                        onDelete: () => setState(() => _lignes.removeAt(i)),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],

                  _Label(l10n.specialConditionsOptionalLabel),
                  TextFormField(
                    controller: _conditionsCtrl,
                    maxLines: 2,
                    decoration: _inputDecoration(hint: l10n.specialConditionsHint),
                  ),
                  const SizedBox(height: 20),

                  FinancialTotalsCard(
                    totalHt: _totalHt,
                    totalTtc: _totalTtc,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state is DevisLoading ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: state is DevisLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : Text(
                        l10n.createQuoteButton,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _Label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 2),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
    ),
  );

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
  );

  void _ouvrirDialogueAi(BuildContext context) {
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poignée de fermeture / Indicateur de sheet
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // En-tête avec icône IA stylisée
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Assistant IA TPE Manager",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Générez votre devis à partir d'un texte brut",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Champ de texte moderne
              TextField(
                controller: textController,
                maxLines: 4,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Ex : Devis pour Jean Dupont, 2 sites web à 1500€ pièce...",
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Annuler",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final texte = textController.text.trim();
                          if (texte.isEmpty) return;

                          Navigator.pop(dialogContext);
                          _dernierTexteAi = texte;
                          setState(() => _isGeneratingAi = true);
                          context.read<DevisBloc>().add(GenerateDevisFromText(texte));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome, size: 18, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Générer le devis",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _naviguerVersAjoutClient(BuildContext context, {required String nomDetecte}) async {
    final result = await Navigator.push<ClientModel>(
      context,
      MaterialPageRoute(
        builder: (_) => ClientCreatePage(initialNom: nomDetecte),
      ),
    );

    if (!context.mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Client ajouté ! Génération du devis en cours...")),
      );


      if (_dernierTexteAi != null) {
        setState(() => _isGeneratingAi = true);
        context.read<DevisBloc>().add(GenerateDevisFromText(_dernierTexteAi!));
      }
    }
  }
}