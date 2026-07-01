import 'package:flutter/material.dart';
import '../../data/models/dashboard_model.dart';

class DevisActivityCard extends StatelessWidget {
  final DevisStats devisStats;

  const DevisActivityCard({super.key, required this.devisStats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Activité des devis', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total des devis générés', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('${devisStats.totalQuotes}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                    child: Text('Conversion : ${devisStats.conversionRate}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  )
                ],
              ),
              const SizedBox(height: 20),
              _SegmentedProgressBar(
                total: devisStats.totalQuotes,
                accepte: devisStats.byStatus['ACCEPTE'] ?? 0,
                envoye: devisStats.byStatus['ENVOYE'] ?? 0,
                refuse: devisStats.byStatus['REFUSE'] ?? 0,
                expire: devisStats.byStatus['EXPIRE'] ?? 0,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  _StatusIndicator(label: 'Acceptés', count: devisStats.byStatus['ACCEPTE'] ?? 0, color: const Color(0xFF10B981)),
                  _StatusIndicator(label: 'En attente', count: devisStats.byStatus['ENVOYE'] ?? 0, color: Colors.orange),
                  _StatusIndicator(label: 'Refusés', count: devisStats.byStatus['REFUSE'] ?? 0, color: const Color(0xFF64748B)),
                  _StatusIndicator(label: 'Expirés', count: devisStats.byStatus['EXPIRE'] ?? 0, color: const Color(0xFFEF4444)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  final int total;
  final int accepte;
  final int envoye;
  final int refuse;
  final int expire;

  const _SegmentedProgressBar({
    required this.total,
    required this.accepte,
    required this.envoye,
    required this.refuse,
    required this.expire,
  });

  @override
  Widget build(BuildContext context) {
    final t = total == 0 ? 1 : total;
    final pAccepte = accepte / t;
    final pEnvoye = envoye / t;
    final pRefuse = refuse / t;
    final pExpire = expire / t;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 10,
        width: double.infinity,
        child: total == 0
            ? Container(color: const Color(0xFFF1F5F9))
            : Row(
          children: [
            if (accepte > 0) Expanded(flex: (pAccepte * 100).toInt(), child: Container(color: const Color(0xFF10B981))),
            if (envoye > 0) Expanded(flex: (pEnvoye * 100).toInt(), child: Container(color: Colors.orange)),
            if (refuse > 0) Expanded(flex: (pRefuse * 100).toInt(), child: Container(color: const Color(0xFF64748B))),
            if (expire > 0) Expanded(flex: (pExpire * 100).toInt(), child: Container(color: const Color(0xFFEF4444))),
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatusIndicator({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('$label : ', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
      ],
    );
  }
}