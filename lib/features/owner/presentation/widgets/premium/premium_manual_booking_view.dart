import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/l10n/app_localizations.dart';
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
      SnackbarHelper.showError(
        context,
        context.l10n.selectField,
      ); // "Please select a field" -> "Select Field" (using closest key or add specific error key if strict)
      // Actually checking keys: no specific error key added for "Please select a field".
      // I'll stick to 'Select Field' key as error for now or generic "Invalid Input".
      // Wait, "Please select a field" is not in keys. I added "selectField": "Select Field".
      // Using "Field is required" would be better but I don't have it.
      // I'll use text for now to be safe or reuse 'fieldLabel' + 'required'?
      // I'll use hardcoded for error to be safe or add key.
      // Actually, I should use context.l10n.fieldRequired if valid, otherwise keep English for errors? No, localization task.
      // I will use context.l10n.fieldRequired (it exists in app_en.arb).
      SnackbarHelper.showError(context, context.l10n.fieldRequired);
      return false;
    }
    if (_selectedDate == null) {
      // "Please select a date"
      SnackbarHelper.showError(
        context,
        context.l10n.chooseDate,
      ); // "Choose a date" exists? Yes.
      return false;
    }
    if (_selectedTimeSlotId == null) {
      // "Please select a time slot"
      SnackbarHelper.showError(
        context,
        context.l10n.selectTime,
      ); // "Select time" exists? Yes.
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
    final l10n = context.l10n;
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingError) {
          SnackbarHelper.showError(context, state.message);
        } else if (state is BookingCreated) {
          SnackbarHelper.showSuccess(
            context,
            l10n.bookingCreated,
          ); // "Booking created successfully" exists as bookingCreated
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Column(
          children: [
            // Header
            PremiumCurvedHeader(
              title: l10n.createBookingTitle,
              subtitle: l10n.createBookingSubtitle,
              showBackButton: true,
            ),

            // Step Indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: PremiumStepIndicator(
                currentStep: _currentStep,
                totalSteps: 3,
                stepLabels: [
                  l10n.bookingStepDetails,
                  l10n.bookingStepCustomer,
                  l10n.bookingStepConfirm,
                ],
              ),
            ),

            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStepOne(l10n),
                  _buildStepTwo(l10n),
                  _buildStepThree(l10n),
                ],
              ),
            ),

            // Action Buttons
            _buildActionButtons(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildStepOne(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Field Selection
          PremiumFormSection(
            title: l10n.selectField,
            icon: Icons.sports_soccer,
            children: [
              BlocBuilder<FieldsCubit, FieldsState>(
                builder: (context, state) {
                  List<FieldEntity> fields = [];
                  if (state is FieldsLoaded) {
                    fields = state.fields;
                  }

                  if (fields.isEmpty) {
                    return Center(child: Text(l10n.noFieldsAvailable));
                  }

                  return PremiumDropdownField<FieldEntity>(
                    label: l10n.fieldLabel,
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
            title: l10n.selectDate,
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
            title: l10n.selectTime,
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
            title: l10n.priceLabel,
            icon: Icons.attach_money,
            children: [
              PremiumFormField(
                label: l10n.totalPriceLabel,
                hintText: l10n.enterPriceHint,
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

  Widget _buildStepTwo(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PremiumFormSection(
              title: l10n.customerInfoTitle,
              icon: Icons.person,
              children: [
                PremiumFormField(
                  label: l10n.customerNameLabel,
                  hintText: l10n.enterCustomerNameHint,
                  controller: _customerNameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.customerNameRequired;
                    }
                    return null;
                  },
                ),
                PremiumFormField(
                  label: l10n.phoneLabel,
                  hintText: l10n.enterPhoneHint,
                  controller: _customerPhoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.phoneRequired;
                    }
                    return null;
                  },
                ),
                PremiumFormField(
                  label: l10n.emailOptionalLabel,
                  hintText: l10n.enterEmailHint,
                  controller: _customerEmailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                PremiumFormField(
                  label: l10n.notesOptionalLabel,
                  hintText: l10n.addNotesHint,
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

  Widget _buildStepThree(AppLocalizations l10n) {
    final selectedSlot = _selectedTimeSlotId != null
        ? _timeSlots.firstWhere((s) => s.id == _selectedTimeSlotId)
        : null;

    final localeName = l10n.localeName;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PremiumBookingSummary(
            fieldName: _selectedField?.name ?? l10n.notSelected,
            date: _selectedDate != null
                ? DateFormat.yMMMMEEEEd(localeName).format(_selectedDate!)
                : l10n.notSelected,
            timeSlot: selectedSlot?.displayTime ?? l10n.notSelected,
            customerName: _customerNameController.text.isEmpty
                ? l10n.notEntered
                : _customerNameController.text,
            customerPhone: _customerPhoneController.text.isEmpty
                ? null
                : _customerPhoneController.text,
            price:
                '${_priceController.text.isEmpty ? '0' : _priceController.text} EGP',
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
                Expanded(
                  child: Text(
                    l10n.bookingConfirmationMessage,
                    style: AppTextStyles.bodySmall.copyWith(
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

  Widget _buildActionButtons(AppLocalizations l10n) {
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
                    label: l10n.back,
                    onPressed: isLoading ? null : _handleBack,
                    style: PremiumButtonStyle.outline,
                    icon: Icons.arrow_back,
                  ),
                ),
              if (_currentStep > 1) const SizedBox(width: 16),
              Expanded(
                child: PremiumButton(
                  label: _currentStep == 3 ? l10n.createBooking : l10n.next,
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
    final localeName = context.l10n.localeName;

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
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
            localeName: localeName,
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
  final String localeName;
  final VoidCallback onTap;

  const _DateCard({
    required this.date,
    required this.isSelected,
    required this.localeName,
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
              DateFormat.E(localeName).format(date),
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat.MMM(localeName).format(date),
              style: AppTextStyles.labelSmall.copyWith(
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
