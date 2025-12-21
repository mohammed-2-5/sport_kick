import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Role badge widget used in admin/user cards.
class RoleBadge extends StatelessWidget {
  final bool isSuperAdmin;

  const RoleBadge({super.key, required this.isSuperAdmin});

  @override
  Widget build(BuildContext context) {
    final color = isSuperAdmin ? Colors.deepPurple : Colors.purple;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuperAdmin ? Icons.verified_user : Icons.admin_panel_settings,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isSuperAdmin
                ? context.l10n.roleSuperAdmin
                : context.l10n.fieldOwner,
            style: AppTextStyles.withColor(AppTextStyles.labelSmallBold, color),
          ),
        ],
      ),
    );
  }
}
