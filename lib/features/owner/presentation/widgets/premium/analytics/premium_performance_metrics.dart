import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_metric_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium Performance Metrics Row.
///
/// Features:
/// - Horizontal scrollable
/// - Circular progress indicators
/// - Metric labels and values
class PremiumPerformanceMetrics extends StatelessWidget {
  /// Average rating (0-5).
  final double averageRating;

  /// Booking completion rate (0-100).
  final double completionRate;

  /// Response time in hours.
  final double responseTime;

  /// Customer satisfaction rate (0-100).
  final double satisfactionRate;

  const PremiumPerformanceMetrics({
    super.key,
    required this.averageRating,
    required this.completionRate,
    required this.responseTime,
    required this.satisfactionRate,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = [
      MetricData(
        label: context.l10n.rating,
        value: averageRating,
        maxValue: 5,
        displayValue: averageRating.toStringAsFixed(1),
        icon: Icons.star_rounded,
        color: const Color(0xFFFBBF24),
      ),
      MetricData(
        label: context.l10n.completion,
        value: completionRate,
        maxValue: 100,
        displayValue: '${completionRate.toStringAsFixed(0)}%',
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF10B981),
      ),
      MetricData(
        label: context.l10n.response,
        value: 24 - responseTime.clamp(0, 24),
        maxValue: 24,
        displayValue: '${responseTime.toStringAsFixed(0)}h',
        icon: Icons.speed_rounded,
        color: const Color(0xFF3B82F6),
      ),
      MetricData(
        label: context.l10n.satisfaction,
        value: satisfactionRate,
        maxValue: 100,
        displayValue: '${satisfactionRate.toStringAsFixed(0)}%',
        icon: Icons.sentiment_satisfied_rounded,
        color: const Color(0xFF8B5CF6),
      ),
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: metrics.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              horizontalOffset: 50,
              child: FadeInAnimation(
                child: PremiumMetricCard(metric: metrics[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
