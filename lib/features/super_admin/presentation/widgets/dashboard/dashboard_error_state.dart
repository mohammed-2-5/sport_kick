import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/generic_error_state.dart';

/// Error state widget for dashboard.
class DashboardErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const DashboardErrorState({required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericErrorState(
      message: '',
      onRetry: onRetry,
      title: 'Error loading dashboard',
      iconColor: AppColors.error,
    );
  }
}
