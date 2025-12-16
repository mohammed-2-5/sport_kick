import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';

/// Premium quick actions grid for owner dashboard.
///
/// Features:
/// - Staggered animations
/// - Gradient icons with glow
/// - Tap animations
/// - 2-column grid layout
class PremiumOwnerQuickActions extends StatelessWidget {
  final VoidCallback onManualBooking;
  final VoidCallback onViewBookings;
  final VoidCallback onBookingTable;
  final VoidCallback onManageFields;
  final VoidCallback onAnalytics;
  final VoidCallback onSettings;
  final VoidCallback onProfile;

  const PremiumOwnerQuickActions({
    super.key,
    required this.onManualBooking,
    required this.onViewBookings,
    required this.onBookingTable,
    required this.onManageFields,
    required this.onAnalytics,
    required this.onSettings,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        label: 'Create Booking',
        icon: Icons.add_circle_outline_rounded,
        gradient: const [AppColors.accentCyan, AppColors.accentCyanDark],
        onTap: onManualBooking,
        isPrimary: true,
      ),
      _QuickAction(
        label: 'View Bookings',
        icon: Icons.calendar_month_rounded,
        gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        onTap: onViewBookings,
      ),
      _QuickAction(
        label: 'Booking Table',
        icon: Icons.table_chart_rounded,
        gradient: const [Color(0xFF14B8A6), Color(0xFF0D9488)],
        onTap: onBookingTable,
      ),
      _QuickAction(
        label: 'Manage Fields',
        icon: Icons.sports_soccer_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
        onTap: onManageFields,
      ),
      _QuickAction(
        label: 'Analytics',
        icon: Icons.analytics_rounded,
        gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
        onTap: onAnalytics,
      ),
      _QuickAction(
        label: 'Settings',
        icon: Icons.settings_rounded,
        gradient: const [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        onTap: onSettings,
      ),
      _QuickAction(
        label: 'Profile',
        icon: Icons.person_rounded,
        gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        onTap: onProfile,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Quick Actions'),
          const SizedBox(height: 12),
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 2,
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
              colors: [AppColors.accentCyan, AppColors.accentCyanDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
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
  final bool isPrimary;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.isPrimary = false,
  });
}

/// Quick action card widget.
class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: action.onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: action.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: action.gradient.first.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(action.icon, color: Colors.white, size: 20),
          ),
          const Spacer(),
          // Label
          Text(
            action.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
