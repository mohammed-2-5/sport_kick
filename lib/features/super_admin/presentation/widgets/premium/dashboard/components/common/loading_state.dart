import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Loading state widget for dashboard.
class DashboardLoadingState extends StatelessWidget {
  const DashboardLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.goldAccent),
      ),
    );
  }
}
