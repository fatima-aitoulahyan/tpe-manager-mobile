import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

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

  String _getLabel(AppLocalizations l10n) {
    switch (statut) {
      case 'SOUMISE':           return l10n.statusSoumise;
      case 'EN_ANALYSE':         return l10n.statusEnAnalyse;
      case 'FAVORABLE':          return l10n.statusFavorable;
      case 'DEFAVORABLE':        return l10n.statusDefavorable;
      case 'DOSSIER_INCOMPLET':  return l10n.statusIncomplet;
      default:                  return statut;
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
      child: Text(_getLabel(l10n),
          style: TextStyle(
              color: _color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}