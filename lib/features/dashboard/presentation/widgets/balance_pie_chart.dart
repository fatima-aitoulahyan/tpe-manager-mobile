import 'package:flutter/material.dart';
import '../../../../shared/utils/currency_format.dart';
import '../../../../l10n/app_localizations.dart';

class BalancePieChart extends StatelessWidget {
  final double recettes;
  final double depenses;

  const BalancePieChart({
    super.key,
    required this.recettes,
    required this.depenses,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = recettes + depenses;
    final rPct = total > 0 ? (recettes / total * 100).toStringAsFixed(1) : '0.0';
    final dPct = total > 0 ? (depenses / total * 100).toStringAsFixed(1) : '0.0';
    final sweep = total > 0 ? recettes / total : 0.5;

    return Row(
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: CustomPaint(painter: _PiePainter(recettesFraction: sweep)),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PieLegendRow(color: const Color(0xFF10B981), label: l10n.incomeLegendLabel, pct: rPct, value: recettes),
              const SizedBox(height: 10),
              _PieLegendRow(color: const Color(0xFFEF4444), label: l10n.expensesLegendLabel, pct: dPct, value: depenses),
            ],
          ),
        ),
      ],
    );
  }
}

class _PiePainter extends CustomPainter {
  final double recettesFraction;

  const _PiePainter({required this.recettesFraction});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, -1.5708, recettesFraction * 6.2832, true, Paint()..color = const Color(0xFF10B981));
    canvas.drawArc(rect, -1.5708 + recettesFraction * 6.2832, (1 - recettesFraction) * 6.2832, true, Paint()..color = const Color(0xFFEF4444));
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * 0.32, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_PiePainter old) => old.recettesFraction != recettesFraction;
}

class _PieLegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String pct;
  final double value;

  const _PieLegendRow({
    required this.color,
    required this.label,
    required this.pct,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration:  BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label ($pct%)',
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              Text(
                '${value.toDH()} ',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}