import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/booking_action_buttons.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/booking_card_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/booking_info_chip.dart';

class OwnerBookingCard extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, booking.status.color.withValues(alpha: 0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: booking.status.color.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: booking.status.color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          BookingCardHeader(booking: booking),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Customer Info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customer',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            booking.userName ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Date & Time
                Row(
                  children: [
                    Expanded(
                      child: BookingInfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: 'Date',
                        value: booking.formattedDate,
                        color: const Color(0xFF42A5F5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BookingInfoChip(
                        icon: Icons.access_time_rounded,
                        label: 'Time',
                        value: booking.formattedTimeSlot,
                        color: const Color(0xFF66BB6A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Duration & Price
                Row(
                  children: [
                    Expanded(
                      child: BookingInfoChip(
                        icon: Icons.timer_rounded,
                        label: 'Duration',
                        value: '${booking.durationInHours}h',
                        color: const Color(0xFFAB47BC),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BookingInfoChip(
                        icon: Icons.attach_money_rounded,
                        label: 'Price',
                        value: '\$${booking.totalPrice}',
                        color: const Color(0xFFFFA726),
                      ),
                    ),
                  ],
                ),

                // Action Buttons for Pending Bookings
                if (booking.status == BookingStatus.pending) ...[
                  const SizedBox(height: 20),
                  BookingActionButtons(booking: booking),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
