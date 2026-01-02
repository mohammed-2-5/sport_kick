import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Data model for booking stat card.
class BookingStatData {
  /// Label for the stat.
  final String label;

  /// Value of the stat.
  final int value;

  /// Icon to display.
  final IconData icon;

  /// Gradient colors for the icon.
  final List<Color> gradient;

  const BookingStatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
  });
}

/// Premium Booking Stat Card widget.
///
/// Features:
/// - Gradient icon
/// - Animated counter
/// - Subtle shadow
class PremiumBookingStatCard extends StatelessWidget {
  /// Stat data to display.
  final BookingStatData stat;

  const PremiumBookingStatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: stat.gradient[0].withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildIcon(), const Spacer(), _buildValue(), _buildLabel()],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: stat.gradient),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(stat.icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildValue() {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: stat.value),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Text(
          value.toString(),
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w800,
            color: stat.gradient[0],
          ),
        );
      },
    );
  }

  Widget _buildLabel() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Text(
          stat.label,
          style: AppTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        );
      },
    );
  }
}
