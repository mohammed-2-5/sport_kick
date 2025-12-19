import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/home/presentation/widgets/premium/navigation/premium_nav_item.dart';

/// Premium glassmorphism bottom navigation bar.
///
/// Features:
/// - Frosted glass effect with backdrop blur
/// - Floating design with shadow
/// - Animated items with glow
/// - Safe area handling
class PremiumBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PremiumBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: bottomPadding > 0 ? bottomPadding : 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navyDeep.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.accentCyan.withValues(alpha: 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PremiumNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                PremiumNavItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore_rounded,
                  label: 'Explore',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                PremiumNavItem(
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_today_rounded,
                  label: 'Bookings',
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                PremiumNavItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
