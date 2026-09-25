import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../data/appointment_repository.dart';
import '../../models/appointment_model.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({
    super.key,
  });

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late final AppointmentRepository _repository;

  List<AppointmentModel> _appointments = [];

  bool _isLoading = true;
  String? _errorMessage;

  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();

    _repository = AppointmentRepository(
      apiClient: ApiClient(),
    );

    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final appointments =
          await _repository.getAllAppointments(
        status: _selectedStatus.isEmpty
            ? null
            : _selectedStatus,
      );

      if (!mounted) return;

      setState(() {
        _appointments = appointments;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _updateStatus(
    AppointmentModel appointment,
    String status,
  ) async {
    try {
      await _repository.updateAppointmentStatus(
        id: appointment.id,
        status: status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Appointment status updated successfully',
          ),
        ),
      );

      await _loadAppointments();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update status: $error',
          ),
        ),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;

      case 'completed':
        return Colors.blue;

      case 'cancelled':
        return Colors.red;

      case 'upcoming':
      default:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 20),

          _buildFilter(),

          const SizedBox(height: 20),

          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appointments',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'View and manage all patient appointments.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          tooltip: 'Refresh',
          onPressed: _loadAppointments,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildFilter() {
    return Row(
      children: [
        const Text(
          'Filter:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: '',
                child: Text('All'),
              ),
              DropdownMenuItem(
                value: 'upcoming',
                child: Text('Upcoming'),
              ),
              DropdownMenuItem(
                value: 'confirmed',
                child: Text('Confirmed'),
              ),
              DropdownMenuItem(
                value: 'completed',
                child: Text('Completed'),
              ),
              DropdownMenuItem(
                value: 'cancelled',
                child: Text('Cancelled'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedStatus = value ?? '';
              });

              _loadAppointments();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 55,
              color: Colors.red,
            ),

            const SizedBox(height: 15),

            const Text(
              'Failed to load appointments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _loadAppointments,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_appointments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 65,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Text(
              'No appointments found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              WidgetStateProperty.all(
            const Color(0xFFF3F4F6),
          ),
          columns: const [
            DataColumn(
              label: Text('Patient'),
            ),
            DataColumn(
              label: Text('Doctor'),
            ),
            DataColumn(
              label: Text('Category'),
            ),
            DataColumn(
              label: Text('Date'),
            ),
            DataColumn(
              label: Text('Time'),
            ),
            DataColumn(
              label: Text('Status'),
            ),
            DataColumn(
              label: Text('Action'),
            ),
          ],
          rows: _appointments.map(
            (appointment) {
              return DataRow(
                cells: [
                  DataCell(
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.patientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          appointment.patientEmail,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  DataCell(
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          appointment.specialization,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  DataCell(
                    Text(
                      appointment.categoryName,
                    ),
                  ),

                  DataCell(
                    Text(
                      _formatDate(
                        appointment.date,
                      ),
                    ),
                  ),

                  DataCell(
                    Text(
                      appointment.time,
                    ),
                  ),

                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(
                          appointment.status,
                        ).withValues(alpha: 0.12),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        appointment.status
                            .toUpperCase(),
                        style: TextStyle(
                          color: _statusColor(
                            appointment.status,
                          ),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  DataCell(
                    PopupMenuButton<String>(
                      tooltip: 'Change status',
                      onSelected: (status) {
                        _updateStatus(
                          appointment,
                          status,
                        );
                      },
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(
                            value: 'upcoming',
                            child: Text('Upcoming'),
                          ),
                          PopupMenuItem(
                            value: 'confirmed',
                            child: Text('Confirmed'),
                          ),
                          PopupMenuItem(
                            value: 'completed',
                            child: Text('Completed'),
                          ),
                          PopupMenuItem(
                            value: 'cancelled',
                            child: Text('Cancelled'),
                          ),
                        ];
                      },
                      child: const Icon(
                        Icons.more_vert,
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}