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

/// Widget displaying the user's upcoming booking with quick actions.
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
                return const _LoadingState();
              } else if (state is BookingsLoaded) {
                final futureBookings = _getUpcomingBookings(state.bookings);

                if (futureBookings.isEmpty) {
                  return _EmptyState(l10n: context.l10n);
                }

                return _BookingCard(booking: futureBookings.first);
              } else if (state is BookingsEmpty) {
                return _EmptyState(l10n: context.l10n);
              } else if (state is BookingError) {
                return _ErrorState(message: state.message);
              }
              return _EmptyState(l10n: context.l10n);
            },
          ),
        ],
      ),
    );
  }

  List<BookingEntity> _getUpcomingBookings(List<BookingEntity> bookings) {
    final now = DateTime.now();
    return bookings
        .where((b) => b.date.isAfter(now.subtract(const Duration(hours: 2))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}

/// Booking card showing upcoming booking details.
class _BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
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
            _BookingHeader(
              booking: booking,
              dateStr: dateStr,
              timeStr: timeStr,
              successColor: successColor,
            ),
            const SizedBox(height: 20),
            Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            _BookingActions(booking: booking),
          ],
        ),
      ),
    );
  }
}

/// Header section showing field info and status.
class _BookingHeader extends StatelessWidget {
  final BookingEntity booking;
  final String dateStr;
  final String timeStr;
  final Color successColor;

  const _BookingHeader({
    required this.booking,
    required this.dateStr,
    required this.timeStr,
    required this.successColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
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
                booking.fieldName ?? context.l10n.footballField,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: successColor.withValues(alpha: 0.3)),
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
    );
  }
}

/// Action buttons for directions, share, and calendar.
class _BookingActions extends StatelessWidget {
  final BookingEntity booking;

  const _BookingActions({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionButton(
          icon: Icons.directions,
          label: context.l10n.homeDirections,
          onTap: () => BookingActions.openDirections(context, booking),
        ),
        _ActionButton(
          icon: Icons.share,
          label: context.l10n.homeInvite,
          onTap: () => BookingActions.shareBooking(context, booking),
        ),
        _ActionButton(
          icon: Icons.calendar_today,
          label: context.l10n.homeAddToCalendar,
          onTap: () => BookingActions.addToCalendar(context, booking),
        ),
      ],
    );
  }
}

/// Single action button widget.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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

/// Empty state widget.
class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
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
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
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
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
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
}

/// Static utility class for booking actions.
///
/// Provides external actions like opening maps, sharing, and calendar.
abstract final class BookingActions {
  /// Opens Google Maps with directions to the field.
  static Future<void> openDirections(
    BuildContext context,
    BookingEntity booking,
  ) async {
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

  /// Shares booking details via system share dialog.
  static void shareBooking(BuildContext context, BookingEntity booking) {
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

  /// Adds booking to device calendar.
  static Future<void> addToCalendar(
    BuildContext context,
    BookingEntity booking,
  ) async {
    try {
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

      if (kIsWeb) {
        await _addToGoogleCalendar(
          context,
          booking,
          startDateTime,
          endDateTime,
        );
        return;
      }

      await _addToNativeCalendar(context, booking, startDateTime, endDateTime);
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, context.l10n.homeErrorAddCalendar);
      }
    }
  }

  static Future<void> _addToGoogleCalendar(
    BuildContext context,
    BookingEntity booking,
    DateTime startDateTime,
    DateTime endDateTime,
  ) async {
    final startFormatted = _formatDateTimeForGoogle(startDateTime);
    final endFormatted = _formatDateTimeForGoogle(endDateTime);

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
        SnackbarHelper.showError(context, context.l10n.homeErrorAddCalendar);
      }
    }
  }

  static Future<void> _addToNativeCalendar(
    BuildContext context,
    BookingEntity booking,
    DateTime startDateTime,
    DateTime endDateTime,
  ) async {
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
  }

  static String _formatDateTimeForGoogle(DateTime dt) {
    return '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}T${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}00';
  }
}
