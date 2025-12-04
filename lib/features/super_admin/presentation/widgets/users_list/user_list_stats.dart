import 'package:flutter/material.dart';

class UserListStats extends StatelessWidget {
  final int filteredCount;
  final int totalCount;
  final int activeCount;
  final bool isSelectionMode;
  final int selectedCount;

  const UserListStats({
    required this.filteredCount,
    required this.totalCount,
    required this.activeCount,
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
          Icon(Icons.people, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            'Showing $filteredCount of $totalCount users',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (isSelectionMode)
            Text(
              '$selectedCount selected',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Text(
              '$activeCount active',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
