class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final int experience;
  final String image;
  final String username;
  final String email;
  final String phone;
  final String categoryId;
  final String categoryName;
  final bool isActive;
  final List<Map<String, dynamic>> availability;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.image,
    required this.username,
    required this.email,
    required this.phone,
    required this.categoryId,
    required this.categoryName,
    required this.isActive,
    required this.availability,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];

    final rawAvailability = json['availability'];

    final List<Map<String, dynamic>> parsedAvailability = [];

    if (rawAvailability is List) {
      for (final item in rawAvailability) {
        if (item is Map) {
          parsedAvailability.add({
            'date': item['date']?.toString() ?? '',
            'slots': item['slots'] is List
                ? List<String>.from(
                    (item['slots'] as List).map(
                      (slot) => slot.toString(),
                    ),
                  )
                : <String>[],
          });
        }
      }
    }

    return DoctorModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialization:
          json['specialization']?.toString() ?? '',
      experience: json['experience'] is int
          ? json['experience'] as int
          : int.tryParse(
                json['experience']?.toString() ?? '',
              ) ??
              0,
      image: json['image']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      categoryId: category is Map
          ? category['_id']?.toString() ?? ''
          : category?.toString() ?? '',
      categoryName: category is Map
          ? category['name']?.toString() ?? ''
          : '',
      isActive: json['isActive'] ?? true,
      availability: parsedAvailability,
    );
  }
}