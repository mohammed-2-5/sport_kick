import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/owner/presentation/utils/manual_booking_validator.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/booking_step_one_widget.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/booking_step_two_widget.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/step_indicator_widget.dart';

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
      final error = ManualBookingValidator.validateStepOne(
        field: _selectedField,
        date: _selectedDate,
        startTime: _selectedStartTime,
        endTime: _selectedEndTime,
        price: _totalPrice,
      );

      if (error != null) {
        _showError(error);
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
        backgroundColor: AppColors.error,
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
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is BookingCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Manual booking created successfully for ${_customerNameController.text}',
                ),
                backgroundColor: AppColors.success,
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
              StepIndicatorWidget(currentStep: _currentStep),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    BookingStepOneWidget(
                      selectedField: _selectedField,
                      selectedDate: _selectedDate,
                      selectedStartTime: _selectedStartTime,
                      selectedEndTime: _selectedEndTime,
                      totalPrice: _totalPrice,
                      onFieldChanged: (field) {
                        setState(() {
                          _selectedField = field;
                          _selectedStartTime = null;
                          _selectedEndTime = null;
                        });
                        if (field != null && _selectedDate != null) {
                          context.read<BookingCubit>().loadAvailableTimeSlots(
                            fieldId: field.id,
                            date: _selectedDate!,
                          );
                        }
                      },
                      onDateChanged: (date) {
                        setState(() {
                          _selectedDate = date;
                          _selectedStartTime = null;
                          _selectedEndTime = null;
                        });
                        if (_selectedField != null && date != null) {
                          context.read<BookingCubit>().loadAvailableTimeSlots(
                            fieldId: _selectedField!.id,
                            date: date,
                          );
                        }
                      },
                      onStartTimeChanged: (time) {
                        setState(() {
                          _selectedStartTime = time;
                          if (time != null) {
                            final hour = int.parse(time.split(':')[0]);
                            if (hour < 23) {
                              _selectedEndTime =
                                  '${(hour + 1).toString().padLeft(2, '0')}:00';
                            }
                          }
                        });
                      },
                      onEndTimeChanged: (time) {
                        setState(() => _selectedEndTime = time);
                      },
                      onPriceChanged: (price) {
                        setState(() => _totalPrice = price);
                      },
                    ),
                    BookingStepTwoWidget(
                      formKey: _formKey,
                      nameController: _customerNameController,
                      phoneController: _customerPhoneController,
                      emailController: _customerEmailController,
                      notesController: _notesController,
                      selectedField: _selectedField,
                      selectedDate: _selectedDate,
                      selectedStartTime: _selectedStartTime,
                      selectedEndTime: _selectedEndTime,
                      totalPrice: _totalPrice,
                    ),
                  ],
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
}
