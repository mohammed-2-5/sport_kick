import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium super admin navigation drawer with gold accent.
///
/// Features:
/// - Gold gradient header
/// - Animated menu items
/// - Section dividers
/// - Logout with confirmation
class PremiumSuperAdminDrawer extends StatelessWidget {
  final String adminName;
  final String email;
  final int selectedIndex;
  final Function(int) onItemTap;
  final VoidCallback onLogout;

  const PremiumSuperAdminDrawer({
    super.key,
    required this.adminName,
    required this.email,
    required this.selectedIndex,
    required this.onItemTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          _DrawerHeader(name: adminName, email: email),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerItem(
                  icon: Icons.dashboard_rounded,
                  label: context.l10n.dashboard,
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTap(0),
                ),
                _SectionDivider(title: context.l10n.management),
                _DrawerItem(
                  icon: Icons.people_rounded,
                  label: context.l10n.users,
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemTap(1),
                ),
                _DrawerItem(
                  icon: Icons.admin_panel_settings_rounded,
                  label: context.l10n.fieldOwners2,
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemTap(2),
                ),
                _DrawerItem(
                  icon: Icons.sports_soccer_rounded,
                  label: context.l10n.fields,
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemTap(3),
                ),
                _DrawerItem(
                  icon: Icons.calendar_month_rounded,
                  label: context.l10n.bookings,
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemTap(4),
                ),
                _DrawerItem(
                  icon: Icons.location_city_rounded,
                  label: context.l10n.cities,
                  isSelected: selectedIndex == 5,
                  onTap: () => onItemTap(5),
                ),
                _DrawerItem(
                  icon: Icons.sports_rounded,
                  label: context.l10n.sports,
                  isSelected: selectedIndex == 6,
                  onTap: () => onItemTap(6),
                ),
                _DrawerItem(
                  icon: Icons.rate_review_rounded,
                  label: context.l10n.reviews,
                  isSelected: selectedIndex == 7,
                  onTap: () => onItemTap(7),
                ),
                _DrawerItem(
                  icon: Icons.notifications_active_rounded,
                  label: context.l10n.notifications,
                  isSelected: selectedIndex == 8,
                  onTap: () => onItemTap(8),
                ),
                _SectionDivider(title: context.l10n.analytics),
                _DrawerItem(
                  icon: Icons.analytics_rounded,
                  label: context.l10n.statistics,
                  isSelected: selectedIndex == 9,
                  onTap: () => onItemTap(9),
                ),
                _DrawerItem(
                  icon: Icons.assessment_rounded,
                  label: context.l10n.reports,
                  isSelected: selectedIndex == 10,
                  onTap: () => onItemTap(10),
                ),
                _DrawerItem(
                  icon: Icons.security_rounded,
                  label: context.l10n.loginActivity,
                  isSelected: selectedIndex == 11,
                  onTap: () => onItemTap(11),
                ),
                _SectionDivider(title: context.l10n.system),
                _DrawerItem(
                  icon: Icons.settings_rounded,
                  label: context.l10n.settings,
                  isSelected: selectedIndex == 12,
                  onTap: () => onItemTap(12),
                ),
              ],
            ),
          ),

          // Logout
          _LogoutButton(onTap: onLogout),

          // Version info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.l10n.sportKickAdminV100,
              style: AppTextStyles.withColor(
                AppTextStyles.labelSmall,
                AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Drawer header with gold accent.
class _DrawerHeader extends StatelessWidget {
  final String name;
  final String email;

  const _DrawerHeader({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Avatar with crown
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.goldAccent, Color(0xFFD4A574)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldAccent.withValues(alpha: 0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1A1A2E),
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'A',
                      style: AppTextStyles.withColor(
                        AppTextStyles.titleMediumBold,
                        AppColors.goldAccent,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.goldAccent, Color(0xFFD4A574)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldAccent.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.titleMediumWhite,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: AppTextStyles.bodySmallWhite,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.goldAccent.withValues(alpha: 0.3),
                        const Color(0xFFD4A574).withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.goldAccent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size: 10,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section divider with title.
class _SectionDivider extends StatelessWidget {
  final String title;

  const _SectionDivider({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.withColor(
              AppTextStyles.labelSmallBold,
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.textSecondary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

/// Drawer menu item.
class _DrawerItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem>
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
      end: 0.97,
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
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.goldAccent.withValues(alpha: 0.15),
                      AppColors.goldAccent.withValues(alpha: 0.05),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            border: widget.isSelected
                ? Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: widget.isSelected
                      ? const LinearGradient(
                          colors: [AppColors.goldAccent, Color(0xFFD4A574)],
                        )
                      : null,
                  color: widget.isSelected ? null : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.goldAccent.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  size: 18,
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),

              // Label
              Expanded(
                child: Text(
                  widget.label,
                  style: AppTextStyles.withColor(
                    widget.isSelected
                        ? AppTextStyles.bold(AppTextStyles.bodyMedium)
                        : AppTextStyles.bodyMedium,
                    widget.isSelected
                        ? AppColors.goldAccent
                        : AppColors.textPrimary,
                  ),
                ),
              ),

              // Arrow for selected
              if (widget.isSelected)
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.goldAccent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logout button.
class _LogoutButton extends StatefulWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton>
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
      end: 0.97,
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
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                context.l10n.logout,
                style: AppTextStyles.withColor(
                  AppTextStyles.bold(AppTextStyles.labelLarge),
                  AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
