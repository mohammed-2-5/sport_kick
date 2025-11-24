import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/app_router.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
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

  const CreateBookingPage({
    super.key,
    required this.field,
  });

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTimeSlot = null; // Reset selection
      });
      _loadTimeSlots();
    }
  }

  void _createBooking() {
    if (_selectedTimeSlot == null) {
      ErrorHandler.showWarningSnackbar(
        context,
        'Please select a time slot',
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
              'Booking created successfully!',
            );
            // Navigate to My Bookings to show the new booking
            Navigator.of(context).pushReplacementNamed(
              AppRouter.myBookings,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: AppGradients.primary,
                ),
              ),
              title: const Text(
                'Book Field',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: Column(
              children: [
                // Field Info Header
                _buildFieldHeader(),

                const Divider(height: 1),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Selection
                        _buildDateSection(),

                        const SizedBox(height: 24),

                        // Time Slots
                        if (state is BookingLoading)
                          _buildLoadingTimeSlots()
                        else if (state is TimeSlotsLoaded)
                          _buildTimeSlots(state)
                        else if (state is BookingsEmpty)
                          _buildEmptyState(state.message ?? 'No available slots')
                        else if (state is BookingInitial)
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),

                // Booking Summary & Confirm Button
                if (_selectedTimeSlot != null) _buildBookingSummary(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Field Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.field.images.isNotEmpty
                ? Image.network(
                    widget.field.images.first,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.border,
                      child: const Icon(Icons.sports_soccer),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: AppColors.border,
                    child: const Icon(Icons.sports_soccer),
                  ),
          ),

          const SizedBox(width: 12),

          // Field Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.field.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.field.city} • ${widget.field.formattedPrice}/hour',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          6,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ShimmerLoading(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots(TimeSlotsLoaded state) {
    if (!state.hasAvailableSlots) {
      return _buildEmptyState('No available time slots for this date');
    }

    final slotsByPeriod = state.slotsByPeriod;
    int animationIndex = 0;

    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Time Slots',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Morning Slots
          if (slotsByPeriod['Morning']?.isNotEmpty ?? false) ...[
            _buildPeriodHeader('Morning', Icons.wb_sunny_outlined),
            const SizedBox(height: 8),
            ...slotsByPeriod['Morning']!.map((slot) {
              final index = animationIndex++;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: _buildTimeSlotCard(slot),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          // Afternoon Slots
          if (slotsByPeriod['Afternoon']?.isNotEmpty ?? false) ...[
            _buildPeriodHeader('Afternoon', Icons.wb_sunny),
            const SizedBox(height: 8),
            ...slotsByPeriod['Afternoon']!.map((slot) {
              final index = animationIndex++;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: _buildTimeSlotCard(slot),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          // Evening Slots
          if (slotsByPeriod['Evening']?.isNotEmpty ?? false) ...[
            _buildPeriodHeader('Evening', Icons.nightlight_outlined),
            const SizedBox(height: 8),
            ...slotsByPeriod['Evening']!.map((slot) {
              final index = animationIndex++;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: _buildTimeSlotCard(slot),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodHeader(String period, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          period,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotCard(TimeSlotEntity slot) {
    final isSelected = _selectedTimeSlot == slot;
    final isAvailable = slot.isAvailable;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: isAvailable
            ? () {
                setState(() {
                  _selectedTimeSlot = slot;
                });
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : !isAvailable
                    ? AppColors.textSecondary.withOpacity(0.05)
                    : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : !isAvailable
                      ? AppColors.textSecondary.withOpacity(0.2)
                      : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot.formattedTimeRange,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isAvailable
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slot.period,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Price or Status
              if (!isAvailable)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.block,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Booked',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  slot.formattedPrice,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),

              // Selected Indicator
              if (isSelected) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.calendar_today),
              label: const Text('Choose Another Date'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Summary Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      'Date',
                      DateFormat('MMM d, yyyy').format(_selectedDate),
                    ),
                    const Divider(height: 16),
                    _buildSummaryRow(
                      'Time',
                      _selectedTimeSlot!.formattedTimeRange,
                    ),
                    const Divider(height: 16),
                    _buildSummaryRow(
                      'Total',
                      _selectedTimeSlot!.formattedPrice,
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Confirm Button
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  final isLoading = state is BookingLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _createBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Confirm Booking',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.w700,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
