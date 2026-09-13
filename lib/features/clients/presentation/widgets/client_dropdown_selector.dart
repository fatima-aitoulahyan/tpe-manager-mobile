import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/client_model.dart';
import '../bloc/client_bloc.dart';
import '../bloc/client_event.dart';
import '../bloc/client_state.dart';
import '../pages/client_create_page.dart';
import '../../../../l10n/app_localizations.dart';

class ClientDropdownSelector extends StatelessWidget {
  final ClientModel? selectedClient;
  final Function(ClientModel) onSelected;

  const ClientDropdownSelector({
    super.key,
    required this.selectedClient,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientBloc()..add(LoadClients()),
      child: _ClientDropdownView(
        selectedClient: selectedClient,
        onSelected: onSelected,
      ),
    );
  }
}

class _ClientDropdownView extends StatefulWidget {
  final ClientModel? selectedClient;
  final Function(ClientModel) onSelected;

  const _ClientDropdownView({
    required this.selectedClient,
    required this.onSelected,
  });

  @override
  State<_ClientDropdownView> createState() => _ClientDropdownViewState();
}

class _ClientDropdownViewState extends State<_ClientDropdownView> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        final clients = state is ClientsLoaded ? state.clients : <ClientModel>[];
        final isLoading = state is ClientLoading;

        final ClientModel? currentValue = clients.any(
                (c) => c.id == widget.selectedClient?.id)
            ? clients.firstWhere((c) => c.id == widget.selectedClient?.id)
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _ClientField(
              selectedClient: currentValue,
              isLoading: isLoading,
              isOpen: _isOpen,
              clients: clients,
              onOpen: () => setState(() => _isOpen = true),
              onClose: () => setState(() => _isOpen = false),
              onSelect: (client) {
                setState(() => _isOpen = false);
                widget.onSelected(client);
              },
            ),

            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final newClient = await Navigator.push<ClientModel>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClientCreatePage(),
                  ),
                );
                if (newClient != null && context.mounted) {
                  widget.onSelected(newClient);
                  context.read<ClientBloc>().add(LoadClients());
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add,
                      size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    l10n.newClientOption,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ClientField extends StatelessWidget {
  final ClientModel? selectedClient;
  final bool isLoading;
  final bool isOpen;
  final List<ClientModel> clients;
  final VoidCallback onOpen;
  final VoidCallback onClose;
  final Function(ClientModel) onSelect;

  const _ClientField({
    required this.selectedClient,
    required this.isLoading,
    required this.isOpen,
    required this.clients,
    required this.onOpen,
    required this.onClose,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isLoading ? null : (isOpen ? onClose : onOpen),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isOpen
                  ? const BorderRadius.vertical(top: Radius.circular(10))
                  : BorderRadius.circular(10),
              border: Border.all(
                color: isOpen
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFE2E8F0),
                width: isOpen ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                if (selectedClient != null) ...[
                  _Avatar(client: selectedClient!, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${selectedClient!.nom} ${selectedClient!.prenom}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (selectedClient!.nomEntreprise != null)
                          Text(
                            selectedClient!.nomEntreprise!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ] else ...[
                  Icon(Icons.person_outline,
                      size: 18, color: Colors.grey[400]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.selectClientPrompt,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                if (isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.grey[400],
                    ),
                  )
                else
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(Icons.keyboard_arrow_down,
                        size: 20, color: Colors.grey[400]),
                  ),
              ],
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: isOpen
              ? Container(
            constraints: const BoxConstraints(maxHeight: 240),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10)),
              border: const Border(
                left: BorderSide(color: Color(0xFF2563EB), width: 1.5),
                right: BorderSide(color: Color(0xFF2563EB), width: 1.5),
                bottom: BorderSide(color: Color(0xFF2563EB), width: 1.5),
              ),
            ),
            child: clients.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 8),
                  Text(
                    l10n.noClientsAvailable,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: clients.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Colors.grey[100],
                indent: 14,
                endIndent: 14,
              ),
              itemBuilder: (_, i) {
                final c = clients[i];
                final isSelected =
                    selectedClient?.id == c.id;
                return _ClientTile(
                  client: c,
                  isSelected: isSelected,
                  onTap: () => onSelect(c),
                );
              },
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ClientTile extends StatelessWidget {
  final ClientModel client;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClientTile({
    required this.client,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        color: isSelected
            ? const Color(0xFF2563EB).withValues(alpha: 0.04)
            : Colors.transparent,
        child: Row(
          children: [
            _Avatar(client: client, size: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${client.nom} ${client.prenom}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF1E293B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (client.nomEntreprise != null)
                    Text(
                      client.nomEntreprise!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check,
                  size: 16, color: Color(0xFF2563EB)),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final ClientModel client;
  final double size;

  const _Avatar({required this.client, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB).withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        client.initials,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2563EB),
        ),
      ),
    );
  }
}