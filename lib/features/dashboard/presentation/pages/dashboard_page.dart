import 'package:flutter/material.dart';
import 'package:hospital_appointment_admin/features/appointments/presentation/pages/appointments_page.dart';
import 'package:hospital_appointment_admin/features/doctors/presentation/pages/doctors_page.dart';
import 'package:hospital_appointment_admin/features/patients/presentation/pages/patients_page.dart';

import '../../../../core/storage/token_storage.dart';
import '../../../categories/presentation/pages/categories_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TokenStorage _tokenStorage = TokenStorage();

  int _selectedIndex = 0;

  final List<String> _titles = [
    'Dashboard',
    'Doctors',
    'Categories',
    'Appointments',
    'Patients',
  ];

  Future<void> _logout() async {
    await _tokenStorage.clearToken();

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: Row(
        children: [
          _buildSidebar(),

          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: const Color(0xFF111827),
      child: Column(
        children: [
          const SizedBox(height: 28),

          const Icon(
            Icons.local_hospital_rounded,
            size: 42,
            color: Colors.white,
          ),

          const SizedBox(height: 12),

          const Text(
            'Hospital Admin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 35),

          _sidebarItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            index: 0,
          ),

          _sidebarItem(
            icon: Icons.medical_services_outlined,
            title: 'Doctors',
            index: 1,
          ),

          _sidebarItem(
            icon: Icons.category_outlined,
            title: 'Categories',
            index: 2,
          ),

          _sidebarItem(
            icon: Icons.calendar_month_outlined,
            title: 'Appointments',
            index: 3,
          ),

          _sidebarItem(
            icon: Icons.people_outline,
            title: 'Patients',
            index: 4,
          ),

          const Spacer(),

          _sidebarItem(
            icon: Icons.logout,
            title: 'Logout',
            index: 99,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sidebarItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final selected = _selectedIndex == index;

    return InkWell(
      onTap: () {
        if (index == 99) {
          _logout();
          return;
        }

        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2563EB)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 21,
            ),

            const SizedBox(width: 14),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 1:
  return const DoctorsPage();
      case 2:
        return const CategoriesPage();

      case 3:
        return const AppointmentsPage();

      case 4:
          return const PatientsPage();

      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Hospital Admin',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Manage doctors, categories, appointments and patients.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 30),

          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _dashboardCard(
                title: 'Doctors',
                icon: Icons.medical_services_outlined,
              ),
              _dashboardCard(
                title: 'Categories',
                icon: Icons.category_outlined,
              ),
              _dashboardCard(
                title: 'Appointments',
                icon: Icons.calendar_month_outlined,
              ),
              _dashboardCard(
                title: 'Patients',
                icon: Icons.people_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard({
    required String title,
    required IconData icon,
  }) {
    return SizedBox(
      width: 230,
      height: 140,
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 30,
                color: const Color(0xFF2563EB),
              ),

              const Spacer(),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComingSection(
    String title,
    IconData icon,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: const Color(0xFF2563EB),
          ),

          const SizedBox(height: 16),

          Text(
            '$title Management',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'This section will be connected to the backend next.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}