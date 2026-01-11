import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';

import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/constants/owner_booking_constants.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/manual_booking_action_buttons.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/manual_booking_step_one.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/manual_booking_step_three.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/manual_booking_step_two.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_step_indicator.dart';

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
      SnackbarHelper.showError(context, context.l10n.fieldRequired);
      return false;
    }
    if (_selectedDate == null) {
      SnackbarHelper.showError(context, context.l10n.chooseDate);
      return false;
    }
    if (_selectedTimeSlotId == null) {
      SnackbarHelper.showError(context, context.l10n.selectTime);
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
      loadingMessage: context.l10n.creatingManualBooking,
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
          SnackbarHelper.showSuccess(context, l10n.bookingCreated);
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                  ManualBookingStepOne(
                    l10n: l10n,
                    selectedField: _selectedField,
                    onFieldChanged: (field) =>
                        setState(() => _selectedField = field),
                    selectedDate: _selectedDate,
                    onDateChanged: (date) =>
                        setState(() => _selectedDate = date),
                    timeSlots: OwnerBookingConstants.sampleTimeSlots,
                    selectedTimeSlotId: _selectedTimeSlotId,
                    onTimeSlotSelected: (slotId) {
                      final slot = OwnerBookingConstants.sampleTimeSlots
                          .firstWhere((s) => s.id == slotId);
                      setState(() {
                        _selectedTimeSlotId = slotId;
                        _selectedStartTime = slot.startTime;
                        _selectedEndTime = slot.endTime;
                      });
                    },
                    priceController: _priceController,
                  ),
                  ManualBookingStepTwo(
                    l10n: l10n,
                    formKey: _formKey,
                    nameController: _customerNameController,
                    phoneController: _customerPhoneController,
                    emailController: _customerEmailController,
                    notesController: _notesController,
                  ),
                  ManualBookingStepThree(
                    l10n: l10n,
                    selectedField: _selectedField,
                    selectedDate: _selectedDate,
                    selectedSlot: _selectedTimeSlotId != null
                        ? OwnerBookingConstants.sampleTimeSlots.firstWhere(
                            (s) => s.id == _selectedTimeSlotId,
                          )
                        : null,
                    customerName: _customerNameController.text.trim(),
                    customerPhone: _customerPhoneController.text.trim(),
                    price: _priceController.text,
                    notes: _notesController.text.trim(),
                  ),
                ],
              ),
            ),

            // Action Buttons
            ManualBookingActionButtons(
              l10n: l10n,
              currentStep: _currentStep,
              isLoading:
                  context.watch<BookingCubit>().state
                      is BookingLoading, // Check state or use BlocBuilder wrapping this?
              onBack: _handleBack,
              onNext: _handleNext,
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
