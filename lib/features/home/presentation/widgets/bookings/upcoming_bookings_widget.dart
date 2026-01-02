import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

class UpcomingBookingsWidget extends StatelessWidget {
  const UpcomingBookingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.homeUpcomingMatch,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return _buildLoadingState(context);
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
                  return _buildEmptyState(context, context.l10n);
                }

                final nextBooking = futureBookings.first;
                return _buildBookingCard(context, nextBooking);
              } else if (state is BookingsEmpty) {
                return _buildEmptyState(context, context.l10n);
              } else if (state is BookingError) {
                return _buildErrorState(context, state.message);
              }
              return _buildEmptyState(context, context.l10n); // Default/Initial
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingEntity booking) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

    final dateStr = LocaleFormatters.formatDate(
      context,
      booking.date,
      pattern: 'EEEE, MMM d',
    );
    final timeStr = LocaleFormatters.formatTimeRange(
      context,
      startTime: booking.startTime,
      endTime: booking.endTime,
    );

    return GestureDetector(
      onTap: () => context.pushNamed(
        'bookingDetails',
        pathParameters: {'bookingId': booking.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1),
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
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.sports_soccer,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.fieldName ??
                            context.l10n.footballField, // fallback
                        style: AppTextStyles.titleMedium.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$dateStr • $timeStr',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
                    color: successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: successColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    booking.status.name.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: successColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAction(
                  context,
                  Icons.directions,
                  context.l10n.homeDirections,
                  () => _openDirections(context, booking),
                ),
                _buildAction(
                  context,
                  Icons.share,
                  context.l10n.homeInvite,
                  () => _shareBooking(context, booking),
                ),
                _buildAction(
                  context,
                  Icons.calendar_today,
                  context.l10n.homeAddToCalendar,
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
    final fieldName = booking.fieldName ?? context.l10n.footballField;
    final query = Uri.encodeComponent(fieldName);
    final mapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    try {
      if (await canLaunchUrl(mapsUrl)) {
        await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          SnackbarHelper.showError(context, context.l10n.homeErrorOpenMaps);
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, context.l10n.homeErrorOpenMaps);
      }
    }
  }

  void _shareBooking(BuildContext context, BookingEntity booking) {
    final dateStr = LocaleFormatters.formatDate(
      context,
      booking.date,
      pattern: 'EEEE, MMM d, yyyy',
    );
    final message =
        '''
${context.l10n.homeBookingShareTitle(booking.fieldName ?? context.l10n.footballField)}

${context.l10n.bookingDate}: $dateStr
${context.l10n.selectTime}: ${LocaleFormatters.formatTimeRange(context, startTime: booking.startTime, endTime: booking.endTime)}

${context.l10n.homeBookingShareDescription}
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
          context.l10n.homeCalendarTitle(
            booking.fieldName ?? context.l10n.footballField,
          ),
        );
        final details = Uri.encodeComponent(context.l10n.homeCalendarDetails);
        final location = Uri.encodeComponent(
          booking.fieldName ?? context.l10n.footballField,
        );

        final calendarUrl = Uri.parse(
          'https://calendar.google.com/calendar/render?action=TEMPLATE&text=$title&dates=$startFormatted/$endFormatted&details=$details&location=$location',
        );

        if (await canLaunchUrl(calendarUrl)) {
          await launchUrl(calendarUrl, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            SnackbarHelper.showError(
              context,
              context.l10n.homeErrorAddCalendar,
            );
          }
        }
        return;
      }

      // Native calendar for mobile
      final event = Event(
        title: context.l10n.homeCalendarTitle(
          booking.fieldName ?? context.l10n.footballField,
        ),
        description: context.l10n.homeCalendarDetails,
        location: booking.fieldName ?? context.l10n.footballField,
        startDate: startDateTime,
        endDate: endDateTime,
      );

      final success = await Add2Calendar.addEvent2Cal(event);
      if (!success && context.mounted) {
        SnackbarHelper.showError(context, context.l10n.homeErrorAddCalendar);
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, context.l10n.homeErrorAddCalendar);
      }
    }
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.homeNoUpcomingMatches,
              style: AppTextStyles.titleMedium.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.homeBookNextGame,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${context.l10n.homeErrorLoadingBookings}: $message',
        style: AppTextStyles.bodyMedium.copyWith(color: errorColor),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
