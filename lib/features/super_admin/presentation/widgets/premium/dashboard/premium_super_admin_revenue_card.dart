import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'components/revenue/revenue_breakdown_item.dart';
import 'components/revenue/revenue_growth_badge.dart';

/// Premium revenue card for super admin dashboard.
///
/// Features:
/// - Large revenue display with gold accent
/// - Revenue breakdown (weekly, monthly, total)
/// - Growth indicator
/// - Animated gradient background
class PremiumSuperAdminRevenueCard extends StatefulWidget {
  final String totalRevenue;
  final String monthlyRevenue;
  final String weeklyRevenue;
  final double growthPercentage;
  final VoidCallback onTap;

  const PremiumSuperAdminRevenueCard({
    super.key,
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.weeklyRevenue,
    required this.growthPercentage,
    required this.onTap,
  });

  @override
  State<PremiumSuperAdminRevenueCard> createState() =>
      _PremiumSuperAdminRevenueCardState();
}

class _PremiumSuperAdminRevenueCardState
    extends State<PremiumSuperAdminRevenueCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldAccent.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.goldAccent, Color(0xFFD4A574)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.goldAccent.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.platformRevenue,
                              style: AppTextStyles.titleSmallWhite,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.l10n.totalEarningsFromAllFields,
                              style: AppTextStyles.withColor(
                                AppTextStyles.labelSmall,
                                Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    RevenueGrowthBadge(growth: widget.growthPercentage),
                  ],
                ),
                const SizedBox(height: 24),

                // Total revenue
                Text(
                  widget.totalRevenue,
                  style: AppTextStyles.withColor(
                    AppTextStyles.displaySmall,
                    AppColors.goldAccent,
                  ),
                ),
                const SizedBox(height: 20),

                // Revenue breakdown
                Row(
                  children: [
                    Expanded(
                      child: RevenueBreakdownItem(
                        label: context.l10n.thisWeek,
                        value: widget.weeklyRevenue,
                        icon: Icons.calendar_view_week_rounded,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: RevenueBreakdownItem(
                        label: context.l10n.thisMonth,
                        value: widget.monthlyRevenue,
                        icon: Icons.calendar_month_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
