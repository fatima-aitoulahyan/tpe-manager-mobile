import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/client_model.dart';

class ClientRemoteDataSource {
  final Dio _dio = DioClient.instance;

  // ── GET /api/clients/ ──
  Future<List<ClientModel>> getAll() async {
    final res = await _dio.get('/clients/');
    return (res.data as List)
        .map((c) => ClientModel.fromJson(c))
        .toList();
  }

  // ── GET /api/clients/{id}/ ──
  Future<ClientModel> getOne(int id) async {
    final res = await _dio.get('/clients/$id/');
    return ClientModel.fromJson(res.data);
  }

  // ── POST /api/clients/ ──
  Future<ClientModel> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/clients/', data: data);
    return ClientModel.fromJson(res.data);
  }

  // ── PUT /api/clients/{id}/ ──
  Future<ClientModel> update(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/clients/$id/', data: data);
    return ClientModel.fromJson(res.data);
  }

  // ── DELETE /api/clients/{id}/ ──
  Future<void> delete(int id) async {
    await _dio.delete('/clients/$id/');
  }
}