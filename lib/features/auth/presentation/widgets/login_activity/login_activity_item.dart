import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';

import '../../../../../l10n/app_localizations.dart';

/// Login Activity Item Widget
///
/// Displays a single login activity entry with device info,
/// timestamp, location, and status.
class LoginActivityItem extends StatelessWidget {
  final LoginActivityEntity activity;

  const LoginActivityItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: activity.isCurrentSession
            ? Border.all(color: AppColors.success, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _DeviceIcon(
              deviceType: activity.deviceType,
              status: activity.status,
            ),
            const SizedBox(width: 16),
            Expanded(child: _ActivityDetails(activity: activity)),
            _StatusBadge(status: activity.status),
          ],
        ),
      ),
    );
  }
}

/// Device icon widget.
class _DeviceIcon extends StatelessWidget {
  final DeviceType deviceType;
  final LoginStatus status;

  const _DeviceIcon({required this.deviceType, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(_getIcon(), color: _getIconColor(), size: 24),
    );
  }

  IconData _getIcon() {
    switch (deviceType) {
      case DeviceType.mobile:
        return Icons.phone_android;
      case DeviceType.web:
        return Icons.language;
      case DeviceType.desktop:
        return Icons.computer;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case LoginStatus.success:
        return AppColors.success.withValues(alpha: 0.1);
      case LoginStatus.failed:
        return Colors.red.withValues(alpha: 0.1);
      case LoginStatus.blocked:
        return Colors.orange.withValues(alpha: 0.1);
    }
  }

  Color _getIconColor() {
    switch (status) {
      case LoginStatus.success:
        return AppColors.success;
      case LoginStatus.failed:
        return Colors.red;
      case LoginStatus.blocked:
        return Colors.orange;
    }
  }
}

/// Activity details widget.
class _ActivityDetails extends StatelessWidget {
  final LoginActivityEntity activity;

  const _ActivityDetails({required this.activity});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              activity.deviceName ?? _deviceLabel(context, activity.deviceType),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (activity.isCurrentSession) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.currentSession,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _formatTimestamp(context, activity.timestamp),
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
        if (activity.location != null) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Text(
                activity.location!,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _deviceLabel(BuildContext context, DeviceType type) {
    final l10n = context.l10n;
    switch (type) {
      case DeviceType.mobile:
        return l10n.deviceTypeMobile;
      case DeviceType.web:
        return l10n.deviceTypeWeb;
      case DeviceType.desktop:
        return l10n.deviceTypeDesktop;
    }
  }

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    } else if (difference.inHours < 1) {
      return l10n.minutesAgo(difference.inMinutes);
    } else if (difference.inDays < 1) {
      return l10n.hoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else {
      final locale = Localizations.localeOf(context).toString();
      final date = DateFormat.yMMMd(locale).format(timestamp);
      final time = DateFormat.Hm(locale).format(timestamp);
      return l10n.loginDateTimeFormat(date, time);
    }
  }
}

/// Status badge widget.
class _StatusBadge extends StatelessWidget {
  final LoginStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _statusLabel(l10n),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getColor(),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case LoginStatus.success:
        return AppColors.success;
      case LoginStatus.failed:
        return Colors.red;
      case LoginStatus.blocked:
        return Colors.orange;
    }
  }

  String _statusLabel(AppLocalizations l10n) {
    switch (status) {
      case LoginStatus.success:
        return l10n.loginStatusSuccess;
      case LoginStatus.failed:
        return l10n.loginStatusFailed;
      case LoginStatus.blocked:
        return l10n.loginStatusBlocked;
    }
  }
}
