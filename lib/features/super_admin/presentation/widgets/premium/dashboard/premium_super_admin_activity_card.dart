import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium activity summary card for super admin dashboard.
///
/// Features:
/// - Today's activity overview
/// - Pending items counter
/// - Progress indicators
/// - Animated elements
class PremiumSuperAdminActivityCard extends StatelessWidget {
  final int todayBookings;
  final int pendingBookings;
  final int pendingFields;
  final int activeUsers;
  final VoidCallback onTap;

  const PremiumSuperAdminActivityCard({
    super.key,
    required this.todayBookings,
    required this.pendingBookings,
    required this.pendingFields,
    required this.activeUsers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: "Today's Activity"),
          const SizedBox(height: 14),
          _ActivityGrid(
            todayBookings: todayBookings,
            pendingBookings: pendingBookings,
            pendingFields: pendingFields,
            activeUsers: activeUsers,
            onTap: onTap,
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

/// Activity grid.
class _ActivityGrid extends StatelessWidget {
  final int todayBookings;
  final int pendingBookings;
  final int pendingFields;
  final int activeUsers;
  final VoidCallback onTap;

  const _ActivityGrid({
    required this.todayBookings,
    required this.pendingBookings,
    required this.pendingFields,
    required this.activeUsers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActivityItem(
            label: 'Today Bookings',
            value: todayBookings.toString(),
            icon: Icons.event_available_rounded,
            color: const Color(0xFF3B82F6),
            onTap: onTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActivityItem(
            label: 'Pending',
            value: pendingBookings.toString(),
            icon: Icons.pending_actions_rounded,
            color: Colors.orange,
            showBadge: pendingBookings > 0,
            onTap: onTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActivityItem(
            label: 'New Fields',
            value: pendingFields.toString(),
            icon: Icons.add_business_rounded,
            color: const Color(0xFF10B981),
            showBadge: pendingFields > 0,
            onTap: onTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActivityItem(
            label: 'Active Now',
            value: activeUsers.toString(),
            icon: Icons.person_rounded,
            color: const Color(0xFF8B5CF6),
            isLive: true,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

/// Individual activity item.
class _ActivityItem extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool showBadge;
  final bool isLive;
  final VoidCallback onTap;

  const _ActivityItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.showBadge = false,
    this.isLive = false,
    required this.onTap,
  });

  @override
  State<_ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<_ActivityItem>
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  // Icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 18),
                  ),
                  const SizedBox(height: 8),

                  // Value
                  Text(
                    widget.value,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Label
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),

              // Badge indicator
              if (widget.showBadge)
                Positioned(
                  top: 2,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),

              // Live indicator
              if (widget.isLive)
                Positioned(
                  top: 2,
                  right: 10,
                  child: _PulsingDot(color: widget.color),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pulsing dot for live indicator.
class _PulsingDot extends StatelessWidget {
  final Color color;

  const _PulsingDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
