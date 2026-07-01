import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/dashboard_model.dart';

class DashboardRemoteDataSource {
  final Dio _dio = DioClient.instance;

  Future<CashflowSummary> getCashflowSummary() async {
    final res = await _dio.get('/tresorerie/dashboard/');
    return CashflowSummary.fromJson(res.data as Map<String, dynamic>);
  }

  Future<DevisStats> getDevisStats() async {
    final res = await _dio.get('/devis/stats/');
    return DevisStats.fromJson(res.data as Map<String, dynamic>);
  }
}