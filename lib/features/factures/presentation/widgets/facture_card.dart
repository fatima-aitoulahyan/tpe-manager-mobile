import 'package:flutter/material.dart';

class FactureCard extends StatelessWidget {
  final dynamic facture;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const FactureCard({
    super.key,
    required this.facture,
    required this.onTap,
    this.onDelete,
  });

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAYEE':               return const Color(0xFF10B981);
      case 'PARTIELLEMENT_PAYEE': return const Color(0xFFF59E0B);
      case 'ENVOYE':              return const Color(0xFF3B82F6);
      case 'EN_ATTENTE':          return const Color(0xFF8B5CF6);
      case 'ARCHIVE':             return const Color(0xFF94A3B8);
      case 'BROUILLON':
      default:                    return const Color(0xFF64748B);
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PAYEE':               return 'Payée';
      case 'PARTIELLEMENT_PAYEE': return 'Partielle';
      case 'ENVOYE':              return 'Envoyée';
      case 'EN_ATTENTE':          return 'En attente';
      case 'ARCHIVE':             return 'Archivée';
      case 'BROUILLON':
      default:                    return 'Brouillon';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(facture.statut);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    facture.numero ?? 'N° Inconnu',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusLabel(facture.statut),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                (facture.clientName != null && facture.clientName.toString().trim().isNotEmpty)
                    ? facture.clientName.toString()
                    : 'Client inconnu',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 12),

              const Divider(color: Color(0xFFF1F5F9), height: 1),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (facture.dateEcheance != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 6),
                        Text(
                          facture.dateEcheance!.toString().split(' ')[0],
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),

                  Row(
                    children: [
                      Text(
                        '${(facture.montantTtc ?? 0.0).toStringAsFixed(2)} MAD',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      if (onDelete != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                          onPressed: onDelete,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}