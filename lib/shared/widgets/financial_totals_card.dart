import 'package:flutter/material.dart';

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
              const Text('Total HT', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
              Text('${totalHt.toStringAsFixed(2)} MAD',
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
              const Text('Total TTC', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
              Text(
                '${totalTtc.toStringAsFixed(2)} MAD',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}