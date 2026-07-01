import 'package:flutter/material.dart';

class BalanceBarChart extends StatelessWidget {
  final double recettes;
  final double depenses;

  const BalanceBarChart({
    super.key,
    required this.recettes,
    required this.depenses,
  });

  @override
  Widget build(BuildContext context) {
    final max = (recettes > depenses ? recettes : depenses).clamp(1.0, double.infinity);
    final rH = (recettes / max) * 130;
    final dH = (depenses / max) * 130;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Volume des flux',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Bar(height: rH, value: recettes, color: const Color(0xFF10B981)),
              _Bar(height: dH, value: depenses, color: const Color(0xFFEF4444)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Legend(color: const Color(0xFF10B981), label: 'Recettes'),
            const SizedBox(width: 24),
            _Legend(color: const Color(0xFFEF4444), label: 'Dépenses'),
          ],
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final double value;
  final Color color;

  const _Bar({required this.height, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value.toStringAsFixed(0),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate,
          width: 45,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2.5)),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}