import 'package:flutter/material.dart';
import 'package:tpe_mobile/shared/utils/currency_format.dart';
import '../../../../l10n/app_localizations.dart';

class LigneProduitFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const LigneProduitFormWidget({super.key, required this.onAdd});

  @override
  State<LigneProduitFormWidget> createState() => _LigneDevisFormWidgetState();
}

class _LigneDevisFormWidgetState extends State<LigneProduitFormWidget> {
  final _libelleCtrl  = TextEditingController();
  final _prixCtrl     = TextEditingController();
  final _quantiteCtrl = TextEditingController();

  double get _total {
    final prix = double.tryParse(_prixCtrl.text) ?? 0;
    final qte  = double.tryParse(_quantiteCtrl.text) ?? 0;
    return prix * qte;
  }

  void _add() {
    if (_libelleCtrl.text.isEmpty ||
        _prixCtrl.text.isEmpty ||
        _quantiteCtrl.text.isEmpty) return;

    final prix = double.tryParse(_prixCtrl.text);
    final qte  = double.tryParse(_quantiteCtrl.text);

    if (prix == null || qte == null) return;

    final Map<String, dynamic> ligne = {
      'libelle':       _libelleCtrl.text.trim(),
      'prix_unitaire': prix,
      'quantite':      qte,
    };

    widget.onAdd(ligne);

    _libelleCtrl.clear();
    _prixCtrl.clear();
    _quantiteCtrl.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _libelleCtrl.dispose();
    _prixCtrl.dispose();
    _quantiteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.addLineTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _libelleCtrl,
            decoration: InputDecoration(
              labelText: l10n.designationLabel,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          Row(children: [
            Expanded(
              child: TextField(
                controller: _prixCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l10n.unitPriceLabel,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _quantiteCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l10n.quantityLabel,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalLineDisplay(_total.toDH()),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _add,
                icon: const Icon(Icons.add, size: 16),
                label: Text(l10n.addToDocumentButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}