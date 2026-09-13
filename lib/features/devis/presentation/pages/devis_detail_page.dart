import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/currency_format.dart';
import '../../../../shared/utils/document_actions.dart';
import '../../../../shared/widgets/info_row_widget.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../clients/data/datasources/client_remote_datasource.dart';
import '../../data/datasources/devis_remote_datasource.dart';
import '../bloc/devis_bloc.dart';
import '../bloc/devis_event.dart';
import '../bloc/devis_state.dart';
import '../widgets/status_badge.dart';
import '../../../../l10n/app_localizations.dart';

class DevisDetailPage extends StatelessWidget {
  final int id;
  const DevisDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DevisBloc(
        DevisRemoteDataSource(),
        ClientRemoteDataSource(),
      )..add(LoadDevisDetail(id)),
      child: _DevisDetailView(id: id),
    );
  }
}

class _DevisDetailView extends StatefulWidget {
  final int id;
  const _DevisDetailView({required this.id});

  @override
  State<_DevisDetailView> createState() => _DevisDetailViewState();
}

class _DevisDetailViewState extends State<_DevisDetailView> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.quoteDetailTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/devis'),
        ),
      ),
      body: BlocConsumer<DevisBloc, DevisState>(
          listener: (context, state) {
            if (state is DevisStatusChanged) context.read<DevisBloc>().add(LoadDevisDetail(widget.id));
            if (state is DevisDeleted) context.go('/devis');
            if (state is DevisDuplicated) context.go('/devis');

            if (state is DevisPdfReady) {
              DocumentActions.showPdfOptions(
                context: context,
                filePath: state.filePath,
                numero: state.numero,
              );
            }
            if (state is DevisConvertedToFacture) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.quoteConvertedSuccess),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/factures/${state.factureId}');
            }
            if (state is DevisError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            if (state is DevisLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
            }

            if (state is DevisDetailLoaded || state is DevisPdfReady) {
              final d = (state is DevisDetailLoaded)
                  ? state.devis
                  : (state as DevisPdfReady).devis;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SectionTitle(l10n.generalInformationTitle),
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
                              Text(d.numero, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              StatusBadge(statut: d.statut),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(color: Color(0xFFF1F5F9), height: 1),
                          ),

                          InfoRowWidget(icon: Icons.person_outline, text: '${d.clientDetail.nom} ${d.clientDetail.prenom}'.trim()),
                          const SizedBox(height: 8),

                          if (d.clientDetail.nomEntreprise != null && d.clientDetail.nomEntreprise!.isNotEmpty) ...[
                            InfoRowWidget(icon: Icons.business_outlined, text: d.clientDetail.nomEntreprise!),
                            const SizedBox(height: 8),
                          ],

                          if (d.clientDetail.ice != null && d.clientDetail.ice!.isNotEmpty) ...[
                            InfoRowWidget(icon: Icons.numbers_outlined, text: 'ICE : ${d.clientDetail.ice!}'),
                            const SizedBox(height: 8),
                          ],

                          InfoRowWidget(icon: Icons.calendar_today_outlined, text: '${l10n.validUntilPrefix} : ${d.dateValidite}'),
                          const SizedBox(height: 8),
                          InfoRowWidget(icon: Icons.payment_outlined, text: '${l10n.paymentLabel} : ${d.modePaiement}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    SectionTitle(l10n.servicesSectionTitle),
                    ...d.lignes.map((l) => Container(
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
                                Text('${l.quantite % 1 == 0 ? l.quantite.toInt() : l.quantite} × ${l.prixUnitaire.toDH()} ', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                              ],
                            ),
                          ),
                          Text('${l.calculatedTotal.toDH()} ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                        ],
                      ),
                    )),
                    const SizedBox(height: 20),

                    SectionTitle(l10n.financialSummaryTitle),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.totalHtLabel,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                ),
                              ),
                              Text(
                                '${d.montantHt.toDH()} ',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.vatLabel(d.tauxTva),
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(d.montantTtc - d.montantHt).toDH()} ',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: Color(0xFFF1F5F9), height: 1),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.totalTtcLabel,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                                ),
                              ),
                              Text(
                                '${d.montantTtc.toDH()} ',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (d.factureId != null) ...[
                      SectionTitle(l10n.linkedInvoiceTitle),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.receipt_long_outlined, color: Color(0xFF2563EB)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d.factureNumero ?? l10n.linkedInvoiceDefault, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                  Text(l10n.quoteConvertedToInvoiceInfo, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/factures/${d.factureId}'),
                              child: Text(l10n.viewButton),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    if (d.conditions != null && d.conditions!.isNotEmpty) ...[
                      SectionTitle(l10n.specialConditionsTitle),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(d.conditions!, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4)),
                      ),
                      const SizedBox(height: 20),
                    ],

                    SectionTitle(l10n.availableActionsTitle),

                    if (d.statut == 'BROUILLON') ...[
                      _MenuButton(label: l10n.editQuoteAction, icon: Icons.edit_outlined, isPrimary: true, onTap: () => context.go('/devis/${d.id}/edit')),
                      _MenuButton(label: l10n.markAsSentAction, icon: Icons.send_outlined, onTap: () => context.read<DevisBloc>().add(ChangeDevisStatus(d.id, 'ENVOYE'))),
                      _MenuButton(
                        label: l10n.deleteAction,
                        icon: Icons.delete_outline,
                        isDanger: true,
                        onTap: () => DocumentActions.confirmDelete(
                          context: context,
                          title: l10n.deleteQuoteTitle,
                          onDeleteConfirm: () => context.read<DevisBloc>().add(DeleteDevis(d.id)),
                        ),
                      ),
                    ],

                    if (d.statut == 'ENVOYE') ...[
                      _MenuButton(
                        label: l10n.remindClientAction,
                        icon: Icons.notifications_active_outlined,
                        isPrimary: true,
                        onTap: () => DocumentActions.remindClient(
                          context: context,
                          docNumero: d.numero,
                          clientNom: d.clientDetail.displayName,
                          telephone: d.clientDetail.telephone,
                          email: d.clientDetail.email,
                          montant: d.montantTtc,
                          dateInfo: "${l10n.validUntilPrefix} ${d.dateValidite}",
                        ),
                      ),
                      _MenuButton(label: l10n.markAsAcceptedAction, icon: Icons.check_circle_outline, onTap: () => context.read<DevisBloc>().add(ChangeDevisStatus(d.id, 'ACCEPTE'))),
                      _MenuButton(label: l10n.markAsRefusedAction, icon: Icons.cancel_outlined, onTap: () => context.read<DevisBloc>().add(ChangeDevisStatus(d.id, 'REFUSE'))),
                      _MenuButton(label: l10n.resetToDraftAction, icon: Icons.history, onTap: () => context.read<DevisBloc>().add(ChangeDevisStatus(d.id, 'BROUILLON'))),
                    ],

                    if (d.statut == 'ACCEPTE') ...[
                      if (d.factureId == null)
                        _MenuButton(
                          label: l10n.convertToInvoiceAction,
                          icon: Icons.receipt_long_outlined,
                          isPrimary: true,
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(l10n.convertToInvoiceDialogTitle),
                              content: Text(l10n.convertToInvoiceDialogContent),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancelButton)),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.read<DevisBloc>().add(ConvertDevisToFacture(d.id));
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                                  child: Text(l10n.convertButton, style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],

                    if (d.statut == 'REFUSE' || d.statut == 'EXPIRE') ...[
                      _MenuButton(label: l10n.duplicateQuoteAction, icon: Icons.copy_outlined, isPrimary: true, onTap: () => context.read<DevisBloc>().add(DuplicateDevis(d.id))),
                      _MenuButton(label: l10n.archiveQuoteAction, icon: Icons.archive_outlined, onTap: () => context.read<DevisBloc>().add(ChangeDevisStatus(d.id, 'ARCHIVE'))),
                    ],

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Color(0xFFE2E8F0)),
                    ),

                    _MenuButton(
                      label: l10n.downloadSharePdfAction,
                      icon: Icons.picture_as_pdf_outlined,
                      onTap: () => context.read<DevisBloc>().add(DownloadDevisPdf(d.id, d.numero)),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          }      ),
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
              side: BorderSide(color: isPrimary ? Colors.transparent : (isDanger ? Colors.red.withValues(alpha: 0.3) : const Color(0xFFE2E8F0))),
            ),
          ),
        ),
      ),
    );
  }
}