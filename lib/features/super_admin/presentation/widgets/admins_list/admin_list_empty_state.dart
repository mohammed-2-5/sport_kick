import 'package:flutter/material.dart';

class AdminListEmptyState extends StatelessWidget {
  final bool isSearchEmpty;

  const AdminListEmptyState({required this.isSearchEmpty, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearchEmpty
                ? Icons.admin_panel_settings_outlined
                : Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isSearchEmpty ? 'No Admins Yet' : 'No Results Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearchEmpty
                ? 'Create your first field owner account'
                : 'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
