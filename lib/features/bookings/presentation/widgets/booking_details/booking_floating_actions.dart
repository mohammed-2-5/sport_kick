import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/glass_container.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_details_actions_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_cancel_dialog.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Floating action buttons for booking details.
///
/// Shows cancel and contact support buttons with glass effect.
class BookingFloatingActions extends StatelessWidget {
  final BookingEntity booking;

  const BookingFloatingActions({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (booking.canCancel) ...[
              Expanded(child: _CancelButton(bookingId: booking.id)),
              const SizedBox(width: 12),
            ],
            Expanded(child: _ContactSupportButton(bookingId: booking.id)),
          ],
        ),
      ),
    );
  }
}

class _CancelButton extends StatefulWidget {
  final String bookingId;

  const _CancelButton({required this.bookingId});

  @override
  State<_CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<_CancelButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        BookingCancelDialog.show(context, widget.bookingId);
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.error, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cancel_outlined,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.cancel,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.error,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactSupportButton extends StatefulWidget {
  final String bookingId;

  const _ContactSupportButton({required this.bookingId});

  @override
  State<_ContactSupportButton> createState() => _ContactSupportButtonState();
}

class _ContactSupportButtonState extends State<_ContactSupportButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        context.read<BookingDetailsActionsCubit>().contactSupport(
          context,
          widget.bookingId,
        );
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GlassContainer(
          blur: 10,
          opacity: 0.1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.5),
            width: 1.5,
          ),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.support_agent,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.contactSupport,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.accentCyan,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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
