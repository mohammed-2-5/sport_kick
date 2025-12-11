import 'package:flutter/material.dart';

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
            isSuperAdmin ? 'Super Admin' : 'Field Owner',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
