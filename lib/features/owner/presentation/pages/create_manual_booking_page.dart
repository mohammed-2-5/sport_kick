import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';

/// Create Manual Booking Page
///
/// 2-step flow for creating manual bookings (admin for walk-in customers):
/// - Step 1: Select field, date, time slot, and price
/// - Step 2: Enter customer information (name, phone, email, notes)
class CreateManualBookingPage extends StatelessWidget {
  const CreateManualBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FieldsCubit>()..loadAllFields()),
        BlocProvider(create: (_) => sl<BookingCubit>()),
      ],
      child: const _CreateManualBookingView(),
    );
  }
}

class _CreateManualBookingView extends StatefulWidget {
  const _CreateManualBookingView();

  @override
  State<_CreateManualBookingView> createState() =>
      _CreateManualBookingViewState();
}

class _CreateManualBookingViewState extends State<_CreateManualBookingView> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1 data
  FieldEntity? _selectedField;
  DateTime? _selectedDate;
  String? _selectedStartTime;
  String? _selectedEndTime;
  double? _totalPrice;

  // Step 2 data
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _notesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate step 1
      if (_selectedField == null) {
        _showError('Please select a field');
        return;
      }
      if (_selectedDate == null) {
        _showError('Please select a date');
        return;
      }
      if (_selectedStartTime == null || _selectedEndTime == null) {
        _showError('Please select a time slot');
        return;
      }
      if (_totalPrice == null || _totalPrice! <= 0) {
        _showError('Please enter a valid price');
        return;
      }

      // Move to step 2
      setState(() => _currentStep = 1);
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitBooking() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<BookingCubit>().createManualBooking(
      fieldId: _selectedField!.id,
      date: _selectedDate!,
      startTime: _selectedStartTime!,
      endTime: _selectedEndTime!,
      totalPrice: _totalPrice!,
      customerName: _customerNameController.text.trim(),
      customerPhone: _customerPhoneController.text.trim(),
      customerEmail: _customerEmailController.text.trim().isEmpty
          ? null
          : _customerEmailController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Manual Booking'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is BookingCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Manual booking created successfully for ${_customerNameController.text}',
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
            Navigator.pop(context, true); // Return true to indicate success
          }
        },
        builder: (context, state) {
          final isLoading = state is BookingLoading;

          return Column(
            children: [
              // Step indicator
              _buildStepIndicator(),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [_buildStep1(), _buildStep2()],
                ),
              ),

              // Bottom action buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading ? null : _previousStep,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : (_currentStep == 0 ? _nextStep : _submitBooking),
                        icon: Icon(
                          _currentStep == 0 ? Icons.arrow_forward : Icons.check,
                        ),
                        label: Text(
                          _currentStep == 0 ? 'Next' : 'Create Booking',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      child: Row(
        children: [
          _buildStepCircle(1, 'Booking Details', _currentStep >= 0),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep >= 1
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300],
            ),
          ),
          _buildStepCircle(2, 'Customer Info', _currentStep >= 1),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label, bool isActive) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Colors.grey[300]!;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : Colors.white,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? color : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return BlocBuilder<FieldsCubit, FieldsState>(
      builder: (context, state) {
        if (state is FieldsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FieldsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<FieldsCubit>().loadAllFields();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is FieldsLoaded) {
          final fields = state.fields;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select field, date, time, and price',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Field selection
                Text(
                  'Select Field',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<FieldEntity>(
                    value: _selectedField,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: 'Choose a field',
                    ),
                    items: fields.map((field) {
                      return DropdownMenuItem(
                        value: field,
                        child: Text(field.name),
                      );
                    }).toList(),
                    onChanged: (field) {
                      setState(() {
                        _selectedField = field;
                        // Reset time slot when field changes
                        _selectedStartTime = null;
                        _selectedEndTime = null;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Date selection
                Text(
                  'Select Date',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                        // Reset time slot when date changes
                        _selectedStartTime = null;
                        _selectedEndTime = null;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDate == null
                              ? 'Choose a date'
                              : DateFormat(
                                  'EEEE, MMM d, y',
                                ).format(_selectedDate!),
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedDate == null
                                ? Colors.grey[600]
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Time slot selection
                Text(
                  'Time Slot',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeDropdown(
                        'Start Time',
                        _selectedStartTime,
                        (time) {
                          setState(() {
                            _selectedStartTime = time;
                            // Auto-set end time to 1 hour later
                            if (time != null) {
                              final hour = int.parse(time.split(':')[0]);
                              if (hour < 23) {
                                _selectedEndTime =
                                    '${(hour + 1).toString().padLeft(2, '0')}:00';
                              }
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimeDropdown(
                        'End Time',
                        _selectedEndTime,
                        (time) => setState(() => _selectedEndTime = time),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Price input
                Text(
                  'Total Price (EGP)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _totalPrice?.toString() ?? '',
                  decoration: InputDecoration(
                    hintText: 'Enter price',
                    prefixIcon: const Icon(Icons.monetization_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _totalPrice = double.tryParse(value);
                    });
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        }

        return const Center(child: Text('No fields available'));
      },
    );
  }

  Widget _buildTimeDropdown(
    String label,
    String? value,
    Function(String?) onChanged,
  ) {
    // Generate time slots from 06:00 to 23:00
    final timeSlots = List.generate(
      18,
      (index) => '${(index + 6).toString().padLeft(2, '0')}:00',
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: timeSlots.map((time) {
          return DropdownMenuItem(value: time, child: Text(time));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter customer details for walk-in booking',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Booking summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Booking Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Field', _selectedField?.name ?? '-'),
                  _buildSummaryRow(
                    'Date',
                    _selectedDate == null
                        ? '-'
                        : DateFormat('MMM d, y').format(_selectedDate!),
                  ),
                  _buildSummaryRow(
                    'Time',
                    '$_selectedStartTime - $_selectedEndTime',
                  ),
                  _buildSummaryRow(
                    'Price',
                    'EGP ${_totalPrice?.toStringAsFixed(0) ?? '-'}',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Customer name
            TextFormField(
              controller: _customerNameController,
              decoration: InputDecoration(
                labelText: 'Customer Name *',
                hintText: 'Enter full name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Customer name is required';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Customer phone
            TextFormField(
              controller: _customerPhoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                hintText: '01XXXXXXXXX',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                final phoneRegex = RegExp(r'^01[0-2,5]\d{8}$');
                final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
                if (!phoneRegex.hasMatch(cleanPhone)) {
                  return 'Invalid Egyptian phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Customer email (optional)
            TextFormField(
              controller: _customerEmailController,
              decoration: InputDecoration(
                labelText: 'Email (Optional)',
                hintText: 'customer@example.com',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Invalid email format';
                  }
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Notes (optional)
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Any special requests or notes...',
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
