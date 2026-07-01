import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../ bloc/facture_bloc.dart';
import '../ bloc/facture_event.dart';
import '../ bloc/facture_state.dart';
import '../../../clients/data/datasources/client_remote_datasource.dart';
import '../../../clients/data/models/client_model.dart';
import '../../../clients/presentation/widgets/client_dropdown_selector.dart';
import '../../../../shared/widgets/custom_date_picker_field.dart';
import '../../../../shared/widgets/document_line_item_row.dart';
import '../../../../shared/widgets/financial_totals_card.dart';
import '../../../../shared/widgets/payment_selector.dart';
import '../../../../shared/widgets/ligne_devis_form.dart';
import '../../data/datasources/facture_remote_datasource.dart';

class FactureCreatePage extends StatelessWidget {
  const FactureCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FactureBloc(
        FactureRemoteDataSource(),
        ClientRemoteDataSource(),
      )..add(LoadFactureClients()),
      child: const _FactureCreateView(),
    );
  }
}

class _FactureCreateView extends StatefulWidget {
  const _FactureCreateView();

  @override
  State<_FactureCreateView> createState() => _FactureCreateViewState();
}

class _FactureCreateViewState extends State<_FactureCreateView> {
  final _formKey        = GlobalKey<FormState>();
  final _conditionsCtrl = TextEditingController();
  final _tvaCtrl        = TextEditingController(text: '20');
  DateTime? _dateEcheance;
  String _modePaiement  = 'VIREMENT';
  ClientModel? _selectedClient;
  final List<Map<String, dynamic>> _lignes = [];

  double get _totalHt => _lignes.fold(0.0, (sum, l) =>
  sum + (double.tryParse(l['prix_unitaire'].toString()) ?? 0.0)
      * (double.tryParse(l['quantite'].toString()) ?? 0.0));

  double get _totalTtc {
    final tva = double.tryParse(_tvaCtrl.text) ?? 0;
    return _totalHt * (1 + tva / 100);
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner un client')));
      return;
    }
    if (_dateEcheance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner une date d\'échéance')));
      return;
    }
    if (_lignes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez ajouter au moins une ligne de prestation')));
      return;
    }
    context.read<FactureBloc>().add(CreateFacture({
      'client':        _selectedClient!.id,
      'date_echeance': _dateEcheance!.toIso8601String().split('T')[0],
      'taux_tva':      double.tryParse(_tvaCtrl.text) ?? 0,
      'mode_paiement': _modePaiement,
      'conditions':    _conditionsCtrl.text.trim(),
      'lignes':        _lignes,
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Nouvelle Facture', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/factures'),
        ),
      ),
      body: BlocConsumer<FactureBloc, FactureState>(
        listener: (context, state) {
          if (state is FactureCreated) {
            context.go('/factures');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Facture ${state.facture.numero} créée en brouillon !')));
          }
          if (state is FactureError) {
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

                  _Label('Client'),
                  ClientDropdownSelector(
                    selectedClient: _selectedClient,
                    onSelected: (c) => setState(() => _selectedClient = c),
                  ),
                  const SizedBox(height: 20),

                  _Label('Date d\'échéance'),
                  CustomDatePickerField(
                    date: _dateEcheance,
                    hintText: 'Sélectionner la date limite de règlement',
                    onPick: (d) => setState(() => _dateEcheance = d),
                  ),
                  const SizedBox(height: 20),

                  _Label('Taux de TVA (%)'),
                  TextFormField(
                    controller: _tvaCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: _inputDecoration(hint: 'Ex : 20'),
                  ),
                  const SizedBox(height: 20),

                  _Label('Mode de règlement requis'),
                  PaymentSelector(
                    selected: _modePaiement,
                    onSelect: (v) => setState(() => _modePaiement = v),
                  ),
                  const SizedBox(height: 20),

                  _Label('Détails des prestations / articles'),
                  LigneProduitFormWidget(
                    onAdd: (l) => setState(() => _lignes.add(l)),
                  ),
                  const SizedBox(height: 12),

                  if (_lignes.isNotEmpty) ...[
                    _Label('Éléments de facturation ajoutés'),
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

                  _Label('Conditions de règlement ou mentions légales'),
                  TextFormField(
                    controller: _conditionsCtrl,
                    maxLines: 2,
                    decoration: _inputDecoration(hint: 'Ex : Pénalités de retard de 10% après échéance...'),
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
                      onPressed: state is FactureLoading ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: state is FactureLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text(
                        'Générer la facture',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
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
}