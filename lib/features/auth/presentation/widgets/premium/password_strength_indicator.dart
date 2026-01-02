import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/l10n/app_localizations.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Password strength indicator with animated bars.
///
/// Features:
/// - Four-level strength indicator
/// - Animated color transitions
/// - Strength label
/// - Requirement checklist
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool showRequirements;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showRequirements = true,
  });

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    final l10n = context.l10n;
    final strengthInfo = _getStrengthInfo(strength, l10n, context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bars
        Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            return Row(
              children: List.generate(4, (index) {
                final isActive = index < strength;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: isActive
                          ? strengthInfo.color
                          : colorScheme.outline.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            );
          },
        ),

        const SizedBox(height: 8),

        // Strength label
        Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.passwordStrength,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    strengthInfo.label,
                    key: ValueKey(strengthInfo.label),
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: strengthInfo.color,
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Requirements checklist
        if (showRequirements && password.isNotEmpty) ...[
          const SizedBox(height: 12),
          _RequirementItem(
            label: l10n.requirement8Chars,
            isMet: password.length >= 8,
          ),
          _RequirementItem(
            label: l10n.requirementUppercase,
            isMet: password.contains(RegExp(r'[A-Z]')),
          ),
          _RequirementItem(
            label: l10n.requirementLowercase,
            isMet: password.contains(RegExp(r'[a-z]')),
          ),
          _RequirementItem(
            label: l10n.requirementNumber,
            isMet: password.contains(RegExp(r'[0-9]')),
          ),
          _RequirementItem(
            label: l10n.requirementSpecialChar,
            isMet: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
          ),
        ],
      ],
    );
  }

  int _calculateStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // Character variety
    if (password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[A-Z]'))) {
      strength++;
    }

    if (password.contains(RegExp(r'[0-9]'))) strength++;

    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      strength++;
    }

    return strength.clamp(0, 4);
  }

  _StrengthInfo _getStrengthInfo(
    int strength,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (strength) {
      case 0:
        return _StrengthInfo('', Theme.of(context).colorScheme.outline);
      case 1:
        return _StrengthInfo(
          l10n.passwordStrengthWeak,
          isDark ? AppColors.darkError : AppColors.error,
        );
      case 2:
        return _StrengthInfo(
          l10n.passwordStrengthFair,
          isDark ? AppColors.darkWarning : AppColors.warning,
        );
      case 3:
        return _StrengthInfo(
          l10n.passwordStrengthGood,
          isDark ? AppColors.darkInfo : AppColors.info,
        );
      case 4:
        return _StrengthInfo(
          l10n.passwordStrengthStrong,
          isDark ? AppColors.darkSuccess : AppColors.success,
        );
      default:
        return _StrengthInfo('', Theme.of(context).colorScheme.outline);
    }
  }
}

class _StrengthInfo {
  final String label;
  final Color color;

  _StrengthInfo(this.label, this.color);
}

/// Single requirement item with check animation.
class _RequirementItem extends StatelessWidget {
  final String label;
  final bool isMet;

  const _RequirementItem({required this.label, required this.isMet});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMet
                  ? successColor.withValues(alpha: 0.1)
                  : colorScheme.outline.withValues(alpha: 0.1),
              border: Border.all(
                color: isMet
                    ? successColor
                    : colorScheme.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isMet
                  ? Icon(Icons.check, size: 12, color: successColor)
                  : const SizedBox.shrink(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isMet ? successColor : colorScheme.onSurfaceVariant,
                fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact strength indicator for inline use.
class CompactPasswordStrength extends StatelessWidget {
  final String password;

  const CompactPasswordStrength({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    final color = _getColor(strength, context);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < strength
                ? color
                : colorScheme.outline.withValues(alpha: 0.3),
          ),
        );
      }),
    );
  }

  int _calculateStrength(String password) {
    if (password.isEmpty) return 0;
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[A-Z]'))) {
      strength++;
    }
    if (password.contains(RegExp(r'[0-9]')) ||
        password.contains(RegExp(r'[!@#$%^&*()]'))) {
      strength++;
    }
    return strength.clamp(0, 4);
  }

  Color _getColor(int strength, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (strength) {
      case 1:
        return isDark ? AppColors.darkError : AppColors.error;
      case 2:
        return isDark ? AppColors.darkWarning : AppColors.warning;
      case 3:
        return isDark ? AppColors.darkInfo : AppColors.info;
      case 4:
        return isDark ? AppColors.darkSuccess : AppColors.success;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }
}
