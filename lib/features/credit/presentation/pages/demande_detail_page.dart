import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/datasources/credit_remote_datasource.dart';
import '../bloc/credit_bloc.dart';
import '../bloc/credit_event.dart';
import '../bloc/credit_state.dart';
import '../widgets/statut_demande_badge.dart';

class DemandeDetailPage extends StatelessWidget {
  final int id;
  const DemandeDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreditBloc(CreditRemoteDataSource())
        ..add(LoadDemandeDetail(id)),
      child: _DemandeDetailView(id: id),
    );
  }
}

class _DemandeDetailView extends StatelessWidget {
  final int id;
  const _DemandeDetailView({required this.id});

  Future<void> _pickAndUpload(
      BuildContext context, String typeDocument) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      context.read<CreditBloc>().add(UploadJustificatif(
          id, typeDocument, result.files.single.path!));
    }
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Type de document',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('CIN'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUpload(context, 'CIN');
              },
            ),
            ListTile(
              leading: const Icon(Icons.business_outlined),
              title: const Text('RC / Patente'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUpload(context, 'RC_PATENTE');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_outlined),
              title: const Text('Relevé bancaire'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUpload(context, 'RELEVE_BANCAIRE');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Détail de la demande',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop() : context.go('/credit'),
        ),
      ),
      body: BlocConsumer<CreditBloc, CreditState>(
        listener: (context, state) {
          if (state is JustificatifUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Document ajouté avec succès')));
          }
          if (state is CreditError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message),
                    backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state is CreditLoading) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFF2563EB)));
          }

          if (state is DemandeDetailLoaded) {
            final d = state.demande;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(d.typeFinancementDisplay,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StatutDemandeBadge(statut: d.statut),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${d.montantDemande.toStringAsFixed(0)} MAD',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        Text('Sur ${d.dureeMois} mois',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (d.motifRefus != null &&
                      d.motifRefus!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.info_outline,
                                size: 16, color: Colors.red),
                            const SizedBox(width: 6),
                            const Text('Motif de refus',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 6),
                          Text(d.motifRefus!,
                              style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const Text('Objet du financement',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(d.objetFinancement,
                        style: const TextStyle(fontSize: 13)),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Justificatifs',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      if (d.statut == 'SOUMISE' ||
                          d.statut == 'DOSSIER_INCOMPLET')
                        TextButton.icon(
                          onPressed: () => _showUploadOptions(context),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Ajouter'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (d.justificatifs.isEmpty)
                    Text('Aucun document ajouté',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[500]))
                  else
                    ...d.justificatifs.map((j) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        const Icon(Icons.insert_drive_file_outlined,
                            color: Color(0xFF2563EB), size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(j.nomFichier,
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ]),
                    )),
                  const SizedBox(height: 20),

                  if (d.offres.isNotEmpty) ...[
                    const Text('Offres reçues',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    ...d.offres.map((o) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF2563EB)
                                .withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o.partenaireNom,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Row(children: [
                            Expanded(child: Text(
                                'Taux: ${o.tauxInteret}%',
                                style: const TextStyle(fontSize: 12))),
                            Expanded(child: Text(
                                '${o.dureeMois} mois',
                                style: const TextStyle(fontSize: 12))),
                          ]),
                          const SizedBox(height: 4),
                          Text(
                            'Mensualité : ${o.mensualiteEstimee.toStringAsFixed(2)} MAD',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          if (o.urlPortail != null) ...[
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () async {
                                  final url = Uri.parse(o.urlPortail!);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Impossible d\'ouvrir le portail partenaire'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF2563EB)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.open_in_new, size: 16, color: Color(0xFF2563EB)),
                                    SizedBox(width: 8),
                                    Text('Finaliser sur le portail',
                                      style: TextStyle(
                                        color: Color(0xFF2563EB),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],                        ],
                      ),
                    )),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}