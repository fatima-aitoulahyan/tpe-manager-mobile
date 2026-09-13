import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/transaction_model.dart';

class CashflowRemoteDataSource {
  final Dio _dio = DioClient.instance;

  Future<DashboardModel> getDashboard() async {
    final res = await _dio.get('/tresorerie/dashboard/');
    return DashboardModel.fromJson(res.data);
  }

  Future<Map<String, dynamic>> getAllPaginated({
    String? type,
    String? categorie,
    String? dateDebut,
    String? dateFin,
    String? search,
    int     page     = 1,
    int     pageSize = 20,
  }) async {
    final res = await _dio.get('/tresorerie/', queryParameters: {
      if (type != null && type.isNotEmpty)           'type':       type,
      if (categorie != null && categorie.isNotEmpty) 'categorie':  categorie,
      if (dateDebut != null)                         'date_debut': dateDebut,
      if (dateFin != null)                           'date_fin':   dateFin,
      if (search != null && search.trim().isNotEmpty) 'search':    search.trim(),
      'page':      page,
      'page_size': pageSize,
    });
    print('API Response: ${res.data}');
    return {
      'hasNext':      res.data['next'] != null,
      'transactions': (res.data['results'] as List)
          .map((t) => TransactionModel.fromJson(t))
          .toList(),
    };
  }

  Future<TransactionModel> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/tresorerie/', data: data);
    return TransactionModel.fromJson(res.data);
  }

  Future<TransactionModel> update(
      int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/tresorerie/$id/', data: data);
    return TransactionModel.fromJson(res.data);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/tresorerie/$id/');
  }
}