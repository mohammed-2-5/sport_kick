import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/glass_container.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_details_actions_cubit.dart';

/// Contact support button with glass effect and press animation.
///
/// Triggers the contact support action through the cubit.
class BookingContactSupportButton extends StatefulWidget {
  final String bookingId;

  const BookingContactSupportButton({super.key, required this.bookingId});

  @override
  State<BookingContactSupportButton> createState() =>
      _BookingContactSupportButtonState();
}

class _BookingContactSupportButtonState
    extends State<BookingContactSupportButton>
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
    final colorScheme = Theme.of(context).colorScheme;

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
            color: colorScheme.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.support_agent, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  context.l10n.contactSupport,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: colorScheme.primary,
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
