import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

class AdminFormInfoCard extends StatelessWidget {
  const AdminFormInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Field Owner Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'A secure password will be generated automatically. The admin must change it on first login.',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
