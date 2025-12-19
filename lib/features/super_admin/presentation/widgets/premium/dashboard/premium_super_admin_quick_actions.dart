import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium quick actions for super admin dashboard.
///
/// Features:
/// - 2-column grid with 8 management actions
/// - Gradient icons with glow
/// - Animated entrance
/// - Tap feedback
class PremiumSuperAdminQuickActions extends StatelessWidget {
  final VoidCallback onManageUsers;
  final VoidCallback onManageAdmins;
  final VoidCallback onManageFields;
  final VoidCallback onManageBookings;
  final VoidCallback onManageCities;
  final VoidCallback onViewAnalytics;
  final VoidCallback onViewReports;

  final VoidCallback onSettings;

  const PremiumSuperAdminQuickActions({
    super.key,
    required this.onManageUsers,
    required this.onManageAdmins,
    required this.onManageFields,
    required this.onManageBookings,
    required this.onManageCities,
    required this.onViewAnalytics,
    required this.onViewReports,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        label: 'Manage Users',
        icon: Icons.people_rounded,
        gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        onTap: onManageUsers,
      ),
      _QuickAction(
        label: 'Field Owners',
        icon: Icons.admin_panel_settings_rounded,
        gradient: const [AppColors.goldAccent, Color(0xFFD4A574)],
        onTap: onManageAdmins,
      ),
      _QuickAction(
        label: 'All Fields',
        icon: Icons.sports_soccer_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
        onTap: onManageFields,
      ),
      _QuickAction(
        label: 'All Bookings',
        icon: Icons.calendar_month_rounded,
        gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        onTap: onManageBookings,
      ),
      _QuickAction(
        label: 'Cities',
        icon: Icons.location_city_rounded,
        gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
        onTap: onManageCities,
      ),
      _QuickAction(
        label: 'Analytics',
        icon: Icons.analytics_rounded,
        gradient: const [Color(0xFFEC4899), Color(0xFFBE185D)],
        onTap: onViewAnalytics,
      ),
      _QuickAction(
        label: 'Reports',
        icon: Icons.assessment_rounded,
        gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        onTap: onViewReports,
      ),
      _QuickAction(
        label: 'Settings',
        icon: Icons.settings_rounded,
        gradient: const [Color(0xFF64748B), Color(0xFF475569)],
        onTap: onSettings,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Quick Actions'),
          const SizedBox(height: 14),
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 4,
                  duration: const Duration(milliseconds: 375),
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: _QuickActionCard(action: actions[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header.
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.goldAccent, Color(0xFFD4A574)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Quick action data class.
class _QuickAction {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}

/// Quick action card widget.
class _QuickActionCard extends StatefulWidget {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
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
      end: 0.9,
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
        widget.action.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.action.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.action.gradient.first.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(widget.action.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),

            // Label
            Text(
              widget.action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
