import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_state.dart';
import 'package:spo_kick/l10n/app_localizations.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Bottom action bar with next/proceed button for booking flow.
class BookingBottomActionBar extends StatelessWidget {
  final BookingFlowActive state;
  final VoidCallback onNext;

  const BookingBottomActionBar({
    super.key,
    required this.state,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price preview (if slot selected)
            if (state.selectedTimeSlot != null) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.totalWithHours(state.selectedDuration),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      LocaleFormatters.formatPrice(
                        context,
                        amount: state.totalPrice,
                        currency:
                            state.selectedTimeSlot?.currency ??
                            context.l10n.currencyEgp,
                        decimalDigits: 0,
                      ),
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              flex: 2,
              child: PremiumButton(
                label: _getButtonLabel(l10n),
                onPressed: state.canProceed ? onNext : null,
                icon: Icons.arrow_forward,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonLabel(AppLocalizations l10n) {
    switch (state.currentStep) {
      case BookingFlowStep.selectDate:
        return l10n.continueLabel;
      case BookingFlowStep.selectTime:
        if (!state.canProceed) {
          return l10n.selectTimeSlotPrompt;
        }
        return l10n.reviewBooking;
      default:
        return l10n.continueLabel;
    }
  }
}
