import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasources/credit_remote_datasource.dart';
import '../bloc/credit_bloc.dart';
import '../bloc/credit_event.dart';
import '../bloc/credit_state.dart';
import '../widgets/eligibilite_gauge.dart';
import '../widgets/demande_card.dart';
import '../../../../l10n/app_localizations.dart';

class CreditPage extends StatelessWidget {
  const CreditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreditBloc(CreditRemoteDataSource())
        ..add(LoadEligibilite())
        ..add(LoadDemandes()),
      child: const _CreditView(),
    );
  }
}

class _CreditView extends StatelessWidget {
  const _CreditView();

  bool _peutEtreSupprime(String statut) {
    return statut == 'SOUMISE' ||
        statut == 'DOSSIER_INCOMPLET' ||
        statut == 'DEFAVORABLE';
  }

  void _confirmDelete(BuildContext context, int id) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteRequestTitle),
        content: Text(l10n.deleteRequestConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CreditBloc>().add(DeleteDemande(id));
            },
            child: Text(l10n.deleteButton,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.financingTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/credit/create'),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CreditBloc>()
            ..add(LoadEligibilite())
            ..add(LoadDemandes());
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BlocBuilder<CreditBloc, CreditState>(
              buildWhen: (_, s) => s is EligibiliteLoaded,
              builder: (context, state) {
                if (state is! EligibiliteLoaded) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF2563EB))),
                  );
                }

                final elig = state.eligibilite;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    Text(l10n.eligibilityTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    EligibiliteGauge(
                      score:  elig.score,
                      niveau: elig.niveau,
                    ),
                    if (elig.conseils.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(l10n.improveScoreTipsTitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...elig.conseils.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline,
                                size: 14, color: Colors.orange),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(c,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ]),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(l10n.myRequestsTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            BlocConsumer<CreditBloc, CreditState>(
              listenWhen: (_, s) =>
              s is DemandeDeleted || s is CreditError,
              listener: (context, state) {
                if (state is DemandeDeleted) {
                  context.read<CreditBloc>().add(LoadDemandes());
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(l10n.requestDeletedSuccess)));
                }
                if (state is CreditError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message),
                          backgroundColor: Colors.red));
                }
              },
              buildWhen: (_, s) =>
              s is DemandesLoaded || s is CreditLoading,
              builder: (context, state) {
                if (state is CreditLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF2563EB))),
                  );
                }

                if (state is DemandesLoaded) {
                  if (state.demandes.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(children: [
                        Icon(Icons.monetization_on_outlined,
                            size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(l10n.noFinancingRequests,
                            style: TextStyle(color: Colors.grey[500])),
                      ]),
                    );
                  }

                  return Column(
                    children: state.demandes.map((d) => DemandeCard(
                      demande: d,
                      onTap: () => context.push('/credit/${d.id}'),
                      onDelete: _peutEtreSupprime(d.statut)
                          ? () => _confirmDelete(context, d.id)
                          : null,
                    )).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}