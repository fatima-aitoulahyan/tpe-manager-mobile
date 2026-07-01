import 'package:flutter/material.dart';
import 'dart:math' as math;

class EligibiliteGauge extends StatelessWidget {
  final double score;
  final String niveau;

  const EligibiliteGauge({
    super.key,
    required this.score,
    required this.niveau,
  });

  Color get _color {
    switch (niveau) {
      case 'VERT':   return const Color(0xFF10B981);
      case 'ORANGE': return const Color(0xFFF59E0B);
      case 'ROUGE':  return const Color(0xFFEF4444);
      default:       return Colors.grey;
    }
  }

  String get _label {
    switch (niveau) {
      case 'VERT':   return 'Éligibilité élevée';
      case 'ORANGE': return 'Éligibilité moyenne';
      case 'ROUGE':  return 'Éligibilité faible';
      default:       return 'Non évalué';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: 160, height: 100,
        child: CustomPaint(
          painter: _GaugePainter(
              score: score, color: _color),
        ),
      ),
      const SizedBox(height: 8),
      Text('${score.toStringAsFixed(0)}/100',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: _color,
        ),
      ),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(_label,
          style: TextStyle(
            color: _color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ]);
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color  color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, math.pi, false, bgPaint,
    );
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final sweepAngle = math.pi * (score / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, sweepAngle, false, fgPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.score != score || old.color != color;
}