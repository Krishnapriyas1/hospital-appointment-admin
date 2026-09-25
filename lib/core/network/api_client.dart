import 'package:dio/dio.dart';
import 'package:hospital_appointment_admin/core/constants/api_constant.dart';
import 'package:hospital_appointment_admin/core/storage/token_storage.dart';

class ApiClient {
  late final Dio dio;

  final TokenStorage _tokenStorage = TokenStorage();

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
  }) {
    return dio.post(
      path,
      data: data,
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
  }) {
    return dio.put(
      path,
      data: data,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
  }) {
    return dio.delete(
      path,
      data: data,
    );
  }

  Future<Response> patch(
  String path, {
  dynamic data,
}) {
  return dio.patch(
    path,
    data: data,
  );
}
}