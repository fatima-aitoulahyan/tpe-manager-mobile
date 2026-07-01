import 'package:flutter/material.dart';

class StatutDemandeBadge extends StatelessWidget {
  final String statut;
  const StatutDemandeBadge({super.key, required this.statut});

  Color get _color {
    switch (statut) {
      case 'SOUMISE':           return Colors.grey;
      case 'EN_ANALYSE':         return Colors.orange;
      case 'FAVORABLE':          return Colors.green;
      case 'DEFAVORABLE':        return Colors.red;
      case 'DOSSIER_INCOMPLET':  return Colors.deepOrange;
      default:                  return Colors.grey;
    }
  }

  String get _label {
    switch (statut) {
      case 'SOUMISE':           return 'Soumise';
      case 'EN_ANALYSE':         return 'En analyse';
      case 'FAVORABLE':          return 'Favorable';
      case 'DEFAVORABLE':        return 'Défavorable';
      case 'DOSSIER_INCOMPLET':  return 'Incomplet';
      default:                  return statut;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(_label,
          style: TextStyle(
              color: _color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}