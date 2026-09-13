import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../notifications/data/datasources/notification_remote_datasource.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/bloc/notification_event.dart';
import '../../../notifications/presentation/bloc/notification_state.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/balance_bar_chart.dart';
import '../widgets/balance_pie_chart.dart';
import '../widgets/devis_activity_card.dart';
import '../widgets/stat_card.dart';
import '../../../../l10n/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(DashboardRemoteDataSource())..add(LoadDashboard()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  bool _isBalanceVisible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message, style: const TextStyle(color: Color(0xFF64748B))),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardBloc>().add(RefreshDashboard()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(l10n.retryButton),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardLoaded) {
            final cf = state.cashflow;
            final ds = state.devisStats;

            return RefreshIndicator(
              onRefresh: () async => context.read<DashboardBloc>().add(RefreshDashboard()),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    backgroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                    centerTitle: false,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        l10n.dashboardTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    actions: [
                      BlocProvider(
                        create: (_) => NotificationBloc(NotificationRemoteDataSource())..add(LoadNotifications()),
                        child: BlocBuilder<NotificationBloc, NotificationState>(
                          builder: (context, state) {
                            final unread = state is NotificationsLoaded ? state.unreadCount : 0;

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                                  onPressed: () {
                                    context.push('/notifications');
                                  },
                                ),
                                if (unread > 0)
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        '$unread',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: IconButton(
                          icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
                          onPressed: () {
                            context.push('/profile');
                          },
                        ),
                      ),
                    ],                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        BalanceCard(
                          solde: cf.solde,
                          isVisible: _isBalanceVisible,
                          onToggleVisibility: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                        ),
                        const SizedBox(height: 12),

                        Row(children: [
                          Expanded(child: StatCard(
                            label: l10n.monthlyIncomeLabel,
                            value: cf.recettesMois,
                            icon: Icons.arrow_downward_rounded,
                            color: const Color(0xFF10B981),
                            isVisible: _isBalanceVisible,
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: StatCard(
                            label: l10n.monthlyExpensesLabel,
                            value: cf.depensesMois,
                            icon: Icons.arrow_upward_rounded,
                            color: const Color(0xFFEF4444),
                            isVisible: _isBalanceVisible,
                          )),
                        ]),
                        const SizedBox(height: 28),

                        DevisActivityCard(devisStats: ds),
                        const SizedBox(height: 28),

                        Text(l10n.flowAnalysisTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: BalanceBarChart(recettes: cf.recettesMois, depenses: cf.depensesMois),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: BalancePieChart(recettes: cf.recettesMois, depenses: cf.depensesMois),
                        ),
                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                ],
              ),
            );          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}