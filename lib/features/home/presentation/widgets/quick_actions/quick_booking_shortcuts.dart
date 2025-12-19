import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class QuickBookingShortcuts extends StatelessWidget {
  const QuickBookingShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _buildShortcutCard(
            context,
            title: context.l10n.homeShortcutBrowseTitle,
            subtitle: context.l10n.homeShortcutBrowseSubtitle,
            icon: Icons.explore_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFF00D9FF), Color(0xFF0099CC)],
            ),
            onTap: () {
              context.pushNamed('fieldsList');
            },
          ),
          const SizedBox(width: 14),
          _buildShortcutCard(
            context,
            title: context.l10n.homeShortcutBookingsTitle,
            subtitle: context.l10n.homeShortcutBookingsSubtitle,
            icon: Icons.calendar_today_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFF7B61FF), Color(0xFF5B41DF)],
            ),
            onTap: () {
              context.pushNamed('myBookings');
            },
          ),
          const SizedBox(width: 14),
          _buildShortcutCard(
            context,
            title: context.l10n.homeShortcutFavoritesTitle,
            subtitle: context.l10n.homeShortcutFavoritesSubtitle,
            icon: Icons.favorite_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF4B4B), Color(0xFFCC3333)],
            ),
            onTap: () => context.pushNamed('favorites'),
          ),
          const SizedBox(width: 14),
          _buildShortcutCard(
            context,
            title: context.l10n.homeShortcutProfileTitle,
            subtitle: context.l10n.homeShortcutProfileSubtitle,
            icon: Icons.person_rounded,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            onTap: () => context.pushNamed('profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 145,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            // Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
