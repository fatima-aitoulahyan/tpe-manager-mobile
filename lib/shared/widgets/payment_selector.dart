import 'package:flutter/material.dart';

class PaymentSelector extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const PaymentSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  static const _modesPaiement = [
    {'value': 'VIREMENT', 'label': 'Virement', 'sub': 'Bancaire', 'icon': Icons.account_balance_outlined},
    {'value': 'ESPECES', 'label': 'Espèces', 'sub': 'En main propre', 'icon': Icons.payments_outlined},
    {'value': 'MOBILE_MONEY', 'label': 'Mobile', 'sub': 'Money', 'icon': Icons.smartphone_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _modesPaiement.map((m) {
        final value = m['value'] as String;
        final label = m['label'] as String;
        final sub = m['sub'] as String;
        final icon = m['icon'] as IconData;
        final isSelected = selected == value;

        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.only(right: m == _modesPaiement.last ? 0 : 8),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2563EB).withOpacity(0.06) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2563EB).withOpacity(0.1) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 18, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 8),
                  Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF1E293B))),
                  Text(sub, style: TextStyle(fontSize: 11, color: isSelected ? const Color(0xFF2563EB).withOpacity(0.7) : const Color(0xFF94A3B8))),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}