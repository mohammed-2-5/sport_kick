import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/glass_variants.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Floating action buttons for field details - Book Now and Weekly Subscription.
///
/// Positioned at the bottom of the screen with gradient overlay.
class FieldDetailsFloatingActions extends StatelessWidget {
  final FieldEntity field;

  const FieldDetailsFloatingActions({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.9),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WeeklySubscriptionButton(field: field),
            const SizedBox(height: 12),
            _BookNowButton(field: field),
          ],
        ),
      ),
    );
  }
}

/// Weekly subscription option button.
class _WeeklySubscriptionButton extends StatelessWidget {
  final FieldEntity field;

  const _WeeklySubscriptionButton({required this.field});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('createRecurring', extra: field),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.goldAccent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.goldAccent.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldAccent.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.event_repeat_rounded,
                size: 20,
                color: AppColors.goldAccent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.reserveWeeklySlot,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.navyDeep,
                    ),
                  ),
                  Text(
                    context.l10n.autoBookSameTimeEveryWeek,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.goldAccent,
            ),
          ],
        ),
      ),
    );
  }
}

/// Main book now button.
class _BookNowButton extends StatelessWidget {
  final FieldEntity field;

  const _BookNowButton({required this.field});

  @override
  Widget build(BuildContext context) {
    return GlassFloatingButton(
      label: context.l10n.bookNow,
      icon: Icons.calendar_today,
      onPressed: () {
        context.pushNamed('createBooking', extra: field);
      },
      accentColor: AppColors.accentCyan,
    );
  }
}
