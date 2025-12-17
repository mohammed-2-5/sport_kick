import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/notifications/domain/entities/notification_entity.dart';

/// A tile widget displaying a single notification.
///
/// Shows notification title, body, time, and read status.
/// Updated: December 2025
class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead
          ? AppColors.premiumBackground
          : AppColors.premiumSurface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.premiumBorder.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationIcon(type: notification.type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TitleRow(
                      title: notification.title,
                      isRead: notification.isRead,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14,
                        color: notification.isRead
                            ? AppColors.textSecondary.withValues(alpha: 0.7)
                            : AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _TimeStamp(createdAt: notification.createdAt),
                  ],
                ),
              ),
              if (!notification.isRead) _UnreadIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon based on notification type.
class _NotificationIcon extends StatelessWidget {
  final NotificationType type;

  const _NotificationIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(_icon, color: _iconColor, size: 22),
    );
  }

  IconData get _icon {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.review:
        return Icons.star;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  Color get _iconColor {
    switch (type) {
      case NotificationType.booking:
        return AppColors.accentCyan;
      case NotificationType.payment:
        return AppColors.success;
      case NotificationType.review:
        return Colors.amber;
      case NotificationType.system:
        return AppColors.textSecondary;
    }
  }

  Color get _backgroundColor {
    return _iconColor.withValues(alpha: 0.15);
  }
}

/// Title row with unread indicator.
class _TitleRow extends StatelessWidget {
  final String title;
  final bool isRead;

  const _TitleRow({required this.title, required this.isRead});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
        color: isRead
            ? AppColors.textPrimary.withValues(alpha: 0.7)
            : AppColors.textPrimary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Timestamp display with relative time.
class _TimeStamp extends StatelessWidget {
  final DateTime createdAt;

  const _TimeStamp({required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(createdAt),
      style: TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary.withValues(alpha: 0.6),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }
}

/// Unread indicator dot.
class _UnreadIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: AppColors.accentCyan,
        shape: BoxShape.circle,
      ),
    );
  }
}
