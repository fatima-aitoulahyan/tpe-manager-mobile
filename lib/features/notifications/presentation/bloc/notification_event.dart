abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class LoadUnreadCount extends NotificationEvent {}

class MarkAsRead extends NotificationEvent {
  final int id;
  MarkAsRead(this.id);
}

class MarkAllAsRead extends NotificationEvent {}
class DeleteNotifications extends NotificationEvent {
  final List<int> notificationIds;
  DeleteNotifications(this.notificationIds);
}