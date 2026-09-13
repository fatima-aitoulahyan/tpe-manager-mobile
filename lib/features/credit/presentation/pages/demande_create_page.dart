import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasources/credit_remote_datasource.dart';
import '../bloc/credit_bloc.dart';
import '../bloc/credit_event.dart';
import '../bloc/credit_state.dart';
import '../../../../l10n/app_localizations.dart';

class DemandeCreatePage extends StatelessWidget {
  const DemandeCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreditBloc(CreditRemoteDataSource()),
      child: const _DemandeCreateView(),
    );
  }
}

class _DemandeCreateView extends StatefulWidget {
  const _DemandeCreateView();

  @override
  State<_DemandeCreateView> createState() => _DemandeCreateViewState();
}

class _DemandeCreateViewState extends State<_DemandeCreateView> {
  final _formKey       = GlobalKey<FormState>();
  final _montantCtrl   = TextEditingController();
  final _objetCtrl     = TextEditingController();
  String _typeFinancement = 'FONCTIONNEMENT';
  int    _dureeMois       = 12;
  bool   _consentement    = false;

  static const _durees = [3, 6, 12, 18, 24, 36];

  void _submit(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;
    if (!_consentement) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.consentRequiredError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<CreditBloc>().add(CreateDemande({
      'type_financement':  _typeFinancement,
      'montant_demande':   double.parse(_montantCtrl.text),
      'duree_mois':        _dureeMois,
      'objet_financement': _objetCtrl.text.trim(),
      'consentement_cndp': _consentement,
    }));
  }

  @override
  void dispose() {
    _montantCtrl.dispose();
    _objetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final types = [
      {
        'value': 'FONCTIONNEMENT',
        'label': l10n.creditFonctionnementLabel,
        'plafond': '200 000 DH',
        'icon': Icons.sync_outlined
      },
      {
        'value': 'INVESTISSEMENT',
        'label': l10n.creditInvestissementLabel,
        'plafond': '500 000 DH',
        'icon': Icons.trending_up_outlined
      },
      {
        'value': 'AVANCE_FACTURE',
        'label': l10n.avanceFactureLabel,
        'plafond': '100 000 DH',
        'icon': Icons.receipt_long_outlined
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.newRequestAppBarTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<CreditBloc, CreditState>(
        listener: (context, state) {
          if (state is DemandeCreated) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(l10n.requestSubmittedSuccess),
                    backgroundColor: Colors.green));
          }
          if (state is CreditError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message),
                    backgroundColor: Colors.red));
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
                  _Label(l10n.typeFinancementLabel),
                  ...types.map((t) {
                    final selected = _typeFinancement == t['value'];
                    return GestureDetector(
                      onTap: () => setState(
                              () => _typeFinancement = t['value'] as String),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF2563EB).withValues(alpha: 0.06)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF2563EB)
                                : const Color(0xFFE2E8F0),
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(children: [
                          Icon(t['icon'] as IconData,
                              color: selected
                                  ? const Color(0xFF2563EB) : Colors.grey,
                              size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t['label'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: selected
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF1E293B),
                                  ),
                                ),
                                Text('${l10n.plafondLabel} : ${t['plafond']}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                          ),
                          if (selected)
                            const Icon(Icons.check_circle,
                                color: Color(0xFF2563EB), size: 20),
                        ]),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  _Label(l10n.montantDemandeLabel),
                  TextFormField(
                    controller: _montantCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.requiredField;
                      if (double.tryParse(v) == null) {
                        return l10n.invalidAmount;
                      }
                      if (double.parse(v) <= 0) {
                        return l10n.mustBeGreaterThanZero;
                      }
                      return null;
                    },
                    decoration: _inputDecoration(hint: l10n.montantHint),
                  ),
                  const SizedBox(height: 16),

                  _Label(l10n.dureeSouhaiteeLabel),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _durees.map((d) {
                      final selected = _dureeMois == d;
                      return GestureDetector(
                        onTap: () => setState(() => _dureeMois = d),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF2563EB) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text('$d ${l10n.monthsLabel}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  _Label(l10n.objetFinancementLabel),
                  TextFormField(
                    controller: _objetCtrl,
                    maxLines: 3,
                    validator: (v) =>
                    v == null || v.isEmpty ? l10n.requiredField : null,
                    decoration: _inputDecoration(
                        hint: l10n.objetHint),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _consentement,
                          activeColor: const Color(0xFF2563EB),
                          onChanged: (v) =>
                              setState(() => _consentement = v ?? false),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              l10n.cndpConsentText,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state is CreditLoading
                          ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state is CreditLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : Text(l10n.submitRequestButton,
                        style: const TextStyle(
                          fontSize: 15,
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

  Widget _Label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Text(text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B))),
  );

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
          color: Color(0xFF2563EB), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 14, vertical: 13),
  );
}