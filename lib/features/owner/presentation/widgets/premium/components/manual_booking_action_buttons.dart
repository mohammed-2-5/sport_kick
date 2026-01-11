import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

class ManualBookingActionButtons extends StatelessWidget {
  final AppLocalizations l10n;
  final int currentStep;
  final bool isLoading;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final VoidCallback? onSubmit;

  const ManualBookingActionButtons({
    super.key,
    required this.l10n,
    required this.currentStep,
    required this.isLoading,
    this.onBack,
    this.onNext,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentStep > 1)
            Expanded(
              child: PremiumButton(
                label: l10n.back,
                onPressed: isLoading ? null : onBack,
                style: PremiumButtonStyle.outline,
                icon: Icons.arrow_back,
              ),
            ),
          if (currentStep > 1) const SizedBox(width: 16),
          Expanded(
            child: PremiumButton(
              label: currentStep == 3 ? l10n.createBooking : l10n.next,
              onPressed: isLoading
                  ? null
                  : (currentStep == 3 ? onSubmit : onNext),
              loading: isLoading,
              icon: currentStep == 3 ? Icons.check : Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
}
