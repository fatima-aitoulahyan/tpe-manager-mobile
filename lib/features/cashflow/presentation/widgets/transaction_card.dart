import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  String _categorieLabel(String? cat) {
    const labels = {
      'PAIEMENT_FACTURE': 'Paiement facture',
      'ACOMPTE':          'Acompte',
      'AUTRE_RECETTE':    'Autre recette',
      'ACHAT_MATERIEL':   'Achat matériel',
      'LOYER':            'Loyer',
      'SALAIRE':          'Salaire',
      'TRANSPORT':        'Transport',
      'AUTRE_DEPENSE':    'Autre dépense',
    };
    return labels[cat] ?? cat ?? '';
  }

  IconData _categorieIcon(String? cat) {
    const icons = {
      'PAIEMENT_FACTURE': Icons.receipt_long_outlined,
      'ACOMPTE':          Icons.payments_outlined,
      'ACHAT_MATERIEL':   Icons.shopping_bag_outlined,
      'LOYER':            Icons.home_outlined,
      'SALAIRE':          Icons.person_outline,
      'TRANSPORT':        Icons.directions_car_outlined,
    };
    return icons[cat] ?? Icons.category_outlined;
  }
  void _showDetailsBottomSheet(BuildContext context) {
    final isRecette = transaction.isRecette;
    final color     = isRecette ? Colors.green : Colors.red;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (dialogContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(_categorieIcon(transaction.categorie), color: color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _categorieLabel(transaction.categorie),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isRecette ? 'RECETTE' : 'DÉPENSE',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Center(
                  child: Column(
                    children: [
                      const Text('Montant de la transaction', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        '${isRecette ? '+' : '-'}${transaction.montant.toStringAsFixed(2)} MAD',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF1F5F9)),
                const SizedBox(height: 16),

                _buildDetailRow('Description', transaction.description),
                const SizedBox(height: 14),
                _buildDetailRow("Date du paiement", transaction.date),

                if (transaction.categorie == 'PAIEMENT_FACTURE') ...[
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text("Justificatif", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(dialogContext);
                            if (transaction.factureId != null) {
                              context.go('/factures/${transaction.factureId}');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Impossible de charger le lien de la facture.'))
                              );
                            }
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.link, size: 16, color: Color(0xFF2563EB)),
                              SizedBox(width: 4),
                              Text(
                                "Voir la facture",
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : 'Aucune description',
            style: const TextStyle(color: Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRecette = transaction.isRecette;
    final color     = isRecette ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showDetailsBottomSheet(context),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                  _categorieIcon(transaction.categorie),
                  color: color, size: 20),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _categorieLabel(transaction.categorie),
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(transaction.date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ]),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isRecette ? '+' : '-'}${transaction.montant.toStringAsFixed(2)} MAD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),

              ],
            ),
          ]),
        ),
      ),
    );
  }
}