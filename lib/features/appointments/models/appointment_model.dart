class AppointmentModel {
  final String id;
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final String doctorName;
  final String specialization;
  final String categoryName;
  final DateTime date;
  final String time;
  final String status;
  final String reason;

  AppointmentModel({
    required this.id,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.doctorName,
    required this.specialization,
    required this.categoryName,
    required this.date,
    required this.time,
    required this.status,
    required this.reason,
  });

  factory AppointmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final patient =
        json['patient'] as Map<String, dynamic>? ?? {};

    final doctor =
        json['doctor'] as Map<String, dynamic>? ?? {};

    final category =
        doctor['category'] as Map<String, dynamic>? ?? {};

    return AppointmentModel(
      id: json['_id'] ?? '',
      patientName: patient['name'] ?? 'Unknown',
      patientEmail: patient['email'] ?? '',
      patientPhone: patient['phone'] ?? '',
      doctorName: doctor['name'] ?? 'Unknown',
      specialization: doctor['specialization'] ?? '',
      categoryName: category['name'] ?? '',
      date: DateTime.tryParse(
            json['date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      time: json['time'] ?? '',
      status: json['status'] ?? 'upcoming',
      reason: json['reason'] ?? '',
    );
  }
}