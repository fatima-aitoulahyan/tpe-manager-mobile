import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRemoteDataSource dataSource;

  NotificationBloc(this.dataSource) : super(NotificationInitial()) {

    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifs = await dataSource.getAll();
        final unread = notifs.where((n) => !n.lue).length;
        emit(NotificationsLoaded(
          notifications: notifs,
          unreadCount:   unread,
        ));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<MarkAsRead>((event, emit) async {
      try {
        await dataSource.markAsRead(event.id);
        add(LoadNotifications());
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<MarkAllAsRead>((event, emit) async {
      try {
        await dataSource.markAllAsRead();
        add(LoadNotifications());
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
    on<DeleteNotifications>((event, emit) async {
      try {
        await dataSource.deleteNotifications(event.notificationIds);
        add(LoadNotifications());
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }
}