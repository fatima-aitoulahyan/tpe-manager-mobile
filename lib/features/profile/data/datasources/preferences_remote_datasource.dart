import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/preferences_model.dart';

class PreferencesRemoteDataSource {
  final Dio _dio = DioClient.instance;

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