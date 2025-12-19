import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Data model for performance metric.
class MetricData {
  /// Label for the metric.
  final String label;

  /// Current value.
  final double value;

  /// Maximum value for progress indicator.
  final double maxValue;

  /// Display string for the value.
  final String displayValue;

  /// Icon to display.
  final IconData icon;

  /// Color for the metric.
  final Color color;

  const MetricData({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.displayValue,
    required this.icon,
    required this.color,
  });
}

/// Premium Metric Card widget.
///
/// Features:
/// - Circular progress indicator
/// - Icon in center
/// - Animated progress
class PremiumMetricCard extends StatelessWidget {
  /// Metric data to display.
  final MetricData metric;

  const PremiumMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final progress = (metric.value / metric.maxValue).clamp(0.0, 1.0);

    return Container(
      width: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: metric.color.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProgressIndicator(progress),
          const SizedBox(height: 10),
          _buildValue(),
          _buildLabel(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 4,
                backgroundColor: metric.color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(metric.color),
              );
            },
          ),
          Icon(metric.icon, color: metric.color, size: 20),
        ],
      ),
    );
  }

  Widget _buildValue() {
    return Text(
      metric.displayValue,
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.w700,
        color: metric.color,
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      metric.label,
      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
    );
  }
}
