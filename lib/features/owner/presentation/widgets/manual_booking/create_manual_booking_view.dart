import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/manual_booking_form_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/manual_booking_form_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/booking_step_one_widget.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/booking_step_two_widget.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/step_indicator_widget.dart';

/// Create Manual Booking View - 2-step flow form for creating manual bookings.
///
/// Uses [ManualBookingFormCubit] for form state management and step navigation.
class CreateManualBookingView extends StatefulWidget {
  const CreateManualBookingView({super.key});

  @override
  State<CreateManualBookingView> createState() =>
      _CreateManualBookingViewState();
}

class _CreateManualBookingViewState extends State<CreateManualBookingView> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  // Controllers for step 2
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleSubmit(ManualBookingFormData data) {
    if (!_formKey.currentState!.validate()) return;

    context.read<BookingCubit>().createManualBooking(
      fieldId: data.selectedField!.id,
      date: data.selectedDate!,
      startTime: data.selectedStartTime!,
      endTime: data.selectedEndTime!,
      totalPrice: data.totalPrice!,
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
    return BlocProvider(
      create: (_) => ManualBookingFormCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Manual Booking'),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: MultiBlocListener(
          listeners: [
            // Handle form state changes
            BlocListener<ManualBookingFormCubit, ManualBookingFormState>(
              listener: (context, state) {
                if (state is ManualBookingFormStepChanged) {
                  _animateToPage(state.targetStep);
                } else if (state is ManualBookingFormValidationError) {
                  SnackbarHelper.showError(context, state.message);
                } else if (state is ManualBookingFormReadyToSubmit) {
                  _handleSubmit(state.data);
                }
              },
            ),
            // Handle booking state changes
            BlocListener<BookingCubit, BookingState>(
              listener: (context, state) {
                if (state is BookingError) {
                  SnackbarHelper.showError(context, state.message);
                } else if (state is BookingCreated) {
                  SnackbarHelper.showSuccess(
                    context,
                    'Manual booking created successfully for ${_customerNameController.text}',
                  );
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
          child: BlocBuilder<BookingCubit, BookingState>(
            builder: (context, bookingState) {
              final isLoading = bookingState is BookingLoading;

              return BlocBuilder<
                ManualBookingFormCubit,
                ManualBookingFormState
              >(
                builder: (context, formState) {
                  final data = _extractFormData(formState);
                  final currentStep = data.currentStep;

                  return Column(
                    children: [
                      // Step indicator
                      StepIndicatorWidget(currentStep: currentStep),

                      // Page content
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildStepOne(context, data),
                            _buildStepTwo(data),
                          ],
                        ),
                      ),

                      // Bottom action buttons
                      _buildActionButtons(context, currentStep, isLoading),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  ManualBookingFormData _extractFormData(ManualBookingFormState state) {
    if (state is ManualBookingFormInitial) return state.data;
    if (state is ManualBookingFormStepChanged) return state.data;
    if (state is ManualBookingFormValidationError) return state.data;
    if (state is ManualBookingFormReadyToSubmit) return state.data;
    return const ManualBookingFormData();
  }

  Widget _buildStepOne(BuildContext context, ManualBookingFormData data) {
    final formCubit = context.read<ManualBookingFormCubit>();
    final bookingCubit = context.read<BookingCubit>();

    return BookingStepOneWidget(
      selectedField: data.selectedField,
      selectedDate: data.selectedDate,
      selectedStartTime: data.selectedStartTime,
      selectedEndTime: data.selectedEndTime,
      totalPrice: data.totalPrice,
      onFieldChanged: (field) {
        formCubit.setField(field);
        if (field != null && data.selectedDate != null) {
          bookingCubit.loadAvailableTimeSlots(
            fieldId: field.id,
            date: data.selectedDate!,
          );
        }
      },
      onDateChanged: (date) {
        formCubit.setDate(date);
        if (data.selectedField != null && date != null) {
          bookingCubit.loadAvailableTimeSlots(
            fieldId: data.selectedField!.id,
            date: date,
          );
        }
      },
      onStartTimeChanged: formCubit.setStartTime,
      onEndTimeChanged: formCubit.setEndTime,
      onPriceChanged: formCubit.setPrice,
    );
  }

  Widget _buildStepTwo(ManualBookingFormData data) {
    return BookingStepTwoWidget(
      formKey: _formKey,
      nameController: _customerNameController,
      phoneController: _customerPhoneController,
      emailController: _customerEmailController,
      notesController: _notesController,
      selectedField: data.selectedField,
      selectedDate: data.selectedDate,
      selectedStartTime: data.selectedStartTime,
      selectedEndTime: data.selectedEndTime,
      totalPrice: data.totalPrice,
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    int currentStep,
    bool isLoading,
  ) {
    final formCubit = context.read<ManualBookingFormCubit>();

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
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : formCubit.previousStep,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : (currentStep == 0
                        ? formCubit.nextStep
                        : formCubit.prepareSubmission),
              icon: Icon(currentStep == 0 ? Icons.arrow_forward : Icons.check),
              label: Text(currentStep == 0 ? 'Next' : 'Create Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
