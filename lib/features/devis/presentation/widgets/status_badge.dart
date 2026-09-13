import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

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

  String _getLabel(String statut, AppLocalizations l10n) {
    switch (statut) {
      case 'BROUILLON': return l10n.statusDraft;
      case 'ENVOYE':    return l10n.statusSent;
      case 'ACCEPTE':   return l10n.statusAccepted;
      case 'REFUSE':    return l10n.statusRefused;
      case 'EXPIRE':    return l10n.statusExpired;
      case 'ARCHIVE':   return l10n.statusArchived;
      default:          return statut;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Text(
        _getLabel(statut, l10n),
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}