import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/demande_model.dart';
import '../models/eligibilite_model.dart';
import '../models/justificatif_model.dart';

class CreditRemoteDataSource {
  final Dio _dio = DioClient.instance;

  Future<EligibiliteModel> getEligibilite() async {
    final res = await _dio.get('/credit/eligibilite/');
    return EligibiliteModel.fromJson(res.data);
  }

  Future<List<DemandeListModel>> getDemandes({String? statut}) async {
    final res = await _dio.get('/credit/demandes/', queryParameters: {
      if (statut != null && statut.isNotEmpty) 'statut': statut,
    });

    List data;
    if (res.data is List) {
      data = res.data as List;
    } else {
      data = res.data['results'] as List? ?? [];
    }

    return data.map((d) => DemandeListModel.fromJson(d)).toList();
  }

  Future<DemandeModel> getDemande(int id) async {
    final res = await _dio.get('/credit/demandes/$id/');
    return DemandeModel.fromJson(res.data);
  }

  Future<DemandeModel> createDemande(Map<String, dynamic> data) async {
    final res = await _dio.post('/credit/demandes/', data: data);
    return DemandeModel.fromJson(res.data);
  }

  Future<void> deleteDemande(int id) async {
    await _dio.delete('/credit/demandes/$id/');
  }

  Future<JustificatifModel> uploadJustificatif(
      int demandeId, String typeDocument, String filePath) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'type_document': typeDocument,
      'fichier': await MultipartFile.fromFile(
          filePath, filename: fileName),
    });

    final res = await _dio.post(
      '/credit/demandes/$demandeId/upload_justificatif/',
      data: formData,
    );
    return JustificatifModel.fromJson(res.data);
  }

  Future<void> deleteJustificatif(
      int demandeId, int justificatifId) async {
    await _dio.delete(
        '/credit/demandes/$demandeId/justificatif/$justificatifId/');
  }
}