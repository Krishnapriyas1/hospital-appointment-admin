import 'package:flutter/material.dart';

import 'package:hospital_appointment_admin/features/auth/presentation/pages/login_page.dart';

import 'core/network/api_client.dart';

import 'features/auth/data/auth_repository.dart';

void main() {
  final apiClient = ApiClient();

  final authRepository = AuthRepository(
    apiClient: apiClient,
  );

  runApp(
    HospitalAdminApp(
      authRepository: authRepository,
    ),
  );
}

class HospitalAdminApp extends StatelessWidget {
  final AuthRepository authRepository;

  const HospitalAdminApp({
    super.key,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital Admin',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: LoginPage(
        authRepository: authRepository,
      ),
    );
  }
}