import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

class UserListEmptyState extends StatelessWidget {
  final bool hasFilters;

  const UserListEmptyState({required this.hasFilters, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.people_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters ? 'No Results Found' : 'No Users Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Try adjusting your filters'
                : 'Users will appear here once they register',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
