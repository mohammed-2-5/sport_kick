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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final infoColor = isDark ? AppColors.darkInfo : AppColors.info;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AuthConstants.formPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mark_email_read,
                size: AuthConstants.logoSize,
                color: successColor,
              ),
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing * 2),
            Text(
              context.l10n.resetEmailSentTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing),
            Text(
              context.l10n.resetEmailSentMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: infoColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.email, color: infoColor, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: infoColor,
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
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
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
