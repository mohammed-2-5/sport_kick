import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

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
    switch (widget.status) {
      case BookingStatus.pending:
        return const Color(0xFFF59E0B);
      case BookingStatus.confirmed:
        return const Color(0xFF10B981);
      case BookingStatus.canceled:
        return const Color(0xFFEF4444);
      case BookingStatus.completed:
        return const Color(0xFF6366F1);
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _statusColor.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
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
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _StatusBadge(
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
                            _InfoChip(
                              icon: Icons.person_outline_rounded,
                              text: widget.userName,
                              color: AppColors.navyDeep,
                            ),
                            if (widget.isManual) ...[
                              const SizedBox(width: 8),
                              _ManualBadge(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Bottom row: Date, time, price
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.calendar_today_rounded,
                              text: widget.formattedDate,
                              color: AppColors.accentCyan,
                            ),
                            const SizedBox(width: 12),
                            _InfoChip(
                              icon: Icons.access_time_rounded,
                              text: widget.formattedTimeSlot,
                              color: AppColors.accentCyan,
                            ),
                            const Spacer(),
                            _PriceBadge(price: widget.formattedPrice),
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

/// Status badge widget.
class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  final IconData icon;

  const _StatusBadge({
    required this.status,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: AppTextStyles.badge.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Info chip (date, time, user).
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: color.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

/// Manual booking badge.
class _ManualBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.goldAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Manual',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.goldAccent,
        ),
      ),
    );
  }
}

/// Price badge.
class _PriceBadge extends StatelessWidget {
  final String price;

  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldAccent, Color(0xFFD4A574)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldAccent.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        price,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
