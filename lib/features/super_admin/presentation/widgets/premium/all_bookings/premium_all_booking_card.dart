import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/info_chip.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/manual_badge.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/price_badge.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/status_badge.dart';

/// Premium booking card with status indicator.
///
/// Features:
/// - Status-colored left accent bar
/// - Date and time display with icons
/// - User and field info
/// - Price badge with gradient
/// - Status badge with glow
/// - Animated tap effects
/// - Haptic feedback
class PremiumAllBookingCard extends StatefulWidget {
  /// Booking ID.
  final String bookingId;

  /// User name who made the booking.
  final String userName;

  /// Field name.
  final String fieldName;

  /// Booking date formatted.
  final String formattedDate;

  /// Time slot formatted.
  final String formattedTimeSlot;

  /// Total price formatted.
  final String formattedPrice;

  /// Booking status.
  final BookingStatus status;

  /// Whether this is a manual booking.
  final bool isManual;

  /// Callback when card is tapped.
  final VoidCallback? onTap;

  const PremiumAllBookingCard({
    super.key,
    required this.bookingId,
    required this.userName,
    required this.fieldName,
    required this.formattedDate,
    required this.formattedTimeSlot,
    required this.formattedPrice,
    required this.status,
    this.isManual = false,
    this.onTap,
  });

  @override
  State<PremiumAllBookingCard> createState() => _PremiumAllBookingCardState();
}

class _PremiumAllBookingCardState extends State<PremiumAllBookingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _statusColor {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.status) {
      case BookingStatus.pending:
        return colorScheme.warning;
      case BookingStatus.confirmed:
        return colorScheme.success;
      case BookingStatus.canceled:
        return colorScheme.error;
      case BookingStatus.completed:
        return colorScheme.info;
    }
  }

  String get _statusLabel {
    switch (widget.status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.canceled:
        return 'Canceled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }

  IconData get _statusIcon {
    switch (widget.status) {
      case BookingStatus.pending:
        return Icons.schedule_rounded;
      case BookingStatus.confirmed:
        return Icons.check_circle_rounded;
      case BookingStatus.canceled:
        return Icons.cancel_rounded;
      case BookingStatus.completed:
        return Icons.verified_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: context.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                // Status accent bar
                Container(
                  width: 5,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _statusColor,
                        _statusColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: Field name + Status badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.fieldName,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            StatusBadge(
                              status: _statusLabel,
                              color: _statusColor,
                              icon: _statusIcon,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Middle row: User, date, time
                        Row(
                          children: [
                            // User
                            InfoChip(
                              icon: Icons.person_outline_rounded,
                              text: widget.userName,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            if (widget.isManual) ...[
                              const SizedBox(width: 8),
                              const ManualBadge(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Bottom row: Date, time, price
                        Row(
                          children: [
                            InfoChip(
                              icon: Icons.calendar_today_rounded,
                              text: widget.formattedDate,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 12),
                            InfoChip(
                              icon: Icons.access_time_rounded,
                              text: widget.formattedTimeSlot,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const Spacer(),
                            PriceBadge(price: widget.formattedPrice),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
