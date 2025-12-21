import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_details/admin_details_state.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium admin statistics grid.
///
/// Features:
/// - Animated stat cards
/// - Gold theme for admin stats
/// - Rating display
/// - Responsive 2-column grid
class PremiumAdminStatsGrid extends StatelessWidget {
  final AdminDetailsStats stats;

  const PremiumAdminStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final statItems = [
      _StatItem(
        label: context.l10n.totalFields,
        value: stats.totalFields.toString(),
        icon: Icons.sports_soccer,
        color: AppColors.premiumGold,
      ),
      _StatItem(
        label: context.l10n.activeFields,
        value: stats.activeFields.toString(),
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      _StatItem(
        label: context.l10n.totalBookings,
        value: stats.totalBookings.toString(),
        icon: Icons.calendar_month,
        color: AppColors.accentCyan,
      ),
      _StatItem(
        label: context.l10n.memberDays,
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
          _SectionHeader(title: context.l10n.performance, icon: Icons.insights),
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
          if (stats.averageRating > 0) ...[
            const SizedBox(height: 12),
            _RatingCard(rating: stats.averageRating),
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 18, color: item.color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.value,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: item.color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: AppTextStyles.labelMedium.copyWith(
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

/// Rating card widget.
class _RatingCard extends StatelessWidget {
  final double rating;

  const _RatingCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.amber],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.star, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.averageRating,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) {
                        final filled = index < rating.floor();
                        final half =
                            index == rating.floor() && rating % 1 >= 0.5;
                        return Icon(
                          half ? Icons.star_half : Icons.star,
                          size: 16,
                          color: filled || half
                              ? Colors.orange
                              : Colors.grey.shade300,
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
