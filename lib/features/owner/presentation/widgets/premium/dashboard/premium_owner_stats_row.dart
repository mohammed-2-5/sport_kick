import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Premium owner stats row with gradient cards.
///
/// Features:
/// - Gradient background cards
/// - Icon with glow
/// - Animated entrance
/// - Tap feedback
class PremiumOwnerStatsRow extends StatelessWidget {
  final int totalBookings;
  final int pendingBookings;
  final int todayBookings;
  final String revenue;
  final VoidCallback onBookingsTap;
  final VoidCallback onRevenueTap;

  const PremiumOwnerStatsRow({
    super.key,
    required this.totalBookings,
    required this.pendingBookings,
    required this.todayBookings,
    required this.revenue,
    required this.onBookingsTap,
    required this.onRevenueTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _StatCard(
            label: context.l10n.totalBookings,
            value: LocaleFormatters.formatNumber(context, totalBookings),
            icon: Icons.calendar_month_rounded,
            gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            onTap: onBookingsTap,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: context.l10n.pendingBookingsLabel,
            value: LocaleFormatters.formatNumber(context, pendingBookings),
            icon: Icons.pending_actions_rounded,
            gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
            onTap: onBookingsTap,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: context.l10n.today,
            value: LocaleFormatters.formatNumber(context, todayBookings),
            icon: Icons.today_rounded,
            gradient: [colorScheme.secondary, colorScheme.secondaryContainer],
            onTap: onBookingsTap,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: context.l10n.revenue,
            value: revenue,
            icon: Icons.account_balance_wallet_rounded,
            gradient: const [Color(0xFF10B981), Color(0xFF059669)],
            onTap: onRevenueTap,
            isWide: true,
          ),
        ],
      ),
    );
  }
}

/// Individual stat card with gradient.
class _StatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  final bool isWide;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.isWide = false,
  });

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
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          width: widget.isWide ? 140 : 110,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.first.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 18),
              ),
              const Spacer(),
              Text(
                widget.value,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
