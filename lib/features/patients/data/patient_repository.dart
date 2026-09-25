import 'package:hospital_appointment_admin/core/constants/api_constant.dart';
import '../../../core/network/api_client.dart';
import '../models/patient_model.dart';

class PatientRepository {
  final ApiClient apiClient;

  PatientRepository({
    required this.apiClient,
  });

  Future<List<PatientModel>> getPatients({
    String search = '',
  }) async {
    final response = await apiClient.get(
      ApiConstants.patients,
      queryParameters: {
        if (search.trim().isNotEmpty) 'search': search.trim(),
        'page': 1,
        'limit': 100,
      },
    );

    final data = response.data as Map<String, dynamic>;

    final List<dynamic> patients =
        data['patients'] as List<dynamic>? ?? [];

    return patients
        .map(
          (patient) => PatientModel.fromJson(
            patient as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}