class PatientModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isActive;
  final DateTime? createdAt;

  PatientModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    this.createdAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}