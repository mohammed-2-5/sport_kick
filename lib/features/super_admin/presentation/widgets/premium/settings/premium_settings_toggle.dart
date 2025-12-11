import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium settings toggle switch.
///
/// Features:
/// - Icon with colored background
/// - Label and description
/// - Gold-themed switch
/// - Haptic feedback
class PremiumSettingsToggle extends StatelessWidget {
  final String label;
  final String? description;
  final IconData icon;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const PremiumSettingsToggle({
    super.key,
    required this.label,
    this.description,
    required this.icon,
    this.iconColor = AppColors.premiumGold,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            // Label and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Switch
            Switch(
              value: value,
              onChanged: enabled
                  ? (newValue) {
                      HapticFeedback.selectionClick();
                      onChanged(newValue);
                    }
                  : null,
              activeThumbColor: AppColors.premiumGold,
              activeTrackColor: AppColors.premiumGold.withValues(alpha: 0.3),
              inactiveThumbColor: Colors.grey.shade400,
              inactiveTrackColor: Colors.grey.shade200,
            ),
          ],
        ),
      ),
    );
  }
}
