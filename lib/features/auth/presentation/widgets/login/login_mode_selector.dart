import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Login Mode Selector
///
/// Theme-aware: adapts to light/dark mode.
class LoginModeSelector extends StatelessWidget {
  final String currentMode;
  final ValueChanged<String> onModeChanged;

  const LoginModeSelector({
    required this.currentMode,
    required this.onModeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: LoginModeButton(
              mode: 'user',
              icon: Icons.person_outline,
              label: context.l10n.loginAsUser,
              isSelected: currentMode == 'user',
              onSelected: onModeChanged,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LoginModeButton(
              mode: 'admin',
              icon: Icons.admin_panel_settings_outlined,
              label: context.l10n.loginAsAdmin,
              isSelected: currentMode == 'admin',
              onSelected: onModeChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Login Mode Button
///
/// Theme-aware: adapts to light/dark mode.
class LoginModeButton extends StatelessWidget {
  final String mode;
  final IconData icon;
  final String label;
  final bool isSelected;
  final ValueChanged<String> onSelected;

  const LoginModeButton({
    required this.mode,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onSelected(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppGradients.primary : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: isSelected
                    ? AppTextStyles.labelSmallBold.copyWith(color: Colors.white)
                    : AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
