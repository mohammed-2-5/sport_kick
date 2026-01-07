import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
  final VoidCallback onRecurringRequests;
  final VoidCallback onAnalytics;
  final VoidCallback onSettings;
  final VoidCallback onProfile;
  final int pendingRecurringCount;

  const PremiumOwnerQuickActions({
    super.key,
    required this.onManualBooking,
    required this.onViewBookings,
    required this.onBookingTable,
    required this.onManageFields,
    required this.onRecurringRequests,
    required this.onAnalytics,
    required this.onSettings,
    required this.onProfile,
    this.pendingRecurringCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final actions = [
      _QuickAction(
        label: context.l10n.createBooking,
        icon: Icons.add_circle_outline_rounded,
        gradient: [colorScheme.secondary, colorScheme.secondaryContainer],
        onTap: onManualBooking,
        isPrimary: true,
      ),
      _QuickAction(
        label: context.l10n.viewBookings,
        icon: Icons.calendar_month_rounded,
        gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        onTap: onViewBookings,
      ),
      _QuickAction(
        label: context.l10n.bookingTable,
        icon: Icons.table_chart_rounded,
        gradient: const [Color(0xFF14B8A6), Color(0xFF0D9488)],
        onTap: onBookingTable,
      ),
      _QuickAction(
        label: context.l10n.manageFields,
        icon: Icons.sports_soccer_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
        onTap: onManageFields,
      ),
      _QuickAction(
        label: context.l10n.subscriptions,
        icon: Icons.event_repeat_rounded,
        gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
        onTap: onRecurringRequests,
        badgeCount: pendingRecurringCount,
      ),
      _QuickAction(
        label: context.l10n.analytics,
        icon: Icons.analytics_rounded,
        gradient: const [Color(0xFFEF4444), Color(0xFFDC2626)],
        onTap: onAnalytics,
      ),
      _QuickAction(
        label: context.l10n.settings,
        icon: Icons.settings_rounded,
        gradient: const [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        onTap: onSettings,
      ),
      _QuickAction(
        label: context.l10n.profile,
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
          _SectionHeader(title: context.l10n.quickActions),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.secondary, colorScheme.secondaryContainer],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
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
  final int badgeCount;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.isPrimary = false,
    this.badgeCount = 0,
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
      child: Stack(
        children: [
          Column(
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
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          // Badge
          if (action.badgeCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  action.badgeCount > 99 ? '99+' : action.badgeCount.toString(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
