import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

/// Forgot password success screen widget.
///
/// Displays confirmation message after password reset email is sent.
class ForgotPasswordSuccessScreen extends StatelessWidget {
  final String email;
  final VoidCallback onBackToLogin;

  const ForgotPasswordSuccessScreen({
    required this.email,
    required this.onBackToLogin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AuthConstants.formPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read,
                size: AuthConstants.logoSize,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing * 2),
            Text(
              context.l10n.resetEmailSentTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing),
            Text(
              context.l10n.resetEmailSentMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.email, color: AppColors.info, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing * 3),
            SizedBox(
              width: double.infinity,
              height: AuthConstants.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: onBackToLogin,
                icon: const Icon(Icons.login),
                label: Text(
                  context.l10n.backToLogin,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AuthConstants.borderRadius,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
