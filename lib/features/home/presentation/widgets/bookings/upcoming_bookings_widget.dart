import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';

class UpcomingBookingsWidget extends StatelessWidget {
  const UpcomingBookingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Match',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return _buildLoadingState();
              } else if (state is BookingsLoaded) {
                // Filter for future bookings and sort
                final now = DateTime.now();
                final futureBookings =
                    state.bookings
                        .where(
                          (b) => b.date.isAfter(
                            now.subtract(const Duration(hours: 2)),
                          ),
                        ) // Include current games
                        .toList()
                      ..sort((a, b) => a.date.compareTo(b.date));

                if (futureBookings.isEmpty) {
                  return _buildEmptyState();
                }

                final nextBooking = futureBookings.first;
                return _buildBookingCard(context, nextBooking);
              } else if (state is BookingsEmpty) {
                return _buildEmptyState();
              } else if (state is BookingError) {
                return _buildErrorState(state.message);
              }
              return _buildEmptyState(); // Default/Initial
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingEntity booking) {
    final dateStr = DateFormat('EEEE, MMM d').format(booking.date);
    final timeStr = '${booking.startTime} - ${booking.endTime}';

    return GestureDetector(
      onTap: () => context.pushNamed(
        'bookingDetails',
        pathParameters: {'bookingId': booking.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.lightAccent.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightAccent.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.sports_soccer,
                    color: AppColors.lightAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.fieldName ?? 'Football Field',
                        style: const TextStyle(
                          color: AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$dateStr • $timeStr',
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    booking.status.name.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAction(
                  context,
                  Icons.directions,
                  'Directions',
                  () => _openDirections(context, booking),
                ),
                _buildAction(
                  context,
                  Icons.share,
                  'Invite',
                  () => _shareBooking(context, booking),
                ),
                _buildAction(
                  context,
                  Icons.calendar_today,
                  'Add to Calendar',
                  () => _addToCalendar(context, booking),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDirections(BuildContext context, BookingEntity booking) async {
    // Try to open maps with the field location
    final fieldName = booking.fieldName ?? 'Football Field';
    final query = Uri.encodeComponent(fieldName);
    final mapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    if (await canLaunchUrl(mapsUrl)) {
      await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Could not open maps');
      }
    }
  }

  void _shareBooking(BuildContext context, BookingEntity booking) {
    final dateStr = DateFormat('EEEE, MMM d, yyyy').format(booking.date);
    final message =
        '''
🏟️ Join me for football!

📍 ${booking.fieldName ?? 'Football Field'}
📅 $dateStr
⏰ ${booking.startTime} - ${booking.endTime}

Book your spot on Sport Kick! 🎯
''';
    SharePlus.instance.share(ShareParams(text: message));
  }

  void _addToCalendar(BuildContext context, BookingEntity booking) async {
    try {
      // Parse start and end times
      final startTimeParts = booking.startTime.split(':');
      final endTimeParts = booking.endTime.split(':');

      final startHour = int.parse(startTimeParts[0]);
      final startMinute = int.parse(startTimeParts[1].split(':')[0]);
      final endHour = int.parse(endTimeParts[0]);
      final endMinute = int.parse(endTimeParts[1].split(':')[0]);

      final startDateTime = DateTime(
        booking.date.year,
        booking.date.month,
        booking.date.day,
        startHour,
        startMinute,
      );
      final endDateTime = DateTime(
        booking.date.year,
        booking.date.month,
        booking.date.day,
        endHour,
        endMinute,
      );

      // Check if running on web - use Google Calendar URL instead
      if (kIsWeb) {
        // Format for Google Calendar: YYYYMMDDTHHmmss
        final startFormatted =
            '${startDateTime.year}${startDateTime.month.toString().padLeft(2, '0')}${startDateTime.day.toString().padLeft(2, '0')}T${startDateTime.hour.toString().padLeft(2, '0')}${startDateTime.minute.toString().padLeft(2, '0')}00';
        final endFormatted =
            '${endDateTime.year}${endDateTime.month.toString().padLeft(2, '0')}${endDateTime.day.toString().padLeft(2, '0')}T${endDateTime.hour.toString().padLeft(2, '0')}${endDateTime.minute.toString().padLeft(2, '0')}00';

        final title = Uri.encodeComponent(
          'Football at ${booking.fieldName ?? "Field"}',
        );
        final details = Uri.encodeComponent('Booked via Sport Kick');
        final location = Uri.encodeComponent(
          booking.fieldName ?? 'Football Field',
        );

        final calendarUrl = Uri.parse(
          'https://calendar.google.com/calendar/render?action=TEMPLATE&text=$title&dates=$startFormatted/$endFormatted&details=$details&location=$location',
        );

        if (await canLaunchUrl(calendarUrl)) {
          await launchUrl(calendarUrl, mode: LaunchMode.externalApplication);
        }
        return;
      }

      // Native calendar for mobile
      final event = Event(
        title: 'Football at ${booking.fieldName ?? "Field"}',
        description: 'Booked via Sport Kick',
        location: booking.fieldName ?? 'Football Field',
        startDate: startDateTime,
        endDate: endDateTime,
      );

      Add2Calendar.addEvent2Cal(event);
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Could not add to calendar');
      }
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: AppColors.lightTextSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No upcoming matches',
              style: TextStyle(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Book your next game now!',
              style: TextStyle(
                color: AppColors.lightTextSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.lightAccent),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Error loading bookings: $message',
        style: const TextStyle(color: AppColors.error),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
