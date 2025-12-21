import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Status badge widget for field active/inactive status
class FieldStatusBadge extends StatelessWidget {
  final bool isActive;

  const FieldStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? Colors.green : Colors.orange),
      ),
      child: Text(
        isActive ? context.l10n.active : context.l10n.inactive,
        style: AppTextStyles.labelSmall.copyWith(
          color: isActive ? Colors.green : Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
