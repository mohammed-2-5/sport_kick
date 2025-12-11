import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_booking_summary.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_dropdown_field.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_form_field.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_form_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_step_indicator.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_time_slot_grid.dart';

/// Premium manual booking view with enhanced UI.
///
/// Features:
/// - Premium curved header
/// - Step indicator for multi-step form
/// - Field and date selection
/// - Time slot grid
/// - Customer information form
/// - Booking summary
class PremiumManualBookingView extends StatefulWidget {
  const PremiumManualBookingView({super.key});

  @override
  State<PremiumManualBookingView> createState() =>
      _PremiumManualBookingViewState();
}

class _PremiumManualBookingViewState extends State<PremiumManualBookingView> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _notesController = TextEditingController();
  final _priceController = TextEditingController();

  // Form state
  int _currentStep = 1;
  FieldEntity? _selectedField;
  DateTime? _selectedDate;
  String? _selectedTimeSlotId;
  String? _selectedStartTime;
  String? _selectedEndTime;

  // Sample time slots (would come from API based on field and date)
  final List<TimeSlot> _timeSlots = [
    const TimeSlot(
      id: '1',
      startTime: '08:00',
      endTime: '09:00',
      isAvailable: true,
    ),
    const TimeSlot(
      id: '2',
      startTime: '09:00',
      endTime: '10:00',
      isAvailable: true,
    ),
    const TimeSlot(
      id: '3',
      startTime: '10:00',
      endTime: '11:00',
      isAvailable: false,
    ),
    const TimeSlot(
      id: '4',
      startTime: '11:00',
      endTime: '12:00',
      isAvailable: true,
    ),
    const TimeSlot(
      id: '5',
      startTime: '12:00',
      endTime: '13:00',
      isAvailable: true,
    ),
    const TimeSlot(
      id: '6',
      startTime: '13:00',
      endTime: '14:00',
      isAvailable: false,
    ),
    const TimeSlot(
      id: '7',
      startTime: '14:00',
      endTime: '15:00',
      isAvailable: true,
    ),
    const TimeSlot(
      id: '8',
      startTime: '15:00',
      endTime: '16:00',
      isAvailable: true,
    ),
    const TimeSlot(
      id: '9',
      startTime: '16:00',
      endTime: '17:00',
      isAvailable: true,
    ),
    const TimeSlot(
      id: '10',
      startTime: '17:00',
      endTime: '18:00',
      isAvailable: false,
    ),
    const TimeSlot(
      id: '11',
      startTime: '18:00',
      endTime: '19:00',
      isAvailable: true,
    ),
    const TimeSlot(
      id: '12',
      startTime: '19:00',
      endTime: '20:00',
      isAvailable: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _notesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateStepOne() {
    if (_selectedField == null) {
      SnackbarHelper.showError(context, 'Please select a field');
      return false;
    }
    if (_selectedDate == null) {
      SnackbarHelper.showError(context, 'Please select a date');
      return false;
    }
    if (_selectedTimeSlotId == null) {
      SnackbarHelper.showError(context, 'Please select a time slot');
      return false;
    }
    return true;
  }

  bool _validateStepTwo() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  void _handleNext() {
    HapticFeedback.lightImpact();
    if (_currentStep == 1 && _validateStepOne()) {
      _goToStep(2);
    } else if (_currentStep == 2 && _validateStepTwo()) {
      _goToStep(3);
    }
  }

  void _handleBack() {
    HapticFeedback.lightImpact();
    if (_currentStep > 1) {
      _goToStep(_currentStep - 1);
    }
  }

  void _handleSubmit() {
    HapticFeedback.mediumImpact();
    if (_selectedField == null || _selectedDate == null) return;

    context.read<BookingCubit>().createManualBooking(
      fieldId: _selectedField!.id,
      date: _selectedDate!,
      startTime: _selectedStartTime!,
      endTime: _selectedEndTime!,
      totalPrice:
          double.tryParse(_priceController.text) ??
          _selectedField!.pricePerHour,
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingError) {
          SnackbarHelper.showError(context, state.message);
        } else if (state is BookingCreated) {
          SnackbarHelper.showSuccess(context, 'Booking created successfully!');
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Column(
          children: [
            // Header
            const PremiumCurvedHeader(
              title: 'Create Booking',
              subtitle: 'Add a manual booking',
              showBackButton: true,
            ),

            // Step Indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: PremiumStepIndicator(
                currentStep: _currentStep,
                totalSteps: 3,
                stepLabels: const ['Details', 'Customer', 'Confirm'],
              ),
            ),

            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildStepOne(), _buildStepTwo(), _buildStepThree()],
              ),
            ),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepOne() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Field Selection
          PremiumFormSection(
            title: 'Select Field',
            icon: Icons.sports_soccer,
            children: [
              BlocBuilder<FieldsCubit, FieldsState>(
                builder: (context, state) {
                  List<FieldEntity> fields = [];
                  if (state is FieldsLoaded) {
                    fields = state.fields;
                  }

                  if (fields.isEmpty) {
                    return const Center(child: Text('No fields available'));
                  }

                  return PremiumDropdownField<FieldEntity>(
                    label: 'Field',
                    value: _selectedField ?? fields.first,
                    items: fields,
                    itemLabel: (field) => field.name,
                    onChanged: (field) {
                      setState(() {
                        _selectedField = field;
                        _priceController.text =
                            field?.pricePerHour.toStringAsFixed(0) ?? '';
                      });
                    },
                    prefixIcon: Icons.stadium,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Date Selection
          PremiumFormSection(
            title: 'Select Date',
            icon: Icons.calendar_today,
            children: [
              _DateSelector(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Time Slot Selection
          PremiumFormSection(
            title: 'Select Time',
            icon: Icons.access_time,
            children: [
              PremiumTimeSlotGrid(
                timeSlots: _timeSlots,
                selectedSlotId: _selectedTimeSlotId,
                onSlotSelected: (slotId) {
                  final slot = _timeSlots.firstWhere((s) => s.id == slotId);
                  setState(() {
                    _selectedTimeSlotId = slotId;
                    _selectedStartTime = slot.startTime;
                    _selectedEndTime = slot.endTime;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price
          PremiumFormSection(
            title: 'Price',
            icon: Icons.attach_money,
            children: [
              PremiumFormField(
                label: 'Total Price',
                hintText: 'Enter price',
                controller: _priceController,
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepTwo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PremiumFormSection(
              title: 'Customer Information',
              icon: Icons.person,
              children: [
                PremiumFormField(
                  label: 'Customer Name',
                  hintText: 'Enter customer name',
                  controller: _customerNameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Customer name is required';
                    }
                    return null;
                  },
                ),
                PremiumFormField(
                  label: 'Phone Number',
                  hintText: 'Enter phone number',
                  controller: _customerPhoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),
                PremiumFormField(
                  label: 'Email (Optional)',
                  hintText: 'Enter email address',
                  controller: _customerEmailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                PremiumFormField(
                  label: 'Notes (Optional)',
                  hintText: 'Add any special notes',
                  controller: _notesController,
                  prefixIcon: Icons.notes,
                  maxLines: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepThree() {
    final selectedSlot = _selectedTimeSlotId != null
        ? _timeSlots.firstWhere((s) => s.id == _selectedTimeSlotId)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PremiumBookingSummary(
            fieldName: _selectedField?.name ?? 'Not selected',
            date: _selectedDate != null
                ? DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate!)
                : 'Not selected',
            timeSlot: selectedSlot?.displayTime ?? 'Not selected',
            customerName: _customerNameController.text.isEmpty
                ? 'Not entered'
                : _customerNameController.text,
            customerPhone: _customerPhoneController.text.isEmpty
                ? null
                : _customerPhoneController.text,
            price:
                '\$${_priceController.text.isEmpty ? '0' : _priceController.text}',
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          ),

          const SizedBox(height: 24),

          // Confirmation message
          PremiumCard(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.info_outline, color: Colors.green),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Please review the booking details before confirming. This action cannot be undone.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final isLoading = state is BookingLoading;

        return Container(
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
              if (_currentStep > 1)
                Expanded(
                  child: PremiumButton(
                    label: 'Back',
                    onPressed: isLoading ? null : _handleBack,
                    style: PremiumButtonStyle.outline,
                    icon: Icons.arrow_back,
                  ),
                ),
              if (_currentStep > 1) const SizedBox(width: 16),
              Expanded(
                child: PremiumButton(
                  label: _currentStep == 3 ? 'Create Booking' : 'Next',
                  onPressed: isLoading
                      ? null
                      : (_currentStep == 3 ? _handleSubmit : _handleNext),
                  loading: isLoading,
                  icon: _currentStep == 3 ? Icons.check : Icons.arrow_forward,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Date selector widget.
class _DateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _DateSelector({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dates = List.generate(14, (index) => now.add(Duration(days: index)));

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected =
              selectedDate != null &&
              date.day == selectedDate!.day &&
              date.month == selectedDate!.month &&
              date.year == selectedDate!.year;

          return _DateCard(
            date: date,
            isSelected: isSelected,
            onTap: () {
              HapticFeedback.selectionClick();
              onDateSelected(date);
            },
          );
        },
      ),
    );
  }
}

/// Individual date card.
class _DateCard extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateCard({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('MMM').format(date),
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
