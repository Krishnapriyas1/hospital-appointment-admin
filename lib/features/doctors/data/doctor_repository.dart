import 'package:hospital_appointment_admin/core/constants/api_constant.dart';

import '../../../core/network/api_client.dart';
import '../models/doctor_model.dart';

class DoctorRepository {
  final ApiClient apiClient;

  DoctorRepository({
    required this.apiClient,
  });

  // ============================================================
  // GET DOCTORS
  // ============================================================

  Future<List<DoctorModel>> getDoctors({
    String? search,
    String? category,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (search != null && search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    if (category != null && category.trim().isNotEmpty) {
      queryParameters['category'] = category.trim();
    }

    final response = await apiClient.get(
      ApiConstants.doctors,
      queryParameters: queryParameters,
    );

    final data = response.data as Map<String, dynamic>;

    final doctors = data['doctors'] as List<dynamic>? ?? [];

    return doctors
        .map(
          (doctor) => DoctorModel.fromJson(
            doctor as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // ============================================================
  // GET DOCTOR BY ID
  // ============================================================

  Future<DoctorModel> getDoctorById(
    String id,
  ) async {
    final response = await apiClient.get(
      '${ApiConstants.doctors}/$id',
    );

    final data = response.data as Map<String, dynamic>;

    return DoctorModel.fromJson(
      data['doctor'] as Map<String, dynamic>,
    );
  }

  // ============================================================
  // CREATE DOCTOR
  // ============================================================

  Future<DoctorModel> createDoctor({
    required String name,
    required String specialization,
    required int experience,
    required String username,
    required String password,
    required String email,
    required String phone,
    required String category,
    required List<Map<String, dynamic>> availability,
  }) async {
    final response = await apiClient.post(
      ApiConstants.doctors,
      data: {
        'name': name.trim(),
        'specialization': specialization.trim(),
        'experience': experience,
        'username': username.trim(),
        'password': password,
        'email': email.trim(),
        'phone': phone.trim(),
        'category': category,
        'availability': availability,
      },
    );

    final data = response.data as Map<String, dynamic>;

    return DoctorModel.fromJson(
      data['doctor'] as Map<String, dynamic>,
    );
  }

  // ============================================================
  // UPDATE DOCTOR
  // ============================================================

  Future<DoctorModel> updateDoctor({
    required String id,
    required String name,
    required String specialization,
    required int experience,
    required String email,
    required String phone,
    required String category,
    required List<Map<String, dynamic>> availability,
    required bool isActive,
  }) async {
    final response = await apiClient.put(
      '${ApiConstants.doctors}/$id',
      data: {
        'name': name.trim(),
        'specialization': specialization.trim(),
        'experience': experience,
        'email': email.trim(),
        'phone': phone.trim(),
        'category': category,
        'availability': availability,
        'isActive': isActive,
      },
    );

    final data = response.data as Map<String, dynamic>;

    return DoctorModel.fromJson(
      data['doctor'] as Map<String, dynamic>,
    );
  }

  // ============================================================
  // DELETE DOCTOR
  // ============================================================

  Future<void> deleteDoctor(
    String id,
  ) async {
    await apiClient.delete(
      '${ApiConstants.doctors}/$id',
    );
  }
}