import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../categories/data/category_repository.dart';
import '../../../categories/models/category_model.dart';
import '../../data/doctor_repository.dart';
import '../../models/doctor_model.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({
    super.key,
  });

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  late final DoctorRepository _doctorRepository;
  late final CategoryRepository _categoryRepository;

  List<DoctorModel> _doctors = [];
  List<CategoryModel> _categories = [];

  bool _loading = true;
  bool _categoriesLoading = false;

  String _search = '';

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient();

    _doctorRepository = DoctorRepository(
      apiClient: apiClient,
    );

    _categoryRepository = CategoryRepository(
      apiClient: apiClient,
    );

    _loadDoctors();
    _loadCategories();
  }

  // ============================================================
  // LOAD DOCTORS
  // ============================================================

  Future<void> _loadDoctors() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    try {
      final doctors = await _doctorRepository.getDoctors(
        search: _search,
      );

      if (!mounted) return;

      setState(() {
        _doctors = doctors;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Failed to load doctors',
        isError: true,
      );
    }
  }

  // ============================================================
  // LOAD CATEGORIES
  // ============================================================

  Future<void> _loadCategories() async {
    if (mounted) {
      setState(() {
        _categoriesLoading = true;
      });
    }

    try {
      final categories =
          await _categoryRepository.getCategories();

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _categoriesLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _categoriesLoading = false;
      });

      _showMessage(
        'Failed to load categories',
        isError: true,
      );
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red : Colors.green,
      ),
    );
  }

  // ============================================================
  // TIME OPTIONS
  // ============================================================

  List<String> get _timeOptions => [
        '09:00 AM',
        '09:30 AM',
        '10:00 AM',
        '10:30 AM',
        '11:00 AM',
        '11:30 AM',
        '12:00 PM',
        '12:30 PM',
        '02:00 PM',
        '02:30 PM',
        '03:00 PM',
        '03:30 PM',
        '04:00 PM',
        '04:30 PM',
        '05:00 PM',
        '05:30 PM',
      ];

  // ============================================================
  // ADD DOCTOR
  // ============================================================

  Future<void> _showAddDoctorDialog() async {
    if (_categories.isEmpty) {
      await _loadCategories();
    }

    if (_categories.isEmpty) {
      _showMessage(
        'Please create an active category first.',
        isError: true,
      );
      return;
    }

    final nameController = TextEditingController();
    final specializationController =
        TextEditingController();
    final experienceController =
        TextEditingController();
    final usernameController =
        TextEditingController();
    final passwordController =
        TextEditingController();
    final emailController =
        TextEditingController();
    final phoneController =
        TextEditingController();

    String? categoryId;

    final List<Map<String, dynamic>> availability = [];

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            dialogContext,
            setDialogState,
          ) {
            return AlertDialog(
              title: const Text(
                'Add Doctor',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // NAME
                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(
                          labelText: 'Doctor Name',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // SPECIALIZATION
                      TextField(
                        controller:
                            specializationController,
                        decoration:
                            const InputDecoration(
                          labelText: 'Specialization',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // EXPERIENCE
                      TextField(
                        controller:
                            experienceController,
                        keyboardType:
                            TextInputType.number,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Experience (years)',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // USERNAME
                      TextField(
                        controller:
                            usernameController,
                        decoration:
                            const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // PASSWORD
                      TextField(
                        controller:
                            passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // EMAIL
                      TextField(
                        controller: emailController,
                        keyboardType:
                            TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // PHONE
                      TextField(
                        controller: phoneController,
                        keyboardType:
                            TextInputType.phone,
                        decoration:
                            const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // CATEGORY
                      DropdownButtonFormField<String>(
                        value: categoryId,
                        decoration:
                            const InputDecoration(
                          labelText: 'Category',
                          border:
                              OutlineInputBorder(),
                        ),
                        items: _categories.map(
                          (category) {
                            return DropdownMenuItem<
                                String>(
                              value: category.id,
                              child: Text(
                                category.name,
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            categoryId = value;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      _buildAvailabilityHeader(
                        'Add available dates and time slots for this doctor.',
                      ),

                      const SizedBox(height: 14),

                      // ADD DATE
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await _addAvailabilityDate(
                              dialogContext:
                                  dialogContext,
                              availability:
                                  availability,
                              setDialogState:
                                  setDialogState,
                            );
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                          label: const Text(
                            'Add Available Date',
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildAvailabilityList(
                        availability:
                            availability,
                        dialogContext:
                            dialogContext,
                        setDialogState:
                            setDialogState,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  onPressed: categoryId == null
                      ? null
                      : () async {
                          final validation =
                              _validateDoctorFields(
                            name:
                                nameController.text,
                            specialization:
                                specializationController
                                    .text,
                            experience:
                                experienceController
                                    .text,
                            email:
                                emailController.text,
                          );

                          if (validation != null) {
                            _showMessage(
                              validation,
                              isError: true,
                            );
                            return;
                          }

                          if (usernameController
                              .text
                              .trim()
                              .isEmpty) {
                            _showMessage(
                              'Username is required',
                              isError: true,
                            );
                            return;
                          }

                          if (passwordController
                              .text
                              .isEmpty) {
                            _showMessage(
                              'Password is required',
                              isError: true,
                            );
                            return;
                          }

                          if (availability.isEmpty) {
                            _showMessage(
                              'Please add at least one available date and time slot.',
                              isError: true,
                            );
                            return;
                          }

                          final experience =
                              int.parse(
                            experienceController
                                .text
                                .trim(),
                          );

                          try {
                            await _doctorRepository
                                .createDoctor(
                              name: nameController
                                  .text
                                  .trim(),
                              specialization:
                                  specializationController
                                      .text
                                      .trim(),
                              experience:
                                  experience,
                              username:
                                  usernameController
                                      .text
                                      .trim(),
                              password:
                                  passwordController
                                      .text,
                              email:
                                  emailController.text
                                      .trim(),
                              phone:
                                  phoneController.text
                                      .trim(),
                              category:
                                  categoryId!,
                              availability:
                                  availability,
                            );

                            if (!dialogContext
                                .mounted) {
                              return;
                            }

                            Navigator.pop(
                              dialogContext,
                            );

                            _showMessage(
                              'Doctor created successfully',
                            );

                            await _loadDoctors();
                          } catch (error) {
                            _showMessage(
                              'Failed to create doctor: $error',
                              isError: true,
                            );
                          }
                        },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Create Doctor',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    specializationController.dispose();
    experienceController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  // ============================================================
  // EDIT DOCTOR
  // ============================================================

  Future<void> _showEditDoctorDialog(
    DoctorModel doctor,
  ) async {
    if (_categories.isEmpty) {
      await _loadCategories();
    }

    if (_categories.isEmpty) {
      _showMessage(
        'Please create an active category first.',
        isError: true,
      );
      return;
    }

    // ==========================================================
    // GET COMPLETE DOCTOR DETAILS
    // ==========================================================

    DoctorModel completeDoctor;

    try {
      completeDoctor =
          await _doctorRepository.getDoctorById(
        doctor.id,
      );
    } catch (error) {
      _showMessage(
        'Failed to load doctor details',
        isError: true,
      );
      return;
    }

    // ==========================================================
    // CONTROLLERS
    // ==========================================================

    final nameController =
        TextEditingController(
      text: completeDoctor.name,
    );

    final specializationController =
        TextEditingController(
      text: completeDoctor.specialization,
    );

    final experienceController =
        TextEditingController(
      text: completeDoctor.experience.toString(),
    );

    final emailController =
        TextEditingController(
      text: completeDoctor.email,
    );

    final phoneController =
        TextEditingController(
      text: completeDoctor.phone,
    );

    // IMPORTANT:
    // DoctorModel has categoryId, not category.id
    String? categoryId =
        completeDoctor.categoryId;

    // ==========================================================
    // EXISTING AVAILABILITY
    // ==========================================================

  final List<Map<String, dynamic>> availability = [];

for (final item in completeDoctor.availability) {
  final Map<String, dynamic> availabilityItem =
      Map<String, dynamic>.from(item);

  final List<dynamic> rawSlots =
      availabilityItem['slots'] is List
          ? availabilityItem['slots'] as List
          : [];

  availability.add({
    'date': availabilityItem['date']?.toString() ?? '',
    'slots': rawSlots
        .map((slot) => slot.toString())
        .toList(),
  });
}

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            dialogContext,
            setDialogState,
          ) {
            return AlertDialog(
              title: const Text(
                'Edit Doctor',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ==================================================
                      // NAME
                      // ==================================================

                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(
                          labelText: 'Doctor Name',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // SPECIALIZATION
                      // ==================================================

                      TextField(
                        controller:
                            specializationController,
                        decoration:
                            const InputDecoration(
                          labelText: 'Specialization',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // EXPERIENCE
                      // ==================================================

                      TextField(
                        controller:
                            experienceController,
                        keyboardType:
                            TextInputType.number,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Experience (years)',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // EMAIL
                      // ==================================================

                      TextField(
                        controller: emailController,
                        keyboardType:
                            TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(
                          labelText: 'Email',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // PHONE
                      // ==================================================

                      TextField(
                        controller: phoneController,
                        keyboardType:
                            TextInputType.phone,
                        decoration:
                            const InputDecoration(
                          labelText: 'Phone',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // CATEGORY
                      // ==================================================

                      DropdownButtonFormField<String>(
                        value: _categories.any(
                          (category) =>
                              category.id ==
                              categoryId,
                        )
                            ? categoryId
                            : null,
                        decoration:
                            const InputDecoration(
                          labelText: 'Category',
                          border:
                              OutlineInputBorder(),
                        ),
                        items: _categories.map(
                          (category) {
                            return DropdownMenuItem<
                                String>(
                              value: category.id,
                              child: Text(
                                category.name,
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            categoryId = value;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // AVAILABILITY HEADER
                      // ==================================================

                      _buildAvailabilityHeader(
                        'Add, edit or remove available dates and time slots.',
                      ),

                      const SizedBox(height: 14),

                      // ==================================================
                      // ADD DATE
                      // ==================================================

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await _addAvailabilityDate(
                              dialogContext:
                                  dialogContext,
                              availability:
                                  availability,
                              setDialogState:
                                  setDialogState,
                            );
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                          label: const Text(
                            'Add Available Date',
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // AVAILABILITY LIST
                      // ==================================================

                      _buildAvailabilityList(
                        availability:
                            availability,
                        dialogContext:
                            dialogContext,
                        setDialogState:
                            setDialogState,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: categoryId == null
                      ? null
                      : () async {
                          final validation =
                              _validateDoctorFields(
                            name:
                                nameController.text,
                            specialization:
                                specializationController
                                    .text,
                            experience:
                                experienceController
                                    .text,
                            email:
                                emailController.text,
                          );

                          if (validation != null) {
                            _showMessage(
                              validation,
                              isError: true,
                            );
                            return;
                          }

                          if (availability.isEmpty) {
                            _showMessage(
                              'Please add at least one available date and time slot.',
                              isError: true,
                            );
                            return;
                          }

                          final experience =
                              int.parse(
                            experienceController
                                .text
                                .trim(),
                          );

                          try {
                            await _doctorRepository
                                .updateDoctor(
                              id: doctor.id,
                              name: nameController
                                  .text
                                  .trim(),
                              specialization:
                                  specializationController
                                      .text
                                      .trim(),
                              experience:
                                  experience,
                              email:
                                  emailController.text
                                      .trim(),
                              phone:
                                  phoneController.text
                                      .trim(),
                              category:
                                  categoryId!,
                              availability:
                                  availability,
                              isActive:
                                  doctor.isActive,
                            );

                            if (!dialogContext
                                .mounted) {
                              return;
                            }

                            Navigator.pop(
                              dialogContext,
                            );

                            _showMessage(
                              'Doctor updated successfully',
                            );

                            await _loadDoctors();
                          } catch (error) {
                            _showMessage(
                              'Failed to update doctor: $error',
                              isError: true,
                            );
                          }
                        },
                  icon: const Icon(
                    Icons.save,
                  ),
                  label: const Text(
                    'Save Changes',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    specializationController.dispose();
    experienceController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  // ============================================================
  // AVAILABILITY HEADER
  // ============================================================

  Widget _buildAvailabilityHeader(
    String description,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Doctor Availability',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD AVAILABILITY DATE
  // ============================================================

  Future<void> _addAvailabilityDate({
    required BuildContext dialogContext,
    required List<Map<String, dynamic>>
        availability,
    required void Function(void Function())
        setDialogState,
  }) async {
    final selectedDate =
        await showDatePicker(
      context: dialogContext,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      initialDate: DateTime.now(),
    );

    if (selectedDate == null) {
      return;
    }

    final dateOnly =
        DateUtils.dateOnly(selectedDate);

    final alreadyExists =
        availability.any(
      (item) {
        final dateString =
            item['date']?.toString();

        if (dateString == null ||
            dateString.isEmpty) {
          return false;
        }

        try {
          final existingDate =
              DateTime.parse(dateString);

          return DateUtils.isSameDay(
            existingDate,
            dateOnly,
          );
        } catch (_) {
          return false;
        }
      },
    );

    if (alreadyExists) {
      _showMessage(
        'This date is already added.',
        isError: true,
      );
      return;
    }

    await _showTimeSlotDialog(
      dialogContext: dialogContext,
      date: dateOnly,
      initialSlots: [],
      onSave: (slots) {
        availability.add({
          'date':
    '${dateOnly.year.toString().padLeft(4, '0')}-'
    '${dateOnly.month.toString().padLeft(2, '0')}-'
    '${dateOnly.day.toString().padLeft(2, '0')}',
          'slots': slots,
        });

        setDialogState(() {});
      },
    );
  }

  // ============================================================
  // AVAILABILITY LIST
  // ============================================================

  Widget _buildAvailabilityList({
    required List<Map<String, dynamic>>
        availability,
    required BuildContext dialogContext,
    required void Function(void Function())
        setDialogState,
  }) {
    if (availability.isEmpty) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'No available dates added.',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      children: availability
          .asMap()
          .entries
          .map(
        (entry) {
          final index = entry.key;
          final item = entry.value;

          DateTime? date;

          try {
            date = DateTime.parse(
              item['date'].toString(),
            );
          } catch (_) {
            date = null;
          }

          final slots =
              List<String>.from(
            item['slots'] ?? [],
          );

          if (date == null) {
            return const SizedBox.shrink();
          }

          return Card(
            margin:
                const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              leading:
                  const CircleAvatar(
                backgroundColor:
                    Color(0xFFE0ECFF),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
              ),
              title: Text(
                '${date.day.toString().padLeft(2, '0')}/'
                '${date.month.toString().padLeft(2, '0')}/'
                '${date.year}',
                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding:
                    const EdgeInsets.only(
                  top: 6,
                ),
                child: Text(
                  slots.isEmpty
                      ? 'No time slots'
                      : slots.join(' • '),
                ),
              ),
              trailing: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  // EDIT TIME SLOTS
                  IconButton(
                    tooltip:
                        'Edit time slots',
                    icon: const Icon(
                      Icons.edit_calendar,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      await _showTimeSlotDialog(
                        dialogContext:
                            dialogContext,
                        date: date!,
                        initialSlots: slots,
                        onSave: (newSlots) {
                          availability[index]
                                  ['slots'] =
                              newSlots;

                          setDialogState(() {});
                        },
                      );
                    },
                  ),

                  // DELETE DATE
                  IconButton(
                    tooltip:
                        'Remove date',
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        availability
                            .removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  // ============================================================
  // TIME SLOT DIALOG
  // ============================================================

  Future<void> _showTimeSlotDialog({
    required BuildContext dialogContext,
    required DateTime date,
    required List<String> initialSlots,
    required void Function(List<String>)
        onSave,
  }) async {
    final List<String> selectedSlots = initialSlots
    .map((slot) => slot.toString())
    .toList();

    await showDialog(
      context: dialogContext,
      builder: (slotContext) {
        return StatefulBuilder(
          builder: (
            slotContext,
            setSlotState,
          ) {
            return AlertDialog(
              title: Text(
                'Time Slots\n'
                '${date.day.toString().padLeft(2, '0')}/'
                '${date.month.toString().padLeft(2, '0')}/'
                '${date.year}',
              ),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _timeOptions.map(
                      (time) {
                        final isSelected =
                            selectedSlots
                                .contains(time);

                        return FilterChip(
                          label: Text(time),
                          selected:
                              isSelected,
                          onSelected:
                              (value) {
                            setSlotState(() {
                              if (value) {
                                if (!selectedSlots
                                    .contains(
                                  time,
                                )) {
                                  selectedSlots
                                      .add(time);
                                }
                              } else {
                                selectedSlots
                                    .remove(
                                  time,
                                );
                              }
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      slotContext,
                    );
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      selectedSlots.isEmpty
                          ? null
                          : () {
                              onSave(
                                List<String>.from(
                                  selectedSlots,
                                ),
                              );

                              Navigator.pop(
                                slotContext,
                              );
                            },
                  child: const Text(
                    'Save Slots',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // VALIDATE DOCTOR FIELDS
  // ============================================================

  String? _validateDoctorFields({
    required String name,
    required String specialization,
    required String experience,
    required String email,
  }) {
    if (name.trim().isEmpty) {
      return 'Doctor name is required';
    }

    if (specialization.trim().isEmpty) {
      return 'Specialization is required';
    }

    if (int.tryParse(
          experience.trim(),
        ) ==
        null) {
      return 'Enter a valid experience';
    }

    if (email.trim().isEmpty) {
      return 'Email is required';
    }

    return null;
  }

  // ============================================================
  // DELETE DOCTOR
  // ============================================================

  Future<void> _deleteDoctor(
    DoctorModel doctor,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Doctor',
          ),
          content: Text(
            'Are you sure you want to deactivate ${doctor.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _doctorRepository.deleteDoctor(
        doctor.id,
      );

      _showMessage(
        'Doctor deleted successfully',
      );

      await _loadDoctors();
    } catch (error) {
      _showMessage(
        'Failed to delete doctor',
        isError: true,
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // HEADER
          // ==========================================================

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Doctors',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              OutlinedButton.icon(
                onPressed: _loadDoctors,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: const Text(
                  'Refresh',
                ),
              ),

              const SizedBox(width: 12),

              ElevatedButton.icon(
                onPressed:
                    _categoriesLoading
                        ? null
                        : _showAddDoctorDialog,
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text(
                  'Add Doctor',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ==========================================================
          // SEARCH
          // ==========================================================

          TextField(
            decoration: InputDecoration(
              hintText:
                  'Search doctors...',
              prefixIcon:
                  const Icon(
                Icons.search,
              ),
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
            ),
            onChanged: (value) {
              _search = value;
              _loadDoctors();
            },
          ),

          const SizedBox(height: 24),

          // ==========================================================
          // DOCTORS LIST
          // ==========================================================

          Expanded(
            child: _loading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : _doctors.isEmpty
                    ? const Center(
                        child: Text(
                          'No doctors found',
                          style: TextStyle(
                            color:
                                Colors.grey,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount:
                            _doctors.length,
                        separatorBuilder:
                            (_, __) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder:
                            (
                          context,
                          index,
                        ) {
                          final doctor =
                              _doctors[index];

                          return Card(
                            child: ListTile(
                              leading:
                                  CircleAvatar(
                                child: Text(
                                  doctor.name
                                          .isNotEmpty
                                      ? doctor
                                          .name[0]
                                          .toUpperCase()
                                      : 'D',
                                ),
                              ),
                              title: Text(
                                doctor.name,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                              subtitle:
                                  Text(
                                '${doctor.specialization} • '
                                '${doctor.experience} years\n'
                                '${doctor.email}',
                              ),
                              isThreeLine:
                                  true,

                              // ==================================================
                              // EDIT + DELETE
                              // ==================================================

                              trailing:
                                  Row(
                                mainAxisSize:
                                    MainAxisSize
                                        .min,
                                children: [
                                  IconButton(
                                    tooltip:
                                        'Edit Doctor',
                                    onPressed: () {
                                      _showEditDoctorDialog(
                                        doctor,
                                      );
                                    },
                                    icon:
                                        const Icon(
                                      Icons
                                          .edit_outlined,
                                      color:
                                          Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip:
                                        'Delete Doctor',
                                    onPressed: () {
                                      _deleteDoctor(
                                        doctor,
                                      );
                                    },
                                    icon:
                                        const Icon(
                                      Icons
                                          .delete_outline,
                                      color:
                                          Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}