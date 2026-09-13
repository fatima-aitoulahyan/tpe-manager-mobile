import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/network/dio_client.dart';
import '../models/facture_model.dart';

class FactureRemoteDataSource {
  final Dio _dio = DioClient.instance;

  // ── GET /api/factures/ ──
  Future<List<FactureModel>> getAll({
    String? statut,
    int? clientId,
    String? dateDebut,
    String? dateFin,
  }) async {
    final res = await _dio.get('/factures/', queryParameters: {
      if (statut != null)    'statut':     statut,
      if (clientId != null)  'client':     clientId,
      if (dateDebut != null) 'date_debut': dateDebut,
      if (dateFin != null)   'date_fin':   dateFin,
    });
    return (res.data as List)
        .map((f) => FactureModel.fromJson(f))
        .toList();
  }

  // ── GET /api/factures/ (PAGINATED) ──
  Future<Map<String, dynamic>> getAllPaginated({
    String? statut,
    int? clientId,
    String? dateDebut,
    String? dateFin,
    int page = 1,
    int pageSize = 10,
  }) async {
    final res = await _dio.get('/factures/', queryParameters: {
      if (statut != null && statut.isNotEmpty) 'statut':     statut,
      if (clientId != null)                    'client':     clientId,
      if (dateDebut != null)                   'date_debut': dateDebut,
      if (dateFin != null)                     'date_fin':   dateFin,
      'page':      page,
      'page_size': pageSize,
    });
    return {
      'count':       res.data['count'],
      'hasNext':     res.data['next'] != null,
      'factures':    (res.data['results'] as List)
          .map((f) => FactureModel.fromJson(f))
          .toList(),
      'currentPage': page,
    };
  }

  // ── GET /api/factures/{id}/ ──
  Future<FactureModel> getOne(int id) async {
    final res = await _dio.get('/factures/$id/');
    return FactureModel.fromJson(res.data);
  }

  // ── POST /api/factures/ ──
  Future<FactureModel> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/factures/', data: data);
    return FactureModel.fromJson(res.data);
  }

  // ── PUT /api/factures/{id}/ ──
  Future<FactureModel> update(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/factures/$id/', data: data);
    return FactureModel.fromJson(res.data);
  }

  // ── DELETE /api/factures/{id}/ ──
  Future<void> delete(int id) async {
    await _dio.delete('/factures/$id/');
  }

  // ── POST /api/factures/{id}/change_status/ ──
  Future<void> changeStatus(int id, String status, {String? motif}) async {
    await _dio.post('/factures/$id/change_status/', data: {
      'status': status,
      if (motif != null && motif.trim().isNotEmpty) 'motif': motif.trim(),
    });
  }

  // ── POST /api/factures/{id}/enregistrer_paiement/ ──
  Future<Map<String, dynamic>> enregistrerPaiement(int id, double montant) async {
    final res = await _dio.post('/factures/$id/enregistrer_paiement/', data: {'montant': montant});
    return res.data;
  }

  // ── POST /api/factures/{id}/convert_to_facture/ ──
  Future<FactureModel> convertirDevis(int devisId) async {
    final res = await _dio.post('/factures/$devisId/convert_to_facture/');
    return FactureModel.fromJson(res.data);
  }

  // ── GET /api/factures/stats/ ──
  Future<Map<String, dynamic>> getStats() async {
    final res = await _dio.get('/factures/stats/');
    return res.data;
  }

  // ── GET /api/factures/{id}/pdf/ ──
  Future<String> downloadPdf(int id, String numero) async {
    final res = await _dio.get(
      '/factures/$id/pdf/',
      options: Options(responseType: ResponseType.bytes),
    );

    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/$numero.pdf';
    final file = File(filePath);
    await file.writeAsBytes(res.data);

    return filePath;
  }
}