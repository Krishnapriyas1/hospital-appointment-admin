import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../data/patient_repository.dart';
import '../../models/patient_model.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({
    super.key,
  });

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  late final PatientRepository _repository;

  final TextEditingController _searchController =
      TextEditingController();

  List<PatientModel> _patients = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _repository = PatientRepository(
      apiClient: ApiClient(),
    );

    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final patients = await _repository.getPatients(
        search: _searchController.text,
      );

      if (!mounted) return;

      setState(() {
        _patients = patients;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Patients',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              IconButton(
                tooltip: 'Refresh',
                onPressed: _loadPatients,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'View and manage registered patients.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _loadPatients(),
                  decoration: InputDecoration(
                    hintText: 'Search by name, email or phone',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: _loadPatients,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Expanded(
            child: _buildPatientContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load patients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPatients,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_patients.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No patients found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 1,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowHeight: 55,
          dataRowMinHeight: 60,
          dataRowMaxHeight: 70,
          columns: const [
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Phone',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: _patients.map((patient) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            const Color(0xFFE5E7EB),
                        child: Text(
                          patient.name.isNotEmpty
                              ? patient.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        patient.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                DataCell(
                  Text(patient.email),
                ),

                DataCell(
                  Text(
                    patient.phone.isEmpty
                        ? '-'
                        : patient.phone,
                  ),
                ),

                DataCell(
                  _statusChip(patient.isActive),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _statusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}