import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_details/user_details_state.dart';

/// Premium user statistics grid.
///
/// Features:
/// - Animated stat cards
/// - Color-coded metrics
/// - Responsive 2-column grid
/// - Gold accent for important stats
class PremiumUserStatsGrid extends StatelessWidget {
  final UserDetailsStats stats;

  const PremiumUserStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final statItems = [
      _StatItem(
        label: 'Total Bookings',
        value: stats.totalBookings.toString(),
        icon: Icons.calendar_month,
        color: AppColors.accentCyan,
      ),
      _StatItem(
        label: 'Completed',
        value: stats.completedBookings.toString(),
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      _StatItem(
        label: 'Cancelled',
        value: stats.cancelledBookings.toString(),
        icon: Icons.cancel,
        color: Colors.red,
      ),
      _StatItem(
        label: 'Pending',
        value: stats.pendingBookings.toString(),
        icon: Icons.pending,
        color: Colors.orange,
      ),
      _StatItem(
        label: 'Total Spent',
        value: 'EGP ${stats.totalSpent.toStringAsFixed(0)}',
        icon: Icons.payments,
        color: AppColors.premiumGold,
      ),
      _StatItem(
        label: 'Member Days',
        value: stats.memberDays.toString(),
        icon: Icons.timer,
        color: Colors.purple,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Statistics', icon: Icons.bar_chart),
          const SizedBox(height: 12),
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: statItems.length,
              itemBuilder: (context, index) {
                final item = statItems[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(child: _StatCard(item: item)),
                  ),
                );
              },
            ),
          ),
          if (stats.favoriteField != null) ...[
            const SizedBox(height: 12),
            _FavoriteFieldCard(fieldName: stats.favoriteField!),
          ],
        ],
      ),
    );
  }
}

/// Section header widget.
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Stat item data class.
class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

/// Stat card widget.
class _StatCard extends StatelessWidget {
  final _StatItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, size: 18, color: item.color),
              ),
              const Spacer(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.value,
                style: AppTextStyles.titleLarge.copyWith(color: item.color),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Favorite field card widget.
class _FavoriteFieldCard extends StatelessWidget {
  final String fieldName;

  const _FavoriteFieldCard({required this.fieldName});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.premiumGold.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.favorite, size: 22, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Favorite Field',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fieldName,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
