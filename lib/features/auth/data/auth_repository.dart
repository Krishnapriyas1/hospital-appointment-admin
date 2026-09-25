import 'package:dio/dio.dart';
import 'package:hospital_appointment_admin/core/constants/api_constant.dart';
import '../../../core/network/api_client.dart';
import '../models/admin_login_model.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({
    required this.apiClient,
  });

  Future<AdminLoginModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.adminLogin,
        data: {
          'username': username.trim(),
          'password': password,
        },
      );

      final data = response.data;

      if (data['success'] != true) {
        throw Exception(
          data['message'] ?? 'Admin login failed',
        );
      }

      return AdminLoginModel.fromJson(data);
    } on DioException catch (error) {
      if (error.response?.data is Map) {
        final message =
            error.response?.data['message'];

        throw Exception(
          message ?? 'Admin login failed',
        );
      }

      throw Exception(
        'Unable to connect to the server',
      );
    }
  }
}