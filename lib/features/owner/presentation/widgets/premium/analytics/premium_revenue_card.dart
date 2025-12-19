import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium Revenue Card with gradient design.
///
/// Features:
/// - Navy gradient background
/// - Large animated revenue number
/// - Comparison with previous period
/// - Growth indicator with arrow
/// - Subtle glow effect
class PremiumRevenueCard extends StatelessWidget {
  /// Total revenue amount.
  final double totalRevenue;

  /// Currency symbol.
  final String currency;

  /// Growth percentage compared to previous period.
  final double growthPercentage;

  /// Previous period revenue.
  final double previousRevenue;

  /// Selected period label.
  final String periodLabel;

  const PremiumRevenueCard({
    super.key,
    required this.totalRevenue,
    this.currency = 'EGP',
    this.growthPercentage = 0,
    this.previousRevenue = 0,
    this.periodLabel = 'This Month',
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = growthPercentage >= 0;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.navyGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDeep.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildRevenueAmount(),
            const SizedBox(height: 16),
            _buildGrowthIndicator(isPositive),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: AppColors.goldAccent,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Revenue',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textOnNavySecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              periodLabel,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textOnNavySecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueAmount() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: totalRevenue),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '${value.toStringAsFixed(0)} $currency',
          style: AppTextStyles.displaySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        );
      },
    );
  }

  Widget _buildGrowthIndicator(bool isPositive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isPositive
            ? const Color(0xFF10B981).withValues(alpha: 0.2)
            : const Color(0xFFEF4444).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: isPositive
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${isPositive ? '+' : ''}${growthPercentage.toStringAsFixed(1)}%',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isPositive
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'vs last period',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textOnNavySecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
