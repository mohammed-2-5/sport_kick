import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';

/// Premium form buttons for admin creation.
///
/// Features:
/// - Submit button with loading state
/// - Cancel button with outline style
/// - Gold theme styling
class PremiumAdminFormButtons extends StatelessWidget {
  final bool isSubmitting;
  final bool isValid;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const PremiumAdminFormButtons({
    super.key,
    required this.isSubmitting,
    required this.isValid,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Submit button
        PremiumButton(
          label: 'Create Admin Account',
          onPressed: isSubmitting || !isValid
              ? () {}
              : () {
                  HapticFeedback.mediumImpact();
                  onSubmit();
                },
          icon: Icons.person_add,
          loading: isSubmitting,
          fullWidth: true,
          style: PremiumButtonStyle.primary,
        ),

        const SizedBox(height: 12),

        // Cancel button
        GestureDetector(
          onTap: isSubmitting
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  onCancel();
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSubmitting
                    ? AppColors.border.withValues(alpha: 0.5)
                    : AppColors.border,
              ),
            ),
            child: Center(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSubmitting
                      ? AppColors.textSecondary.withValues(alpha: 0.5)
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
