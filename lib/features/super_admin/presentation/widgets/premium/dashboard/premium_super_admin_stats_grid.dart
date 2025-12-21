import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium stats grid for super admin dashboard.
///
/// Features:
/// - 2x2 grid layout with large stat cards
/// - Gradient backgrounds with glow effects
/// - Growth indicators
/// - Animated entrance
class PremiumSuperAdminStatsGrid extends StatelessWidget {
  final int totalUsers;
  final int totalAdmins;
  final int totalFields;
  final int totalBookings;
  final double userGrowth;
  final double bookingGrowth;
  final VoidCallback onUsersTap;
  final VoidCallback onAdminsTap;
  final VoidCallback onFieldsTap;
  final VoidCallback onBookingsTap;

  const PremiumSuperAdminStatsGrid({
    super.key,
    required this.totalUsers,
    required this.totalAdmins,
    required this.totalFields,
    required this.totalBookings,
    required this.userGrowth,
    required this.bookingGrowth,
    required this.onUsersTap,
    required this.onAdminsTap,
    required this.onFieldsTap,
    required this.onBookingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(
        label: context.l10n.totalUsers,
        value: _formatNumber(totalUsers),
        icon: Icons.people_rounded,
        gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        growth: userGrowth,
        onTap: onUsersTap,
      ),
      _StatItem(
        label: context.l10n.fieldOwners2,
        value: _formatNumber(totalAdmins),
        icon: Icons.admin_panel_settings_rounded,
        gradient: const [AppColors.goldAccent, Color(0xFFD4A574)],
        onTap: onAdminsTap,
      ),
      _StatItem(
        label: context.l10n.totalFields,
        value: _formatNumber(totalFields),
        icon: Icons.sports_soccer_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
        onTap: onFieldsTap,
      ),
      _StatItem(
        label: context.l10n.totalBookings,
        value: _formatNumber(totalBookings),
        icon: Icons.calendar_month_rounded,
        gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        growth: bookingGrowth,
        onTap: onBookingsTap,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimationLimiter(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 2,
              duration: const Duration(milliseconds: 400),
              child: ScaleAnimation(
                child: FadeInAnimation(child: _StatCard(stat: stats[index])),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

/// Stat item data class.
class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradient;
  final double? growth;
  final VoidCallback onTap;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    this.growth,
    required this.onTap,
  });
}

/// Individual stat card widget.
class _StatCard extends StatefulWidget {
  final _StatItem stat;

  const _StatCard({required this.stat});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
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
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.stat.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.stat.gradient.first.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decoration
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        widget.stat.gradient.first.withValues(alpha: 0.1),
                        widget.stat.gradient.last.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.stat.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: widget.stat.gradient.first.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.stat.icon,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const Spacer(),

                    // Value
                    Text(
                      widget.stat.value,
                      style: AppTextStyles.bold(AppTextStyles.headlineMedium),
                    ),
                    const SizedBox(height: 4),

                    // Label and growth
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.stat.label,
                            style: AppTextStyles.bodySmallSecondary,
                          ),
                        ),
                        if (widget.stat.growth != null)
                          _GrowthBadge(growth: widget.stat.growth!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Growth indicator badge.
class _GrowthBadge extends StatelessWidget {
  final double growth;

  const _GrowthBadge({required this.growth});

  @override
  Widget build(BuildContext context) {
    final isPositive = growth >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 12,
            color: isPositive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 2),
          Text(
            '${growth.abs().toStringAsFixed(1)}%',
            style: AppTextStyles.withColor(
              AppTextStyles.labelSmallBold,
              isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
