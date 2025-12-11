import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium stats bar for cities overview.
///
/// Features:
/// - Horizontal scrollable stats cards
/// - Animated entrance with staggered delays
/// - Gradient accents for each stat type
/// - Compact design for mobile screens
class PremiumCitiesStatsBar extends StatelessWidget {
  /// Total number of cities.
  final int totalCities;

  /// Number of active cities.
  final int activeCities;

  /// Number of inactive cities.
  final int inactiveCities;

  /// Total fields across all cities.
  final int totalFields;

  const PremiumCitiesStatsBar({
    super.key,
    required this.totalCities,
    required this.activeCities,
    required this.inactiveCities,
    required this.totalFields,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(
        label: 'Total Cities',
        value: totalCities.toString(),
        icon: Icons.location_city_rounded,
        gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      ),
      _StatItem(
        label: 'Active',
        value: activeCities.toString(),
        icon: Icons.check_circle_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
      ),
      _StatItem(
        label: 'Inactive',
        value: inactiveCities.toString(),
        icon: Icons.pause_circle_rounded,
        gradient: const [Color(0xFFEF4444), Color(0xFFDC2626)],
      ),
      _StatItem(
        label: 'Total Fields',
        value: totalFields.toString(),
        icon: Icons.sports_soccer_rounded,
        gradient: const [AppColors.accentCyan, Color(0xFF0891B2)],
      ),
    ];

    return SizedBox(
      height: 120,
      child: AnimationLimiter(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: stats.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 400),
              child: SlideAnimation(
                horizontalOffset: 50,
                child: FadeInAnimation(child: _StatCard(item: stats[index])),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Data class for stat items.
class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradient;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
  });
}

/// Individual stat card widget.
class _StatCard extends StatelessWidget {
  final _StatItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: item.gradient[0].withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with gradient background
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: item.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: item.gradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(item.icon, color: Colors.white, size: 16),
          ),
          const Spacer(),

          // Value
          Text(
            item.value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: item.gradient[0],
            ),
          ),

          // Label
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
