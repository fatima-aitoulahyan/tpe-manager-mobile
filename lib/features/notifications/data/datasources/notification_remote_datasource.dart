import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final Dio _dio = DioClient.instance;

  Future<List<NotificationModel>> getAll() async {
    final res = await _dio.get('/notifications/list/');

    List data;
    if (res.data is List) {
      data = res.data as List;
    } else {
      data = res.data['results'] as List? ?? [];
    }

    return data.map((n) => NotificationModel.fromJson(n)).toList();
  }

  Future<int> getUnreadCount() async {
    final res = await _dio.get('/notifications/list/non_lues_count/');
    return int.tryParse(res.data['count'].toString()) ?? 0;
  }

  Future<void> markAsRead(int id) async {
    await _dio.post('/notifications/list/$id/marquer_lue/');
  }

  Future<void> markAllAsRead() async {
    await _dio.post('/notifications/list/marquer_toutes_lues/');
  }
  Future<void> deleteNotifications(List<int> notificationIds) async {
    await _dio.post(
      '/notifications/list/supprimer_groupee/',
      data: {'ids': notificationIds},
    );
  }
}