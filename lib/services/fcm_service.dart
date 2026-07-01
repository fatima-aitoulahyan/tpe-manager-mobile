import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import '../core/network/dio_client.dart';
import '../routes/app_router.dart';

class FCMService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final token = await _messaging.getToken();
    if (token != null) {
      await _registerToken(token);
    }
    _messaging.onTokenRefresh.listen(_registerToken);
    FirebaseMessaging.onMessage.listen((message) {
      _handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message.data);
    });
  }

  static Future<void> _registerToken(String token) async {
    try {
      await DioClient.instance.post(
        '/notifications/register-device/',
        data: {
          'token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
        },
      );
    } on DioException catch (e) {
      print('FCM token registration failed: ${e.message}');
    }
  }

  static void _handleMessage(RemoteMessage message) {
    print('Notification reçue : ${message.notification?.title}');
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    final type = data['type'];
    final id   = data['id'];

    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    switch (type) {
      case 'facture':
        context.go('/factures/$id');
        break;
      case 'devis':
        context.go('/devis/$id');
        break;
      case 'credit':
        context.go('/credit/$id');
        break;
      case 'fiscal':
      case 'fiscale':
        context.go('/factures');
        break;
      case 'cnss':
        context.go('/cashflow');
        break;
    }
  }
}