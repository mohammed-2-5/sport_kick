import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_state.dart';

/// Badge widget showing notification count.
///
/// Displays a bell icon with unread count badge.
/// Can be used in app bars across different roles.
/// Updated: December 2025
class NotificationBadge extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? iconColor;
  final double iconSize;

  const NotificationBadge({
    super.key,
    this.onTap,
    this.iconColor,
    this.iconSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final unreadCount = state is NotificationLoaded ? state.unreadCount : 0;

        return IconButton(
          onPressed: onTap,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: iconColor ?? colorScheme.onSurface,
                size: iconSize,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: _Badge(count: unreadCount),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// The badge showing the count.
class _Badge extends StatelessWidget {
  final int count;

  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayText = count > 99 ? '99+' : count.toString();

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkError : AppColors.error,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.surface, width: 1.5),
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: colorScheme.onError,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Simplified notification icon without BlocBuilder for non-authenticated screens.
class NotificationIconSimple extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;
  final Color? iconColor;

  const NotificationIconSimple({
    super.key,
    required this.count,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: iconColor ?? colorScheme.onSurface,
            size: 26,
          ),
          if (count > 0)
            Positioned(right: -4, top: -4, child: _Badge(count: count)),
        ],
      ),
    );
  }
}
