import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../ bloc/facture_bloc.dart';
import '../ bloc/facture_event.dart';
import '../ bloc/facture_state.dart';
import '../../../../shared/utils/document_actions.dart';
import '../../../../shared/widgets/info_row_widget.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../cashflow/presentation/widgets/add_transaction_sheet.dart';
import '../../../clients/data/datasources/client_remote_datasource.dart';
import '../../../devis/presentation/widgets/status_badge.dart';
import '../../data/datasources/facture_remote_datasource.dart';
import '../../data/models/facture_model.dart';


class FactureDetailPage extends StatelessWidget {
  final int id;
  const FactureDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FactureBloc(
        FactureRemoteDataSource(),
        ClientRemoteDataSource(),
      )..add(LoadFactureDetail(id)),
      child: _FactureDetailView(id: id),
    );
  }
}

class _FactureDetailView extends StatefulWidget {
  final int id;
  const _FactureDetailView({required this.id});

  @override
  State<_FactureDetailView> createState() => _FactureDetailViewState();
}

class _FactureDetailViewState extends State<_FactureDetailView> {

  void _showPaymentDialog(BuildContext context, FactureModel f) {
    AddTransactionSheet.show(
      context,
      initialType:        'RECETTE',
      initialCategorie:   'PAIEMENT_FACTURE',
      initialMontant:     f.resteAPayer,
      initialDescription: 'Paiement facture ${f.numero}',
      factureId:          f.id,
      onSaved: (double montant) {
        context.read<FactureBloc>().add(
          RegisterFacturePayment(id: f.id, montant: montant),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Détail du Facture', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/factures'),
        ),
      ),
      body: BlocConsumer<FactureBloc, FactureState>(
        listener: (context, state) {
          if (state is FactureStatusChanged || state is FacturePaymentRegistered) {
            context.read<FactureBloc>().add(LoadFactureDetail(widget.id));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Facture mise à jour')));
          }
          if (state is FactureDeleted) context.go('/factures');
          if (state is FacturePdfReady) {
            DocumentActions.showPdfOptions(
              context: context,
              filePath: state.filePath,
              numero: state.numero,
            );
          }
          if (state is FactureError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
          if (state is FactureArchived) {
            context.go('/factures');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Facture archivée'),
                backgroundColor: Colors.grey,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FactureLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
          }

          if (state is FactureDetailLoaded || state is FacturePdfReady) {
            final f = (state is FactureDetailLoaded)
                ? state.facture
                : (state as FacturePdfReady).facture;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('Informations générales'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(f.numero, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                            StatusBadge(statut: f.statut),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Color(0xFFF1F5F9), height: 1),
                        ),
                        InfoRowWidget(
                          icon: Icons.person_outline,
                          text: f.clientDetail != null
                              ? '${f.clientDetail!.nom} ${f.clientDetail!.prenom}'.trim()
                              : f.clientNom,
                        ),
                        const SizedBox(height: 8),
                        if (f.clientDetail?.nomEntreprise != null && f.clientDetail!.nomEntreprise!.isNotEmpty) ...[
                          InfoRowWidget(icon: Icons.business_outlined, text: f.clientDetail!.nomEntreprise!),
                          const SizedBox(height: 8),
                        ],
                        if (f.clientDetail?.ice != null && f.clientDetail!.ice!.isNotEmpty) ...[
                          InfoRowWidget(icon: Icons.numbers_outlined, text: 'ICE : ${f.clientDetail!.ice!}'),
                          const SizedBox(height: 8),
                        ],
                        if (f.dateEcheance != null) ...[
                          InfoRowWidget(icon: Icons.calendar_today_outlined, text: 'Date d\'échéance : ${f.dateEcheance.toString().split(' ')[0]}'),
                          const SizedBox(height: 8),
                        ],
                        if (f.modePaiement != null && f.modePaiement!.isNotEmpty)
                          InfoRowWidget(icon: Icons.payment_outlined, text: 'Mode de règlement : ${f.modePaiement!}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const SectionTitle('Prestations'),
                  ...f.lignes.map((l) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.receipt_long_outlined, size: 16, color: Color(0xFF94A3B8)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.libelle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                              Text('${l.quantite % 1 == 0 ? l.quantite.toInt() : l.quantite} × ${l.prixUnitaire.toStringAsFixed(2)} MAD', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                        Text('${l.calculatedTotal.toStringAsFixed(2)} MAD', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),

                  const SectionTitle('Résumé financier'),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total HT', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                            Text('${f.montantHt.toStringAsFixed(2)} MAD', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TVA (${f.tauxTva}%)', style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                            Text('${(f.montantTtc - f.montantHt).toStringAsFixed(2)} MAD', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Color(0xFFF1F5F9), height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Montant Payé', style: TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.w500)),
                            Text('${f.montantPaye.toStringAsFixed(2)} MAD', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Reste à payer', style: TextStyle(fontSize: 13, color: Colors.orange, fontWeight: FontWeight.w500)),
                            Text('${f.resteAPayer.toStringAsFixed(2)} MAD', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.orange)),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Color(0xFFF1F5F9), height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total TTC', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                            Text('${f.montantTtc.toStringAsFixed(2)} MAD', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (f.estIssueDevis && f.devisNumero != null) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => context.go('/devis/${f.devisId}'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.link, size: 16, color: Color(0xFF2563EB)),
                            const SizedBox(width: 8),
                            Text('Issu du devis ${f.devisNumero}',
                                style: const TextStyle(fontSize: 13, color: Color(0xFF2563EB), fontWeight: FontWeight.w500)),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF2563EB)),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SectionTitle('Actions disponibles'),
                  if (f.statut == 'BROUILLON') ...[
                    _MenuButton(label: 'Modifier la facture', icon: Icons.edit_outlined, isPrimary: true, onTap: () => context.go('/factures/${f.id}/edit')),
                    _MenuButton(label: 'Valider et Envoyer', icon: Icons.send_outlined, onTap: () => context.read<FactureBloc>().add(ChangeFactureStatus(id: f.id, status: 'ENVOYE'))),
                    _MenuButton(
                      label: 'Supprimer',
                      icon: Icons.delete_outline,
                      isDanger: true,
                      onTap: () => DocumentActions.confirmDelete(
                        context: context,
                        title: 'Supprimer la facture',
                        onDeleteConfirm: () => context.read<FactureBloc>().add(DeleteFacture(f.id)),
                      ),
                    ),
                  ],
                  if (f.statut == 'ENVOYE' || f.statut == 'PARTIELLEMENT_PAYEE') ...[
                    _MenuButton(
                      label: 'Enregistrer un paiement',
                      icon: Icons.add_card_outlined,
                      isPrimary: true,
                      onTap: () => _showPaymentDialog(context, f),
                    ),
                    _MenuButton(
                      label: 'Relancer pour impayé',
                      icon: Icons.notifications_active_outlined,
                      onTap: () => DocumentActions.remindClient(
                        context: context,
                        docNumero: f.numero,
                        clientNom: f.clientDetail?.displayName ?? f.clientNom,
                        telephone: f.clientDetail?.telephone ?? f.clientTelephone,
                        email: f.clientDetail?.email ?? f.clientEmail,
                        montant: f.resteAPayer,
                        dateInfo: f.dateEcheance != null
                            ? "à régler avant le ${f.dateEcheance.toString().split(' ')[0]}"
                            : "dès que possible",
                      ),
                    ),
                  ],
                  if (f.statut == 'PAYEE' || f.statut == 'EN_ATTENTE' || f.statut == 'ENVOYE') ...[
                    _MenuButton(
                      label: 'Archiver la facture',
                      icon: Icons.archive_outlined,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Archiver la facture'),
                          content: const Text('Cette facture sera déplacée dans les archives. Continuer ?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<FactureBloc>().add(ArchiveFacture(f.id));
                              },
                              child: const Text('Archiver', style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Color(0xFFE2E8F0)),
                  ),
                  _MenuButton(
                    label: 'Télécharger / Partager le PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    onTap: () => context.read<FactureBloc>().add(DownloadFacturePdf(id: f.id, numero: f.numero)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isDanger;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 18, color: isPrimary ? Colors.white : (isDanger ? Colors.red : const Color(0xFF1E293B))),
          label: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isPrimary ? Colors.white : (isDanger ? Colors.red : const Color(0xFF1E293B)))),
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? const Color(0xFF2563EB) : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: isPrimary ? Colors.transparent : (isDanger ? Colors.red.withOpacity(0.3) : const Color(0xFFE2E8F0))),
            ),
          ),
        ),
      ),
    );
  }
}