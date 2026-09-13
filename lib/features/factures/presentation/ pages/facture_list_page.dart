import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../ bloc/facture_bloc.dart';
import '../ bloc/facture_bloc_types.dart';
import '../ bloc/facture_event.dart';
import '../ bloc/facture_state.dart';

import '../../../clients/data/datasources/client_remote_datasource.dart';
import '../../../clients/data/models/client_model.dart';
import '../../../../shared/widgets/custom_filter_chip.dart';
import '../../../devis/presentation/widgets/advanced_filters_modal.dart';
import '../../data/datasources/facture_remote_datasource.dart';
import '../widgets/facture_card.dart';
import '../../../../l10n/app_localizations.dart';

class FactureListPage extends StatelessWidget {
  const FactureListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ActiveFactureBloc(
            FactureRemoteDataSource(),
            ClientRemoteDataSource(),
          )..add(const LoadFactureListPaginated()),
        ),
        BlocProvider(
          create: (_) => ArchivedFactureBloc(
            FactureRemoteDataSource(),
            ClientRemoteDataSource(),
          )..add(const LoadFactureListPaginated(statut: 'ARCHIVE')),
        ),
      ],
      child: const _FactureListView(),
    );
  }
}

class _FactureListView extends StatefulWidget {
  const _FactureListView();

  @override
  State<_FactureListView> createState() => _FactureListViewState();
}

class _FactureListViewState extends State<_FactureListView>
    with SingleTickerProviderStateMixin {

  late TabController    _tabController;
  late ScrollController _scrollControllerActive;
  late ScrollController _scrollControllerArchived;

  String?      _selectedStatut;
  ClientModel? _selectedClient;
  DateTime?    _dateDebut;
  DateTime?    _dateFin;
  bool         _isLoadingMore = false;
  List<ClientModel> _clients = [];

  List<Map<String, String>> _getStatutFilters(AppLocalizations l10n) => [
    {'label': l10n.filterAll,        'value': ''},
    {'label': l10n.filterDrafts,     'value': 'BROUILLON'},
    {'label': l10n.filterSent,       'value': 'ENVOYE'},
    {'label': l10n.filterPaid,       'value': 'PAYEE'},
    {'label': l10n.filterPartial,    'value': 'PARTIELLEMENT_PAYEE'},
    {'label': l10n.filterArchived,   'value': 'ARCHIVE'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController            = TabController(length: 2, vsync: this);
    _scrollControllerActive   = ScrollController();
    _scrollControllerArchived = ScrollController();

    _scrollControllerActive.addListener(() {
      if (_scrollControllerActive.position.pixels >=
          _scrollControllerActive.position.maxScrollExtent - 200) {
        _loadMore(archived: false);
      }
    });

    _scrollControllerArchived.addListener(() {
      if (_scrollControllerArchived.position.pixels >=
          _scrollControllerArchived.position.maxScrollExtent - 200) {
        _loadMore(archived: true);
      }
    });

    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final clients = await ClientRemoteDataSource().getAll();
      setState(() => _clients = clients);
    } catch (_) {}
  }

  FactureBloc _bloc({required bool archived}) => archived
      ? context.read<ArchivedFactureBloc>()
      : context.read<ActiveFactureBloc>();

  void _applyFilters({bool archived = false}) {
    _bloc(archived: archived).add(LoadFactureListPaginated(
      statut: archived
          ? 'ARCHIVE'
          : (_selectedStatut?.isNotEmpty == true ? _selectedStatut : 'ACTIVE'),
      clientId:  _selectedClient?.id,
      dateDebut: _dateDebut?.toIso8601String().split('T')[0],
      dateFin:   _dateFin?.toIso8601String().split('T')[0],
    ));
  }

  void _loadMore({required bool archived}) {
    final state = _bloc(archived: archived).state;
    if (state is FactureListPaginatedLoaded && state.hasMore && !_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      _bloc(archived: archived).add(LoadFactureListPaginated(
        statut:     archived ? 'ARCHIVE' : (_selectedStatut?.isEmpty == true ? null : _selectedStatut),
        clientId:   _selectedClient?.id,
        dateDebut:  _dateDebut?.toIso8601String().split('T')[0],
        dateFin:    _dateFin?.toIso8601String().split('T')[0],
        page:       state.currentPage + 1,
        isLoadMore: true,
      ));
    }
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_selectedClient != null) count++;
    if (_dateDebut != null || _dateFin != null) count++;
    return count;
  }

  void _resetFilters() {
    setState(() {
      _selectedStatut = '';
      _selectedClient = null;
      _dateDebut      = null;
      _dateFin        = null;
    });
    _applyFilters(archived: _tabController.index == 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollControllerActive.dispose();
    _scrollControllerArchived.dispose();
    super.dispose();
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AdvancedFiltersModal(
        clients: _clients,
        initialClient: _selectedClient,
        initialDateDebut: _dateDebut,
        initialDateFin: _dateFin,
        onApply: (client, dateDeb, dateFin) {
          setState(() {
            _selectedClient = client;
            _dateDebut = dateDeb;
            _dateFin = dateFin;
          });
          _applyFilters(archived: _tabController.index == 1);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          l10n.invoicesTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,

        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.tune, color: Colors.white),
                onPressed: _showAdvancedFilters,
              ),
              if (_activeFiltersCount > 0)
                Positioned(
                  right: 8, top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                    child: Text('$_activeFiltersCount',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () => context.go('/factures/create'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [Tab(text: l10n.tabActive), Tab(text: l10n.tabArchived)],
        ),
      ),
      body: Column(
        children: [
          if (_selectedClient != null || _dateDebut != null || _dateFin != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (_selectedClient != null)
                          CustomFilterChip(
                            label: _selectedClient!.displayName,
                            icon: Icons.person_outline,
                            onRemove: () {
                              setState(() => _selectedClient = null);
                              _applyFilters(archived: _tabController.index == 1);
                            },
                          ),
                        if (_dateDebut != null || _dateFin != null)
                          CustomFilterChip(
                            label:
                            '${_dateDebut?.toIso8601String().split('T')[0] ?? '...'} → ${_dateFin?.toIso8601String().split('T')[0] ?? '...'}',
                            icon: Icons.date_range_outlined,
                            onRemove: () {
                              setState(() { _dateDebut = null; _dateFin = null; });
                              _applyFilters(archived: _tabController.index == 1);
                            },
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text(l10n.clearAllFiltersButton,
                        style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTab(l10n),
                _buildArchivedTab(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTab(AppLocalizations l10n) {
    final statutFilters = _getStatutFilters(l10n);
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: statutFilters.length,
            itemBuilder: (_, i) {
              final f        = statutFilters[i];
              final selected = _selectedStatut == f['value'];
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedStatut = f['value']);
                  _applyFilters();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF2563EB) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selected ? const Color(0xFF2563EB) : Colors.grey[300]!),
                  ),
                  alignment: Alignment.center,
                  child: Text(f['label']!,
                      style: TextStyle(
                          color: selected ? Colors.white : Colors.grey[700],
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: BlocConsumer<ActiveFactureBloc, FactureState>(
            listener: (context, state) {
              if (state is FactureListPaginatedLoaded || state is FactureError) {
                setState(() => _isLoadingMore = false);
              }
              if (state is FactureDeleted) {
                _applyFilters(archived: false);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.invoiceDeletedSuccess)));
              }
              if (state is FactureError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.red));
              }
            },
            builder: (context, state) => _buildListContent(context, state, archived: false, l10n: l10n),
          ),
        ),
      ],
    );
  }

  Widget _buildArchivedTab(AppLocalizations l10n) {
    return BlocConsumer<ArchivedFactureBloc, FactureState>(
      listener: (context, state) {
        if (state is FactureListPaginatedLoaded || state is FactureError) {
          setState(() => _isLoadingMore = false);
        }
        if (state is FactureDeleted) {
          _applyFilters(archived: true);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.invoiceDeletedSuccess)));
        }
        if (state is FactureError) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      builder: (context, state) => _buildListContent(context, state, archived: true, l10n: l10n),
    );
  }

  Widget _buildListContent(BuildContext context, FactureState state, {required bool archived, required AppLocalizations l10n}) {
    if (state is FactureLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
    }

    if (state is FactureListPaginatedLoaded || state is FactureLoadingMore) {
      final factures = state is FactureListPaginatedLoaded
          ? state.factures
          : (state as FactureLoadingMore).currentFactures;
      final hasMore = state is FactureListPaginatedLoaded ? state.hasMore : true;

      if (factures.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(archived ? Icons.archive_outlined : Icons.receipt_long_outlined,
                  size: 64, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(archived ? l10n.noArchivedInvoicesFound : l10n.noInvoicesFound,
                  style: TextStyle(color: Colors.grey[500])),
              if (_activeFiltersCount > 0) ...[
                const SizedBox(height: 8),
                TextButton(onPressed: _resetFilters, child: Text(l10n.clearFiltersButton)),
              ],
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => _applyFilters(archived: archived),
        child: ListView.builder(
          controller: archived ? _scrollControllerArchived : _scrollControllerActive,
          padding: const EdgeInsets.all(16),
          itemCount: factures.length + (hasMore ? 1 : 0),
          itemBuilder: (_, i) {
            if (i == factures.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB), strokeWidth: 2)),
              );
            }
            final f = factures[i];
            return FactureCard(
              facture: f,
              onTap: () => context.go('/factures/${f.id}'),
              onDelete: f.statut == 'BROUILLON'
                  ? () => _confirmDelete(context, f.id, archived: archived, l10n: l10n)
                  : null,
            );
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _confirmDelete(BuildContext context, int id, {required bool archived, required AppLocalizations l10n}) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteInvoiceDialogTitle),
        content: Text(l10n.deleteInvoiceDialogContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancelButton)),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _bloc(archived: archived).add(DeleteFacture(id));
            },
            child: Text(l10n.deleteButton, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}