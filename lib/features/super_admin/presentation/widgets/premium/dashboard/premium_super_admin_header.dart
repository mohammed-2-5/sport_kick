import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium super admin header with gold accent theme.
///
/// Features:
/// - Gradient background with gold accent
/// - Glass morphism effects
/// - Admin avatar with crown badge
/// - Notification bell with count
/// - Animated elements
class PremiumSuperAdminHeader extends StatelessWidget {
  final String greeting;
  final String adminName;
  final String date;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;
  final int notificationCount;

  const PremiumSuperAdminHeader({
    super.key,
    required this.greeting,
    required this.adminName,
    required this.date,
    required this.onMenuTap,
    required this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Top row with menu and notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MenuButton(onTap: onMenuTap),
              _NotificationButton(
                count: notificationCount,
                onTap: onNotificationTap,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Admin info row
          Row(
            children: [
              // Avatar with crown
              _AdminAvatar(name: adminName),
              const SizedBox(width: 16),

              // Greeting and info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(greeting, style: AppTextStyles.bodyMediumWhite),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            adminName,
                            style: AppTextStyles.withColor(
                              AppTextStyles.titleLargeBold,
                              Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _AdminBadge(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: AppColors.goldAccent.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(date, style: AppTextStyles.bodySmallWhite),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Menu button with gold accent.
class _MenuButton extends StatefulWidget {
  final VoidCallback onTap;

  const _MenuButton({required this.onTap});

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton>
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
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Notification button with badge.
class _NotificationButton extends StatefulWidget {
  final int count;
  final VoidCallback onTap;

  const _NotificationButton({required this.count, required this.onTap});

  @override
  State<_NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<_NotificationButton>
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
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.goldAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
            if (widget.count > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.goldAccent, Color(0xFFD4A574)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldAccent.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    widget.count > 99 ? '99+' : widget.count.toString(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.withColor(
                      AppTextStyles.labelSmallBold,
                      Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Admin avatar with crown badge.
class _AdminAvatar extends StatelessWidget {
  final String name;

  const _AdminAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.goldAccent, Color(0xFFD4A574)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldAccent.withValues(alpha: 0.4),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1A1A2E),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'A',
                style: AppTextStyles.withColor(
                  AppTextStyles.headlineSmallBold,
                  AppColors.goldAccent,
                ),
              ),
            ),
          ),
        ),
        // Crown badge
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.goldAccent, Color(0xFFD4A574)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldAccent.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.star_rounded,
              size: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Super Admin badge.
class _AdminBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldAccent.withValues(alpha: 0.3),
            const Color(0xFFD4A574).withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_rounded,
            size: 12,
            color: AppColors.goldAccent,
          ),
          const SizedBox(width: 4),
          Text(
            context.l10n.superAdminRole,
            style: AppTextStyles.withColor(
              AppTextStyles.labelSmallBold,
              AppColors.goldAccent,
            ),
          ),
        ],
      ),
    );
  }
}
