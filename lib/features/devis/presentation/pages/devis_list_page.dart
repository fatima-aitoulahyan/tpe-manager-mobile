import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../clients/data/datasources/client_remote_datasource.dart';
import '../../../clients/data/models/client_model.dart';
import '../../data/datasources/devis_remote_datasource.dart';
import '../bloc/devis_bloc.dart';
import '../bloc/devis_event.dart';
import '../bloc/devis_state.dart';
import '../widgets/advanced_filters_modal.dart';
import '../widgets/devis_card.dart';
import '../../../../l10n/app_localizations.dart';

class DevisListPage extends StatelessWidget {
  const DevisListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DevisBloc(
        DevisRemoteDataSource(),
        ClientRemoteDataSource(),
      )..add(LoadDevisListPaginated()),
      child: const _DevisListView(),
    );
  }
}

class _DevisListView extends StatefulWidget {
  const _DevisListView();

  @override
  State<_DevisListView> createState() => _DevisListViewState();
}

class _DevisListViewState extends State<_DevisListView>
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
    {'label': l10n.filterAll,       'value': ''},
    {'label': l10n.filterDrafts,    'value': 'BROUILLON'},
    {'label': l10n.filterSent,      'value': 'ENVOYE'},
    {'label': l10n.filterAccepted,  'value': 'ACCEPTE'},
    {'label': l10n.filterRefused,   'value': 'REFUSE'},
    {'label': l10n.filterExpired,   'value': 'EXPIRE'},
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

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _applyFilters(archived: _tabController.index == 1);
    });

    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final clients = await ClientRemoteDataSource().getAll();
      setState(() => _clients = clients);
    } catch (_) {}
  }

  void _applyFilters({bool archived = false}) {
    context.read<DevisBloc>().add(LoadDevisListPaginated(
      statut:    archived ? 'ARCHIVE' : (_selectedStatut?.isNotEmpty == true ? _selectedStatut : null),
      clientId:  _selectedClient?.id,
      dateDebut: _dateDebut?.toIso8601String().split('T')[0],
      dateFin:   _dateFin?.toIso8601String().split('T')[0],
    ));
  }

  void _loadMore({required bool archived}) {
    final state = context.read<DevisBloc>().state;
    if (state is DevisListPaginatedLoaded && state.hasMore && !_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      context.read<DevisBloc>().add(LoadDevisListPaginated(
        statut:    archived ? 'ARCHIVE' : (_selectedStatut?.isNotEmpty == true ? _selectedStatut : null),
        clientId:  _selectedClient?.id,
        dateDebut: _dateDebut?.toIso8601String().split('T')[0],
        dateFin:   _dateFin?.toIso8601String().split('T')[0],
        page:      state.currentPage + 1,
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
    _applyFilters();
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
          _applyFilters();
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
          l10n.quotesListTitle,
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
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_activeFiltersCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () => context.go('/devis/create'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: l10n.activeTabLabel),
            Tab(text: l10n.archivedTabLabel),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_selectedClient != null || _dateDebut != null || _dateFin != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (_selectedClient != null)
                          _FilterChip(
                            label: _selectedClient!.displayName,
                            icon: Icons.person_outline,
                            onRemove: () {
                              setState(() => _selectedClient = null);
                              _applyFilters();
                            },
                          ),
                        if (_dateDebut != null || _dateFin != null)
                          _FilterChip(
                            label: '${_dateDebut?.toIso8601String().split('T')[0] ?? '...'} → ${_dateFin?.toIso8601String().split('T')[0] ?? '...'}',
                            icon: Icons.date_range_outlined,
                            onRemove: () {
                              setState(() {
                                _dateDebut = null;
                                _dateFin   = null;
                              });
                              _applyFilters();
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _resetFilters,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.clearAllFiltersButton,
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTab(l10n),
                _buildArchivedTab(),
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
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            itemCount: statutFilters.length,
            itemBuilder: (_, i) {
              final f      = statutFilters[i];
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
                    color: selected
                        ? const Color(0xFF2563EB) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF2563EB) : Colors.grey[300]!,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(f['label']!,
                    style: TextStyle(
                      color: selected
                          ? Colors.white : Colors.grey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(child: _buildList(archived: false)),
      ],
    );
  }

  Widget _buildArchivedTab() => _buildList(archived: true);

  Widget _buildList({required bool archived}) {
    return BlocConsumer<DevisBloc, DevisState>(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state is DevisListPaginatedLoaded || state is DevisError) {
          setState(() => _isLoadingMore = false);
        }
        if (state is DevisDeleted || state is DevisDuplicated) {
          _applyFilters(archived: archived);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state is DevisDeleted
                ? l10n.quoteDeletedSuccessMessage : l10n.quoteDuplicatedSuccessMessage),
          ));
        }
        if (state is DevisError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message),
                backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        if (state is DevisLoading) {
          return const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF2563EB)));
        }

        if (state is DevisListPaginatedLoaded ||
            state is DevisLoadingMore) {
          final devis   = state is DevisListPaginatedLoaded
              ? state.devis
              : (state as DevisLoadingMore).currentDevis;
          final hasMore = state is DevisListPaginatedLoaded
              ? state.hasMore : true;

          if (devis.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      archived
                          ? Icons.archive_outlined
                          : Icons.description_outlined,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text(
                    archived
                        ? l10n.noArchivedQuotesFound
                        : l10n.noQuotesFound,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  if (_activeFiltersCount > 0) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _resetFilters,
                      child: Text(l10n.clearFiltersButton),
                    ),
                  ],

                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _applyFilters(archived: archived),
            child: ListView.builder(
              controller: archived
                  ? _scrollControllerArchived
                  : _scrollControllerActive,
              padding: const EdgeInsets.all(16),
              itemCount: devis.length + (hasMore ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == devis.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF2563EB), strokeWidth: 2),
                    ),
                  );
                }
                final d = devis[i];
                return DevisCard(
                  devis: d,
                  onTap: () => context.go('/devis/${d.id}'),
                  onDelete: d.statut == 'BROUILLON'
                      ? () => _confirmDelete(context, d.id)
                      : null,
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteQuoteDialogTitle),
        content: Text(l10n.deleteQuoteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<DevisBloc>().add(DeleteDevis(id));
            },
            child: Text(l10n.deleteAction,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }}

class _FilterChip extends StatelessWidget {
  final String   label;
  final IconData icon;
  final VoidCallback onRemove;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF2563EB).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF2563EB)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 12, color: Color(0xFF2563EB)),
          ),
        ],
      ),
    );
  }
}