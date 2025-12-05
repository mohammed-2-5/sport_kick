import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';
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
    final hasMinLength = PasswordValidator.hasMinLength(password);
    final hasUppercase = PasswordValidator.hasUppercase(password);
    final hasLowercase = PasswordValidator.hasLowercase(password);
    final hasNumber = PasswordValidator.hasNumber(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AuthConstants.passwordRequirementsTitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        PasswordRequirementItem(
          text: AuthConstants.requirement8Chars,
          isMet: hasMinLength,
        ),
        PasswordRequirementItem(
          text: AuthConstants.requirementUppercase,
          isMet: hasUppercase,
        ),
        PasswordRequirementItem(
          text: AuthConstants.requirementLowercase,
          isMet: hasLowercase,
        ),
        PasswordRequirementItem(
          text: AuthConstants.requirementNumber,
          isMet: hasNumber,
        ),
      ],
    );
  }
}
