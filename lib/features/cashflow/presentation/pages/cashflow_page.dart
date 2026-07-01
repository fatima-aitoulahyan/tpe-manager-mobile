import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/cashflow_remote_datasource.dart';
import '../../data/models/transaction_model.dart';
import '../bloc/cashflow_bloc.dart';
import '../bloc/cashflow_event.dart';
import '../bloc/cashflow_state.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/transaction_card.dart';

class CashflowPage extends StatelessWidget {
  const CashflowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CashflowBloc(CashflowRemoteDataSource())
        ..add(LoadDashboard())
        ..add(LoadTransactions()),
      child: const _CashflowView(),
    );
  }
}

class _CashflowView extends StatefulWidget {
  const _CashflowView();

  @override
  State<_CashflowView> createState() => _CashflowViewState();
}

class _CashflowViewState extends State<_CashflowView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String? _selectedType;
  final Set<int> _selectedIds = {};

  bool _isBalanceVisible = false;

  bool get _isSelectionMode => _selectedIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedType = _tabController.index == 0
            ? null
            : (_tabController.index == 1 ? 'RECETTE' : 'DEPENSE');
        _selectedIds.clear();
      });
      context.read<CashflowBloc>().add(LoadTransactions(type: _selectedType));
    });
  }

  void _loadMore() {
    final state = context.read<CashflowBloc>().state;
    if (state is TransactionsLoaded && state.hasMore) {
      context.read<CashflowBloc>().add(LoadTransactions(
        type: _selectedType,
        page: state.currentPage + 1,
        isLoadMore: true,
      ));
    }
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _deleteSelectedTransactions() {
    final bloc = context.read<CashflowBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Suppression multiple', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Voulez-vous vraiment supprimer les ${_selectedIds.length} transactions sélectionnées ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler', style: TextStyle(color: Color(0xFF64748B)))),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              for (final id in _selectedIds) {
                bloc.add(DeleteTransaction(id));
              }
              setState(() => _selectedIds.clear());
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
            _isSelectionMode ? '${_selectedIds.length} sélectionné(s)' : 'Trésorerie',
            style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: _isSelectionMode ? const Color(0xFF1E3A8A) : const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,

        leading: _isSelectionMode
            ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _selectedIds.clear()),
        )
            : null,

        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteSelectedTransactions,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Tout'),
            Tab(text: 'Recettes'),
            Tab(text: 'Dépenses'),
          ],
        ),
      ),      body: Column(
        children: [
          BlocBuilder<CashflowBloc, CashflowState>(
            buildWhen: (_, s) => s is DashboardLoaded,
            builder: (context, state) {
              if (state is! DashboardLoaded) return const _DashboardSkeleton();
              return _DashboardCard(
                dashboard: state.dashboard,
                isVisible: _isBalanceVisible,
                onToggleVisibility: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
              );
            },
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildList(), _buildList(), _buildList()],
            ),
          ),
        ],
      ),
      floatingActionButton: BlocListener<CashflowBloc, CashflowState>(
        listener: (context, state) {
          if (state is TransactionAdded) {
            context.read<CashflowBloc>()
              ..add(LoadDashboard())
              ..add(LoadTransactions(type: _selectedType));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.transaction.isRecette ? 'Paiement enregistré ✓' : 'Dépense enregistrée ✓'),
                backgroundColor: state.transaction.isRecette ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is TransactionDeleted) {
            context.read<CashflowBloc>()
              ..add(LoadDashboard())
              ..add(LoadTransactions(type: _selectedType));
          }
          if (state is CashflowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
            );
          }
        },
        child: _isSelectionMode
            ? const SizedBox.shrink()
            : FloatingActionButton(
          onPressed: () => AddTransactionSheet.show(context),
          backgroundColor: const Color(0xFF2563EB),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.add, color: Colors.white, size: 26),
        ),
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<CashflowBloc, CashflowState>(
      buildWhen: (_, s) => s is TransactionsLoaded || s is TransactionLoadingMore || s is CashflowLoading,
      builder: (context, state) {
        if (state is CashflowLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }

        if (state is TransactionsLoaded || state is TransactionLoadingMore) {
          final transactions = state is TransactionsLoaded ? state.transactions : (state as TransactionLoadingMore).current;
          final hasMore = state is TransactionsLoaded ? state.hasMore : true;

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 54, color: const Color(0xFFCBD5E1)),
                  const SizedBox(height: 12),
                  const Text('Aucune transaction', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CashflowBloc>()
                ..add(LoadDashboard())
                ..add(LoadTransactions(type: _selectedType));
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: transactions.length + (hasMore ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == transactions.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB), strokeWidth: 2)),
                  );
                }

                final t = transactions[i];
                final isSelected = _selectedIds.contains(t.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onLongPress: () => _toggleSelection(t.id),
                    onTap: () {
                      if (_isSelectionMode) {
                        _toggleSelection(t.id);
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: IgnorePointer(
                        ignoring: _isSelectionMode,
                        child: TransactionCard(
                          transaction: t,
                          onDelete: () => context.read<CashflowBloc>().add(DeleteTransaction(t.id)),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final DashboardModel dashboard;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const _DashboardCard({
    required this.dashboard,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Solde disponible',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
              ),
              IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: const Color(0xFF64748B),
                  size: 20,
                ),
                onPressed: onToggleVisibility,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              isVisible ? '${dashboard.solde.toStringAsFixed(2)} MAD' : '•••••• MAD',
              style: const TextStyle(color: Color(0xFF0F172A), fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _MiniStat(
                label: 'Recettes',
                value: dashboard.recettesMois,
                icon: Icons.arrow_downward_rounded,
                color: const Color(0xFF10B981),
                isVisible: isVisible,
              )),
              Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
              Expanded(child: _MiniStat(
                label: 'Dépenses',
                value: dashboard.depensesMois,
                icon: Icons.arrow_upward_rounded,
                color: const Color(0xFFEF4444),
                isVisible: isVisible,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;
  final bool isVisible;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 12),
            ),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          isVisible ? '${value.toStringAsFixed(2)} MAD' : '•••• MAD',
          style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
    );
  }
}