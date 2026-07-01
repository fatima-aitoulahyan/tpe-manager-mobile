import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio = DioClient.instance;

  // ── POST /api/auth/register/ ──
  Future<Map<String, dynamic>> register({
    required String email,
    required String telephone,
    required String nom,
    required String prenom,
    required String password,
    required String passwordConfirm,
    String? ice,
    String? statutFiscal,
  }) async {
    try {
      final res = await _dio.post('/auth/register/', data: {
        'email':            email,
        'telephone':        telephone,
        'nom':              nom,
        'prenom':           prenom,
        'password':         password,
        'password_confirm': passwordConfirm,
        if (ice != null)          'ice': ice,
        if (statutFiscal != null) 'statut_fiscal': statutFiscal,
      });
      return {
        'user':   UserModel.fromJson(res.data['user']),
        'tokens': AuthTokens.fromJson(res.data['tokens']),
      };
    } on DioException catch (e) {
      final data = e.response?.data;
      print("Erreur Django Register: $data");

      if (data is Map) {
        final messages = <String>[];

        const fieldLabels = {
          'email':            'Email',
          'telephone':        'Téléphone',
          'nom':              'Nom',
          'prenom':           'Prénom',
          'password':         'Mot de passe',
          'password_confirm': 'Confirmation',
          'non_field_errors': '',
          'detail':           '',
        };

        for (final key in fieldLabels.keys) {
          if (data.containsKey(key)) {
            final val = data[key];
            final label = fieldLabels[key]!;
            if (val is List && val.isNotEmpty) {
              final msg = val[0].toString();
              messages.add(label.isEmpty ? msg : '$label : $msg');
            } else if (val is String) {
              messages.add(label.isEmpty ? val : '$label : $val');
            }
          }
        }

        if (messages.isNotEmpty) {
          throw Exception(messages.join('\n'));
        }
      }

      throw Exception('Erreur lors de l\'inscription. Vérifiez votre connexion.');
    }
  }

  // ── POST /api/auth/login/ ──
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post('/auth/login/', data: {
        'email':    email,
        'password': password,
      });
      return {
        'access':  res.data['access'],
        'refresh': res.data['refresh'],
      };
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map) {
        final rawMsg = data['detail'] ?? data['non_field_errors']?[0] ?? 'Identifiants incorrects.';
        final msg = rawMsg.toString().contains('No active account')
            ? 'Email ou mot de passe incorrect.'
            : rawMsg.toString();
        throw Exception(msg);
      }
      throw Exception('Erreur de connexion. Vérifiez votre réseau.');
    }
  }

  // ── POST /api/auth/logout/ ──
  Future<void> logout(String refreshToken) async {
    final cleanRefreshToken = refreshToken.trim().replaceAll('"', '');
    await DioClient.instance.post(
      '/auth/logout/',
      data: {'refresh': cleanRefreshToken},
    );
  }

  // ── GET /api/auth/profile/ ──
  Future<UserModel> getProfile() async {
    final res = await _dio.get('/auth/profile/');
    return UserModel.fromJson(res.data);
  }

  // ── POST /api/auth/token/refresh/ ──
  Future<String> refreshToken(String refresh) async {
    final res = await _dio.post('/auth/token/refresh/', data: {'refresh': refresh});
    return res.data['access'];
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post('/auth/forgot-password/', data: {'email': email});
  }

  Future<bool> verifyResetCode(String email, String code) async {
    final res = await _dio.post('/auth/verify-reset-code/', data: {
      'email': email,
      'code':  code,
    });
    return res.data['valid'] ?? false;
  }

  Future<void> resetPassword(
      String email, String code, String newPassword) async {
    await _dio.post('/auth/reset-password/', data: {
      'email':        email,
      'code':         code,
      'new_password': newPassword,
    });
  }
}