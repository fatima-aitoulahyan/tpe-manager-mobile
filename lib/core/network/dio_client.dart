import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static final Dio _dio = Dio();
  static final _storage = FlutterSecureStorage();
  static bool _initialized = false;

  static Dio get instance {
    if (!_initialized) {
      _dio.options.baseUrl = dotenv.env['BASE_URL']!;
      _dio.options.headers = {
        'Content-Type': 'application/json'
      };

      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token =
            await _storage.read(key: 'access_token');

            if (token != null) {
              options.headers['Authorization'] =
              'Bearer $token';
            }

            handler.next(options);
          },

          onError: (error, handler) async {
            if (error.requestOptions.path
                .contains('/auth/logout/')) {
              return handler.next(error);
            }

            if (error.response?.statusCode == 401) {
              final refresh =
              await _storage.read(
                  key: 'refresh_token');

              if (refresh != null) {
                final res = await _dio.post(
                  '/auth/token/refresh/',
                  data: {'refresh': refresh},
                );

                await _storage.write(
                  key: 'access_token',
                  value: res.data['access'],
                );

                return handler.resolve(
                  await _dio.fetch(
                    error.requestOptions,
                  ),
                );
              }
            }

            handler.next(error);
          },
        ),
      );

      _initialized = true;
    }

    return _dio;
  }
}