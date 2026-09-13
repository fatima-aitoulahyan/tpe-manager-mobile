import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/devis_model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
class DevisRemoteDataSource {
  final Dio _dio = DioClient.instance;

  // ── GET /api/devis/ ──
  Future<List<DevisListModel>> getAll({
    String? statut,
    int? clientId,
    String? dateDebut,
    String? dateFin,
  }) async {
    final res = await _dio.get('/devis/', queryParameters: {
      if (statut != null)    'statut':     statut,
      if (clientId != null)  'client':     clientId,
      if (dateDebut != null) 'date_debut': dateDebut,
      if (dateFin != null)   'date_fin':   dateFin,
    });
    return (res.data as List)
        .map((d) => DevisListModel.fromJson(d))
        .toList();
  }

  // ── GET /api/devis/{id}/ ──
  Future<DevisModel> getOne(int id) async {
    final res = await _dio.get('/devis/$id/');
    return DevisModel.fromJson(res.data);
  }

  // ── POST /api/devis/ ──
  Future<DevisModel> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/devis/', data: data);
    return DevisModel.fromJson(res.data);
  }

  // ── PUT /api/devis/{id}/ ──
  Future<DevisModel> update(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/devis/$id/', data: data);
    return DevisModel.fromJson(res.data);
  }

  // ── DELETE /api/devis/{id}/ ──
  Future<void> delete(int id) async {
    await _dio.delete('/devis/$id/');
  }

  // ── POST /api/devis/{id}/change_status/ ──
  Future<void> changeStatus(int id, String status) async {
    await _dio.post('/devis/$id/change_status/', data: {'status': status});
  }

  // ── POST /api/devis/{id}/duplicate/ ──
  Future<DevisModel> duplicate(int id) async {
    final res = await _dio.post('/devis/$id/duplicate/');
    return DevisModel.fromJson(res.data);
  }

  // ── GET /api/devis/stats/ ──
  Future<Map<String, dynamic>> getStats() async {
    final res = await _dio.get('/devis/stats/');
    return res.data;
  }

  Future<String> downloadPdf(int id, String numero) async {
    final res = await _dio.get(
      '/devis/$id/pdf/',
      options: Options(responseType: ResponseType.bytes),
    );

    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/$numero.pdf';
    final file = File(filePath);
    await file.writeAsBytes(res.data);

    return filePath;
  }
  Future<Map<String, dynamic>> getAllPaginated({
    String? statut,
    int? clientId,
    String? dateDebut,
    String? dateFin,
    int page = 1,
    int pageSize = 10,
  }) async {
    final res = await _dio.get('/devis/', queryParameters: {
      if (statut != null && statut.isNotEmpty) 'statut':     statut,
      if (clientId != null)                    'client':     clientId,
      if (dateDebut != null)                   'date_debut': dateDebut,
      if (dateFin != null)                     'date_fin':   dateFin,
      'page':      page,
      'page_size': pageSize,
    });
    return {
      'count':   res.data['count'],
      'hasNext': res.data['next'] != null,
      'devis':   (res.data['results'] as List)
          .map((d) => DevisListModel.fromJson(d))
          .toList(),
    };
  }
  Future<Map<String, dynamic>> convertirEnFacture(int devisId) async {
    final res = await _dio.post('/devis/$devisId/convert_to_facture/');
    return res.data;
  }

  Future<Map<String, dynamic>> generateFromText(String text) async {
    try {
      final res = await _dio.post(
        '/devis/generate-from-text/',
        data: {'text': text},
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 && e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data.containsKey('client_nom_detecte')) {
          throw ClientNotFoundAiException(
            data['error'] ?? "Client introuvable",
            data['client_nom_detecte'] as String,
          );
        }
      }
      rethrow;
    }
  }
}
class ClientNotFoundAiException implements Exception {
  final String message;
  final String clientNomDetecte;
  ClientNotFoundAiException(this.message, this.clientNomDetecte);
}