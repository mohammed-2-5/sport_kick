import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

class CitiesEmptyState extends StatelessWidget {
  const CitiesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_city_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Cities Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing the filter',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
