import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_appointment_admin/main.dart';
import 'package:hospital_appointment_admin/core/network/api_client.dart';
import 'package:hospital_appointment_admin/features/auth/data/auth_repository.dart';

void main() {
  testWidgets(
    'Hospital Admin login page loads',
    (WidgetTester tester) async {
      final apiClient = ApiClient();

      final authRepository = AuthRepository(
        apiClient: apiClient,
      );

      await tester.pumpWidget(
        HospitalAdminApp(
          authRepository: authRepository,
        ),
      );

      expect(
        find.text('Hospital Admin'),
        findsOneWidget,
      );

      expect(
        find.text('Sign In'),
        findsOneWidget,
      );
    },
  );
}