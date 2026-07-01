import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_card.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc(NotificationRemoteDataSource())
        ..add(LoadNotifications()),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final List<int> _selectedIds = [];
  bool get _isSelectionMode => _selectedIds.isNotEmpty;

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _cancelSelection() {
    setState(() {
      _selectedIds.clear();
    });
  }

  void _confirmDelete(BuildContext context) {
    final notificationBloc = context.read<NotificationBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer les notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text('Voulez-vous vraiment supprimer les ${_selectedIds.length} notifications sélectionnées ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              notificationBloc.add(DeleteNotifications(List.from(_selectedIds)));
              _cancelSelection();
              Navigator.pop(dialogContext);
            },
            child: const Text('Supprimer', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _onNotificationTap(BuildContext context, dynamic notification) {
    if (_isSelectionMode) {
      _toggleSelection(notification.id);
    } else {
      context.read<NotificationBloc>().add(MarkAsRead(notification.id));

      switch (notification.type) {
        case 'facture':
          if (notification.referenceId != null) {
            context.go('/factures/${notification.referenceId}');
          }
          break;
        case 'devis':
          if (notification.referenceId != null) {
            context.go('/devis/${notification.referenceId}');
          }
          break;
        case 'credit':
          if (notification.referenceId != null) {
            context.go('/credit/${notification.referenceId}');
          } else {context.go('/credit');
          }
          break;

        default:
          Color typeColor;
          IconData typeIcon;

          switch (notification.type) {
            case 'fiscale':
            case 'fiscal':
              typeColor = const Color(0xFF2563EB);
              typeIcon = Icons.gavel_rounded;
              break;
            case 'cnss':
              typeColor = const Color(0xFF10B981);
              typeIcon = Icons.medical_services_rounded;
              break;
            default:
              typeColor = const Color(0xFF64748B);
              typeIcon = Icons.notifications_rounded;
          }
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(typeIcon, color: typeColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          notification.titre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notification.corps,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fermer', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
          break;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        bool showMarkAllRead = state is NotificationsLoaded && state.unreadCount > 0 && !_isSelectionMode;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: _isSelectionMode
                ? const Color(0xFF1E3A8A)
                : const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,

            leading: _isSelectionMode
                ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: _cancelSelection,
            )
                : IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            title: Text(
              _isSelectionMode
                  ? '${_selectedIds.length} sélectionné(s)'
                  : 'Notifications',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            actions: [
              if (_isSelectionMode)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () => _confirmDelete(context),
                )
              else if (showMarkAllRead)
                TextButton(
                  onPressed: () {
                    context.read<NotificationBloc>()
                        .add(MarkAllAsRead());
                  },
                  child: Text(
                    'Tout marquer comme lu (${state.unreadCount})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state is NotificationLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
              }

              if (state is NotificationError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 32),
                      const SizedBox(height: 16),
                      Text(state.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<NotificationBloc>().add(LoadNotifications()),
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                );
              }

              if (state is NotificationsLoaded) {
                if (state.notifications.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F172A).withOpacity(0.03),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.notifications_off_outlined,
                              size: 36,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Votre historique est propre',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Nous vous préviendrons dès qu\'une facture ou un devis nécessitera votre attention.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  color: const Color(0xFF2563EB),
                  onRefresh: () async => context.read<NotificationBloc>().add(LoadNotifications()),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    itemCount: state.notifications.length,
                    itemBuilder: (_, i) {
                      final n = state.notifications[i];
                      final isSelected = _selectedIds.contains(n.id);

                      return GestureDetector(
                        onLongPress: () => _toggleSelection(n.id),
                        child: Stack(
                          children: [
                            NotificationCard(
                              notification: n,
                              onTap: () => _onNotificationTap(context, n),
                            ),
                            if (_isSelectionMode)
                              Positioned(
                                right: 28,
                                top: 0,
                                bottom: 12,
                                child: Center(
                                  child: InkWell(
                                    onTap: () => _toggleSelection(n.id),
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}