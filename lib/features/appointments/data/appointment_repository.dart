import 'package:hospital_appointment_admin/core/constants/api_constant.dart';
import '../../../core/network/api_client.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  final ApiClient apiClient;

  AppointmentRepository({
    required this.apiClient,
  });

  Future<List<AppointmentModel>> getAllAppointments({
    String? status,
  }) async {
    final response = await apiClient.get(
      '${ApiConstants.appointments}/admin/all',
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );

    final data = response.data as Map<String, dynamic>;

    final List<dynamic> appointments =
        data['appointments'] as List<dynamic>? ?? [];

    return appointments
        .map(
          (item) => AppointmentModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> updateAppointmentStatus({
  required String id,
  required String status,
}) async {
  await apiClient.patch(
    '${ApiConstants.appointments}/$id/status',
    data: {
      'status': status,
    },
  );
}
}