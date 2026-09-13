import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/cashflow_remote_datasource.dart';
import '../bloc/cashflow_bloc.dart';
import '../bloc/cashflow_event.dart';
import '../../../../l10n/app_localizations.dart';

class AddTransactionSheet extends StatefulWidget {
  final String? initialType;
  final String? initialCategorie;
  final double? initialMontant;
  final String? initialDescription;
  final int?    factureId;
  final void Function(double montant)? onSaved;

  const AddTransactionSheet({
    super.key,
    this.initialType,
    this.initialCategorie,
    this.initialMontant,
    this.initialDescription,
    this.factureId,
    this.onSaved,
  });

  static Future<bool?> show(
      BuildContext context, {
        String?       initialType,
        String?       initialCategorie,
        double?       initialMontant,
        String?       initialDescription,
        int?          factureId,
        void Function(double montant)? onSaved,
      }) {
    CashflowBloc? existingBloc;
    try {
      existingBloc = context.read<CashflowBloc>();
    } catch (_) {
      existingBloc = null;
    }

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => existingBloc != null
          ? BlocProvider.value(
        value: existingBloc,
        child: AddTransactionSheet(
          initialType:        initialType,
          initialCategorie:   initialCategorie,
          initialMontant:     initialMontant,
          initialDescription: initialDescription,
          factureId:          factureId,
          onSaved:            onSaved,
        ),
      )
          : BlocProvider(
        create: (_) => CashflowBloc(CashflowRemoteDataSource()),
        child: AddTransactionSheet(
          initialType:        initialType,
          initialCategorie:   initialCategorie,
          initialMontant:     initialMontant,
          initialDescription: initialDescription,
          factureId:          factureId,
          onSaved:            onSaved,
        ),
      ),
    );
  }

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  late String   _type;
  String?       _categorie;
  DateTime      _date = DateTime.now();
  late final TextEditingController _montantCtrl;
  late final TextEditingController _descriptionCtrl;
  final _formKey = GlobalKey<FormState>();

  bool get _isFromFacture => widget.factureId != null;

  static const Color _successColor = Color(0xFF10B981);
  static const Color _dangerColor = Color(0xFFEF4444);
  static const Color _primaryBlue = Color(0xFF2563EB);

  bool get _isRecette => _type == 'RECETTE';

  @override
  void initState() {
    super.initState();
    _type      = widget.initialType      ?? 'RECETTE';
    _categorie = widget.initialCategorie;
    _montantCtrl     = TextEditingController(
      text: widget.initialMontant != null
          ? widget.initialMontant!.toStringAsFixed(2)
          : '',
    );
    _descriptionCtrl = TextEditingController(
      text: widget.initialDescription ?? '',
    );
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_categorie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectCategoryError), behavior: SnackBarBehavior.floating));
      return;
    }
    final montant = double.parse(_montantCtrl.text);

    if (widget.factureId != null) {
      widget.onSaved?.call(montant);
      Navigator.pop(context, true);
      return;
    }

    context.read<CashflowBloc>().add(AddTransaction({
      'type':        _type,
      'montant':     montant,
      'description': _descriptionCtrl.text.trim(),
      'categorie':   _categorie,
      'date':        _date.toIso8601String().split('T')[0],
    }));

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _montantCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final activeColor = _isRecette ? _successColor : _dangerColor;

    final categoriesRecette = [
      {'value': 'PAIEMENT_FACTURE', 'label': l10n.catPaymentInvoice,  'icon': Icons.receipt_long_outlined},
      {'value': 'ACOMPTE',          'label': l10n.catDeposit,           'icon': Icons.payments_outlined},
      {'value': 'AUTRE_RECETTE',    'label': l10n.catOtherIncome,     'icon': Icons.add_circle_outline},
    ];

    final categoriesDepense = [
      {'value': 'ACHAT_MATERIEL', 'label': l10n.catEquipmentPurchase,  'icon': Icons.shopping_bag_outlined},
      {'value': 'LOYER',          'label': l10n.catRent,            'icon': Icons.home_outlined},
      {'value': 'SALAIRE',        'label': l10n.catSalary,          'icon': Icons.person_outline},
      {'value': 'TRANSPORT',      'label': l10n.catTransport,        'icon': Icons.directions_car_outlined},
      {'value': 'AUTRE_DEPENSE',  'label': l10n.catOtherExpense,   'icon': Icons.more_horiz},
    ];

    final currentCategories = _type == 'RECETTE' ? categoriesRecette : categoriesDepense;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44, height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isFromFacture ? l10n.registerPaymentTitle : l10n.newTransactionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A), letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            Text(
              _isFromFacture ? l10n.paymentLinkedToInvoice : l10n.registerPaymentOrExpenseSubtitle,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 24),

            if (!_isFromFacture) ...[
              _label(l10n.transactionTypeLabel),
              Row(children: [
                Expanded(child: _TypeButton(
                  label: l10n.paymentReceivedType, icon: Icons.arrow_downward_rounded,
                  color: _successColor, selected: _isRecette,
                  onTap: () => setState(() { _type = 'RECETTE'; _categorie = null; }),
                )),
                const SizedBox(width: 12),
                Expanded(child: _TypeButton(
                  label: l10n.expenseType, icon: Icons.arrow_upward_rounded,
                  color: _dangerColor, selected: !_isRecette,
                  onTap: () => setState(() { _type = 'DEPENSE'; _categorie = null; }),
                )),
              ]),
              const SizedBox(height: 20),
            ],

            _label(l10n.categoryLabel),
            if (_isFromFacture)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _successColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _successColor, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.receipt_long_outlined, size: 16, color: _successColor),
                    const SizedBox(width: 8),
                    Text(l10n.catPaymentInvoice,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _successColor)),
                    const SizedBox(width: 8),
                    Icon(Icons.lock_outline, size: 13, color: _successColor.withValues(alpha: 0.8)),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 8, runSpacing: 8,
                children: currentCategories.map((c) {
                  final val      = c['value'] as String;
                  final label    = c['label'] as String;
                  final icon     = c['icon']  as IconData;
                  final selected = _categorie == val;
                  return GestureDetector(
                    onTap: () => setState(() => _categorie = val),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? activeColor.withValues(alpha: 0.08) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? activeColor : const Color(0xFFE2E8F0),
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 15,
                              color: selected ? activeColor : const Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(label,
                            style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600,
                              color: selected ? activeColor : const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),

            _label(l10n.amountDhLabel),
            TextFormField(
              controller: _montantCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.fieldRequiredError;
                if (double.tryParse(v) == null) return l10n.invalidAmountError;
                if (double.parse(v) <= 0) return l10n.greaterThanZeroError;
                return null;
              },
              decoration: _inputDecoration(hint: l10n.amountHint),
            ),
            const SizedBox(height: 16),

            _label(l10n.descriptionLabel),
            TextFormField(
              controller: _descriptionCtrl,
              style: const TextStyle(color: Color(0xFF0F172A)),
              validator: (v) => v == null || v.isEmpty ? l10n.fieldRequiredError : null,
              decoration: _inputDecoration(
                  hint: _isRecette ? l10n.descriptionRecetteHint : l10n.descriptionDepenseHint),
            ),
            const SizedBox(height: 16),

            _label(l10n.transactionDateLabel),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(primary: _primaryBlue),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: _primaryBlue),
                  const SizedBox(width: 10),
                  Text(
                    '${_date.day.toString().padLeft(2, '0')}/'
                        '${_date.month.toString().padLeft(2, '0')}/'
                        '${_date.year}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isRecette ? Icons.check_circle_outline_rounded : Icons.remove_circle_outline_rounded,
                      color: Colors.white, size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isRecette ? l10n.savePaymentButton : l10n.saveExpenseButton,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 2),
    child: Text(text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
  );

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryBlue, width: 1.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _dangerColor, width: 1)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _dangerColor, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}

class _TypeButton extends StatelessWidget {
  final String    label;
  final IconData  icon;
  final Color     color;
  final bool      selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label, required this.icon, required this.color,
    required this.selected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : const Color(0xFFE2E8F0), width: selected ? 1.5 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: selected ? color.withValues(alpha: 0.15) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: selected ? color : const Color(0xFF94A3B8)),
            ),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
                    color: selected ? color : const Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}