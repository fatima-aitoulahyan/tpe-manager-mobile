import 'package:flutter/material.dart';
import '../../data/models/demande_model.dart';
import 'statut_demande_badge.dart';

class DemandeCard extends StatelessWidget {
  final DemandeListModel demande;
  final VoidCallback     onTap;
  final VoidCallback?    onDelete;

  const DemandeCard({
    super.key,
    required this.demande,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(demande.typeFinancementDisplay,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Text(
                '${demande.montantDemande.toStringAsFixed(0)} MAD',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatutDemandeBadge(statut: demande.statut),
              Row(children: [
                Text('${demande.dureeMois} mois',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF94A3B8))),
                if (onDelete != null) ...[
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(Icons.delete_outline,
                        size: 18, color: Colors.red),
                  ),
                ],
              ]),
            ],
          ),
          if (demande.motifRefus != null &&
              demande.motifRefus!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Motif : ${demande.motifRefus}',
                  style: const TextStyle(
                      fontSize: 11, color: Colors.red)),
            ),
          ],
        ]),
      ),
    );
  }
}