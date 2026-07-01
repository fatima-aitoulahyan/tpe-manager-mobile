import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/preferences_model.dart';
import '../models/user_model.dart';

class ProfileRemoteDataSource {
  final Dio _dio = DioClient.instance;

  Options _options(String token) => Options(headers: {'Authorization': 'Bearer $token'});

  Future<UserModel> getProfile(String token) async {
    final response = await _dio.get('/auth/profile/', options: _options(token));
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> updateProfile(String token, UserModel user) async {
    final response = await _dio.put('/auth/profile/', data: user.toJson(), options: _options(token));
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> changePassword(String token, String oldPassword, String newPassword) async {
    await _dio.post(
      '/auth/change-password/',
      data: {'old_password': oldPassword, 'new_password': newPassword},
      options: _options(token),
    );
  }

  Future<void> logout(String token, String refreshToken) async {
    await _dio.post(
      '/auth/logout/',
      data: {'refresh': refreshToken},
      options: _options(token),
    );
  }
  Future<void> saveEmailConfig({
    required String emailAddress,
    required String emailPassword,
  }) async {
    await DioClient.instance.patch('/auth/config-email/', data: {
      'email_address': emailAddress,
      'email_password': emailPassword,
    });
  }
  Future<PreferencesModel> getPreferences() async {
    final res = await _dio.get('/notifications/preferences/');
    return PreferencesModel.fromJson(res.data);
  }

  Future<PreferencesModel> updatePreferences(
      PreferencesModel prefs) async {
    final res = await _dio.put(
      '/notifications/preferences/',
      data: prefs.toJson(),
    );
    return PreferencesModel.fromJson(res.data);
  }
}