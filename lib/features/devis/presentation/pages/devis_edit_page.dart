import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../clients/data/datasources/client_remote_datasource.dart';
import '../../../clients/data/models/client_model.dart';
import '../../../clients/presentation/widgets/client_dropdown_selector.dart';
import '../../data/datasources/devis_remote_datasource.dart';
import '../../data/models/devis_model.dart';
import '../bloc/devis_bloc.dart';
import '../bloc/devis_event.dart';
import '../bloc/devis_state.dart';
import '../../../../shared/widgets/ligne_devis_form.dart';

class DevisEditPage extends StatelessWidget {
  final int id;
  const DevisEditPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DevisBloc(
        DevisRemoteDataSource(),
        ClientRemoteDataSource(),
      )..add(LoadDevisForEdit(id)),
      child: _DevisEditView(id: id),
    );
  }
}

class _DevisEditView extends StatefulWidget {
  final int id;
  const _DevisEditView({required this.id});

  @override
  State<_DevisEditView> createState() => _DevisEditViewState();
}

class _DevisEditViewState extends State<_DevisEditView> {
  final _formKey            = GlobalKey<FormState>();
  final _conditionsCtrl     = TextEditingController();
  final _tvaCtrl            = TextEditingController();
  DateTime? _dateValidite;
  String _modePaiement      = 'VIREMENT';
  ClientModel? _selectedClient;
  List<Map<String, dynamic>> _lignes = [];

  bool _initialized = false;

  final List<String> _modesPaiement = [
    'ESPECES', 'VIREMENT', 'MOBILE_MONEY'
  ];

  void _initFromDevis(DevisModel devis) {
    if (_initialized) return;
    _initialized = true;

    _tvaCtrl.text        = devis.tauxTva.toString();
    _conditionsCtrl.text = devis.conditions ?? '';
    _modePaiement        = devis.modePaiement;
    _dateValidite        = DateTime.tryParse(devis.dateValidite);
    _selectedClient      = devis.clientDetail;

    _lignes = devis.lignes.map<Map<String, dynamic>>((l) => {
      'libelle':       l.libelle,
      'prix_unitaire': l.prixUnitaire.toDouble(),
      'quantite':      l.quantite.toDouble(),
    }).toList();
  }

  double get _totalHt => _lignes.fold(0.0, (sum, l) =>
  sum + (double.tryParse(l['prix_unitaire'].toString()) ?? 0.0)
      * (double.tryParse(l['quantite'].toString()) ?? 0.0));

  double get _totalTtc {
    final tva = double.tryParse(_tvaCtrl.text) ?? 0;
    return _totalHt * (1 + tva / 100);
  }

  String _labelModePaiement(String mode) {
    switch (mode) {
      case 'ESPECES':      return 'Espèces';
      case 'VIREMENT':     return 'Virement';
      case 'MOBILE_MONEY': return 'Mobile Money';
      default:             return mode;
    }
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner un client')));
      return;
    }
    if (_dateValidite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner une date de validité')));
      return;
    }
    if (_lignes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez ajouter au moins une ligne de prestation')));
      return;
    }

    context.read<DevisBloc>().add(EditDevis(widget.id, {
      'client':        _selectedClient!.id,
      'date_validite': _dateValidite!.toIso8601String().split('T')[0],
      'taux_tva':      double.tryParse(_tvaCtrl.text) ?? 0,
      'mode_paiement': _modePaiement,
      'conditions':    _conditionsCtrl.text.trim(),
      'lignes':        _lignes,
    }));
  }

  @override
  void dispose() {
    _conditionsCtrl.dispose();
    _tvaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Modifier le Devis',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('/devis'),
        ),
      ),
      body: BlocConsumer<DevisBloc, DevisState>(
        listenWhen: (previous, current) =>
        current is DevisEditSuccess || current is DevisError,
        buildWhen: (previous, current) =>
        current is DevisLoading ||
            current is DevisLoadedForEdit ||
            current is DevisError,
        listener: (context, state) {
          if (state is DevisEditSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(
                    'Devis ${state.devis.numero} mis à jour avec succès !')));
            context.go('/devis/${widget.id}');
          }
          if (state is DevisError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message),
                    backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {

          if (state is DevisLoading) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFF2563EB)));
          }

          if (state is DevisError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline,
                      size: 64, color: Colors.orange),
                  const SizedBox(height: 12),
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/devis/${widget.id}'),
                    child: const Text('Retour au détail'),
                  ),
                ],
              ),
            );
          }

          if (state is DevisLoadedForEdit) {
            _initFromDevis(state.devis);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue[700], size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Vous modifiez actuellement un brouillon de devis. '
                              'Les modifications seront enregistrées immédiatement.',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  _SectionTitle('Client'),
                  ClientDropdownSelector(
                    selectedClient: _selectedClient,
                    onSelected: (client) =>
                        setState(() => _selectedClient = client),
                  ),
                  const SizedBox(height: 16),

                  _SectionTitle('Valable jusqu\'au'),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dateValidite ??
                            DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now()
                            .add(const Duration(days: 365)),
                        locale: const Locale('fr', 'FR'),
                      );
                      if (picked != null) {
                        setState(() => _dateValidite = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          _dateValidite != null
                              ? _dateValidite!
                              .toIso8601String().split('T')[0]
                              : 'Sélectionner une date',
                          style: TextStyle(
                            color: _dateValidite != null
                                ? Colors.black : Colors.grey,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle('TVA (%)'),
                            TextFormField(
                              controller: _tvaCtrl,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: _inputDecoration(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle('Mode de paiement'),
                            DropdownButtonFormField<String>(
                              value: _modePaiement,
                              isExpanded: true,
                              items: _modesPaiement.map((m) => DropdownMenuItem(
                                value: m,
                                child: Text(
                                  _labelModePaiement(m),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )).toList(),
                              onChanged: (v) => setState(() => _modePaiement = v!),
                              decoration: _inputDecoration(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _SectionTitle('Lignes de prestation'),
                  if (_lignes.isNotEmpty) ...[
                    ..._lignes.asMap().entries.map((e) {
                      final i = e.key;
                      final l = e.value;
                      final total = (l['prix_unitaire'] as double) *
                          (l['quantite'] as double);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l['libelle'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  '${l['prix_unitaire']} MAD × ${l['quantite']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text('${total.toStringAsFixed(2)} MAD',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.close,
                                size: 16, color: Colors.red),
                            onPressed: () =>
                                setState(() => _lignes.removeAt(i)),
                          ),
                        ]),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],

                  LigneProduitFormWidget(
                    onAdd: (Map<String, dynamic> ligne) {
                      setState(() => _lignes.add(ligne));
                    },
                  ),
                  const SizedBox(height: 16),

                  _SectionTitle('Conditions particulières (optionnel)'),
                  TextFormField(
                    controller: _conditionsCtrl,
                    maxLines: 3,
                    decoration: _inputDecoration(
                        hint: 'Ex: Règlement sous 30 jours...'),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total HT', style: TextStyle(color: Colors.grey)),
                          Text('${_totalHt.toStringAsFixed(2)} MAD', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total TTC',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('${_totalTtc.toStringAsFixed(2)} MAD',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state is DevisLoading
                          ? null
                          : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state is DevisLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text('Enregistrer les modifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _SectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 4),
    child: Text(title,
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
  );

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 12),
  );
}