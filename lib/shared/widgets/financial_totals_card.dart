import 'package:flutter/material.dart';
import 'package:tpe_mobile/shared/utils/currency_format.dart';
import '../../../../l10n/app_localizations.dart';

class FinancialTotalsCard extends StatelessWidget {
  final double totalHt;
  final double totalTtc;

  const FinancialTotalsCard({
    super.key,
    required this.totalHt,
    required this.totalTtc,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.totalHtLabel, style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
              Text('${totalHt.toDH()} ',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Color(0xFFF1F5F9), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.totalTtcLabel, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
              Text(
                '${totalTtc.toDH()} ',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}