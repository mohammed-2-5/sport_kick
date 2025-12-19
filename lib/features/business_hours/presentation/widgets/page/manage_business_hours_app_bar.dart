import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// App bar for the Manage Business Hours page.
///
/// Displays page title, optional field name, and refresh button.
class ManageBusinessHoursAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Optional field name to display as subtitle
  final String? fieldName;

  /// Callback when refresh button is pressed
  final VoidCallback onRefresh;

  const ManageBusinessHoursAppBar({
    super.key,
    this.fieldName,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.businessHours),
          if (fieldName != null)
            Text(
              fieldName!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh,
          tooltip: context.l10n.refresh,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
