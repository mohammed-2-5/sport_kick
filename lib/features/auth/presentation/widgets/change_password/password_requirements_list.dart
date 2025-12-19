import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/utils/password_validator.dart';
import 'package:spo_kick/features/auth/presentation/widgets/change_password/password_requirement_item.dart';

/// Password requirements list widget.
///
/// Displays all password requirements with visual indicators
/// showing which requirements are met.
class PasswordRequirementsList extends StatelessWidget {
  final String password;

  const PasswordRequirementsList({required this.password, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasMinLength = PasswordValidator.hasMinLength(password);
    final hasUppercase = PasswordValidator.hasUppercase(password);
    final hasLowercase = PasswordValidator.hasLowercase(password);
    final hasNumber = PasswordValidator.hasNumber(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.passwordRequirementsTitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        PasswordRequirementItem(
          text: l10n.requirement8Chars,
          isMet: hasMinLength,
        ),
        PasswordRequirementItem(
          text: l10n.requirementUppercase,
          isMet: hasUppercase,
        ),
        PasswordRequirementItem(
          text: l10n.requirementLowercase,
          isMet: hasLowercase,
        ),
        PasswordRequirementItem(text: l10n.requirementNumber, isMet: hasNumber),
      ],
    );
  }
}
