import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/client_bloc.dart';
import '../bloc/client_event.dart';
import '../bloc/client_state.dart';
import '../../data/models/client_model.dart';
import 'client_create_page.dart';

class ClientListPage extends StatelessWidget {
  const ClientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientBloc()..add(LoadClients()),
      child: const _ClientListView(),
    );
  }
}

class _ClientListView extends StatefulWidget {
  const _ClientListView();

  @override
  State<_ClientListView> createState() => _ClientListViewState();
}

class _ClientListViewState extends State<_ClientListView> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Clients',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: Color(0xFF2563EB)),
            onPressed: () async {
              final created = await Navigator.push<ClientModel>(
                context,
                MaterialPageRoute(
                    builder: (_) => const ClientCreatePage()),
              );
              if (created != null && context.mounted) {
                context.read<ClientBloc>().add(LoadClients());
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) =>
                  context.read<ClientBloc>().add(SearchClients(v)),
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, entreprise...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          Expanded(
            child: BlocConsumer<ClientBloc, ClientState>(
              listener: (context, state) {
                if (state is ClientDeleted) {
                  context.read<ClientBloc>().add(LoadClients());
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Client supprimé avec succès')));
                }
                if (state is ClientError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message),
                          backgroundColor: Colors.red));
                }
              },
              builder: (context, state) {
                if (state is ClientLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF2563EB)));
                }

                if (state is ClientsLoaded) {
                  if (state.filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text('Aucun client trouvé',
                              style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<ClientBloc>().add(LoadClients()),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.filtered.length,
                      itemBuilder: (_, i) {
                        final c = state.filtered[i];
                        return _ClientCard(
                          client: c,
                          onEdit: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ClientCreatePage(client: c)),
                            );
                            if (context.mounted) {
                              context.read<ClientBloc>().add(LoadClients());
                            }
                          },
                          onDelete: () => _confirmDelete(context, c.id),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer le client'),
        content: const Text(
            'Êtes-vous sûr ? Cela peut impacter les devis associés à ce client.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ClientBloc>().add(DeleteClient(id));
            },
            child: const Text('Supprimer',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final ClientModel client;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClientCard({
    required this.client,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF2563EB).withOpacity(0.1),
            child: Text(client.initials,
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${client.nom} ${client.prenom}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (client.nomEntreprise != null)
                  Text(client.nomEntreprise!,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                if (client.telephone != null)
                  Row(children: [
                    Icon(Icons.phone_outlined,
                        size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(client.telephone!,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600])),
                  ]),
              ],
            ),
          ),

          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit')   onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(children: [
                  Icon(Icons.edit_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('Modifier'),
                ]),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  Icon(Icons.delete_outline,
                      size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Supprimer', style: TextStyle(color: Colors.red)),
                ]),
              ),
            ],
            child: const Icon(Icons.more_vert, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}