class AdminLoginModel {
  final String token;
  final AdminUserModel user;

  const AdminLoginModel({
    required this.token,
    required this.user,
  });

  factory AdminLoginModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminLoginModel(
      token: json['token'] ?? '',
      user: AdminUserModel.fromJson(
        json['user'] ?? {},
      ),
    );
  }
}

class AdminUserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String role;

  const AdminUserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    required this.role,
  });

  factory AdminUserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminUserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? '',
    );
  }
}