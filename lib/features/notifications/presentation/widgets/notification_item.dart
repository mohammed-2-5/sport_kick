import 'package:flutter/material.dart';

import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/notifications/domain/entities/notification_entity.dart';
import 'package:spo_kick/features/notifications/presentation/widgets/notification_tile.dart';

/// Individual notification item with swipe to dismiss.
///
/// Wraps NotificationTile with Dismissible for swipe actions.
/// Updated: December 2025
class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDismiss(),
      child: NotificationTile(notification: notification, onTap: onTap),
    );
  }
}
