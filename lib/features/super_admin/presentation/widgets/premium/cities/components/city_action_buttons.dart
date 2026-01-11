import 'package:flutter/material.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/components/city_action_button.dart';

/// Action buttons (edit, toggle status).
class CityActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;
  final bool isActive;

  const CityActionButtons({
    super.key,
    this.onEdit,
    this.onToggleStatus,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          CityActionButton(
            icon: Icons.edit_rounded,
            color: Theme.of(context).colorScheme.secondary,
            onTap: onEdit!,
          ),
        if (onToggleStatus != null) ...[
          const SizedBox(width: 8),
          CityActionButton(
            icon: isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: isActive
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.onSuccess,
            onTap: onToggleStatus!,
          ),
        ],
      ],
    );
  }
}
