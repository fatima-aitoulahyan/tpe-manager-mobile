import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String statut;

  const StatusBadge({super.key, required this.statut});

  Color get _color {
    switch (statut) {
      case 'BROUILLON': return Colors.grey;
      case 'ENVOYE':    return Colors.blue;
      case 'ACCEPTE':   return Colors.green;
      case 'REFUSE':    return Colors.red;
      case 'EXPIRE':    return Colors.orange;
      case 'ARCHIVE':   return Colors.blueGrey;
      default:          return Colors.grey;
    }
  }

  String get _label {
    switch (statut) {
      case 'BROUILLON': return 'Brouillon';
      case 'ENVOYE':    return 'Envoyé';
      case 'ACCEPTE':   return 'Accepté';
      case 'REFUSE':    return 'Refusé';
      case 'EXPIRE':    return 'Expiré';
      case 'ARCHIVE':   return 'Archivé';
      default:          return statut;
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
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}