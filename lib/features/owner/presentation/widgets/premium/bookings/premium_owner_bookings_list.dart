import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_booking_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium list view for owner bookings.
///
/// Features:
/// - Smooth animations
/// - Pull-to-refresh
/// - Empty state
/// - Loading shimmer
/// - Payment verification actions
class PremiumOwnerBookingsList extends StatelessWidget {
  final List<BookingEntity> bookings;
  final bool isLoading;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final Function(String) onApprove;
  final Function(String) onReject;
  final Function(BookingEntity)? onTap;
  final Function(BookingEntity)? onViewPaymentProof;
  final Function(String)? onVerifyPayment;
  final Function(String)? onRejectPayment;
  final String emptyMessage;

  const PremiumOwnerBookingsList({
    super.key,
    required this.bookings,
    required this.isLoading,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onApprove,
    required this.onReject,
    this.onTap,
    this.onViewPaymentProof,
    this.onVerifyPayment,
    this.onRejectPayment,
    this.emptyMessage = 'No bookings found',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && !isRefreshing) {
      return _LoadingShimmer();
    }

    if (bookings.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppColors.accentCyan,
      backgroundColor: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: bookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 50)),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: PremiumOwnerBookingCard(
              booking: booking,
              onTap: onTap != null ? () => onTap!(booking) : null,
              onApprove: () => onApprove(booking.id),
              onReject: () => onReject(booking.id),
              onViewPaymentProof: onViewPaymentProof != null
                  ? () => onViewPaymentProof!(booking)
                  : null,
              onVerifyPayment: onVerifyPayment != null
                  ? () => onVerifyPayment!(booking.id)
                  : null,
              onRejectPayment: onRejectPayment != null
                  ? () => onRejectPayment!(booking.id)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

/// Loading shimmer effect.
class _LoadingShimmer extends StatefulWidget {
  @override
  State<_LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<_LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    AppColors.shimmerBase,
                    AppColors.shimmerHighlight,
                    AppColors.shimmerBase,
                  ],
                  stops: [
                    (0.3 + _animation.value / 4).clamp(0.0, 1.0),
                    (0.5 + _animation.value / 4).clamp(0.0, 1.0),
                    (0.7 + _animation.value / 4).clamp(0.0, 1.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Empty state with icon and message.
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.accentCyan.withValues(alpha: 0.1),
                  AppColors.premiumPeriwinkle.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 60,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.tryAdjustingYourFiltersOrSearch,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
