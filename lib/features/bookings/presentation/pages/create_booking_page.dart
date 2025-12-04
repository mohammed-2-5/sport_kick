import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/app_router.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_date_picker.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_empty_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_field_header.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_summary_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_time_slot_selector.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Page for creating a new booking.
///
/// Allows users to:
/// - Select a date
/// - View available time slots
/// - Select a time slot
/// - Confirm booking
class CreateBookingPage extends StatefulWidget {
  final FieldEntity field;

  const CreateBookingPage({super.key, required this.field});

  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  DateTime _selectedDate = DateTime.now();
  TimeSlotEntity? _selectedTimeSlot;
  late final BookingCubit _cubit;

  @override
  void initState() {
    super.initState();
    // Create cubit and load time slots for today
    _cubit = sl<BookingCubit>();
    _cubit.loadAvailableTimeSlots(
      fieldId: widget.field.id,
      date: _selectedDate,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _loadTimeSlots() {
    _cubit.loadAvailableTimeSlots(
      fieldId: widget.field.id,
      date: _selectedDate,
    );
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedTimeSlot = null; // Reset selection
    });
    _loadTimeSlots();
  }

  void _handleTimeSlotSelected(TimeSlotEntity slot) {
    setState(() {
      _selectedTimeSlot = slot;
    });
  }

  void _createBooking() {
    if (_selectedTimeSlot == null) {
      ErrorHandler.showWarningSnackbar(
        context,
        BookingConstants.selectTimeSlotFirstMessage,
      );
      return;
    }

    _cubit.createBooking(
      fieldId: widget.field.id,
      date: _selectedDate,
      startTime: _selectedTimeSlot!.startTime,
      endTime: _selectedTimeSlot!.endTime,
      totalPrice: _selectedTimeSlot!.price,
      notes: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingError) {
            ErrorHandler.showErrorSnackbar(context, state.message);
          } else if (state is BookingCreated) {
            ErrorHandler.showSuccessSnackbar(
              context,
              BookingConstants.bookingConfirmedMessage,
            );
            // Navigate to My Bookings to show the new booking
            Navigator.of(context).pushReplacementNamed(AppRouter.myBookings);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: _buildAppBar(),
            body: Column(
              children: [
                // Field Info Header
                BookingFieldHeader(field: widget.field),

                const Divider(height: 1),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(
                      BookingConstants.standardPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Selection
                        BookingDatePicker(
                          selectedDate: _selectedDate,
                          onDateSelected: _handleDateSelected,
                        ),

                        const SizedBox(height: BookingConstants.sectionSpacing),

                        // Time Slots
                        _buildTimeSlotsSection(state),
                      ],
                    ),
                  ),
                ),

                // Booking Summary & Confirm Button
                if (_selectedTimeSlot != null)
                  BookingSummaryCard(
                    selectedDate: _selectedDate,
                    selectedTimeSlot: _selectedTimeSlot!,
                    onConfirm: _createBooking,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primary),
      ),
      title: const Text(
        'Book Field',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    );
  }

  Widget _buildTimeSlotsSection(BookingState state) {
    if (state is BookingLoading) {
      return BookingTimeSlotSelector(
        slotsByPeriod: const {},
        selectedTimeSlot: _selectedTimeSlot,
        onTimeSlotSelected: _handleTimeSlotSelected,
        isLoading: true,
      );
    } else if (state is TimeSlotsLoaded) {
      if (!state.hasAvailableSlots) {
        return BookingEmptyState(
          message: BookingConstants.noAvailableSlotsMessage,
          onSelectDatePressed: () => _handleDateSelected(_selectedDate),
        );
      }
      return BookingTimeSlotSelector(
        slotsByPeriod: state.slotsByPeriod,
        selectedTimeSlot: _selectedTimeSlot,
        onTimeSlotSelected: _handleTimeSlotSelected,
      );
    } else if (state is BookingsEmpty) {
      return BookingEmptyState(
        message: state.message ?? BookingConstants.noAvailableSlotsMessage,
        onSelectDatePressed: () => _handleDateSelected(_selectedDate),
      );
    }
    return const SizedBox.shrink();
  }
}
