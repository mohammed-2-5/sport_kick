import 'package:flutter/material.dart';

class AdminListStats extends StatelessWidget {
  final int filteredCount;
  final int totalCount;
  final bool isSelectionMode;
  final int selectedCount;

  const AdminListStats({
    required this.filteredCount,
    required this.totalCount,
    required this.isSelectionMode,
    required this.selectedCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.admin_panel_settings, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            'Showing $filteredCount of $totalCount admins',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isSelectionMode) ...[
            const Spacer(),
            Text(
              '$selectedCount selected',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
