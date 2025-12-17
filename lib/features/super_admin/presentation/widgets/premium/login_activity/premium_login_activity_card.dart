import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';

/// Premium card for displaying login activity.
///
/// Shows:
/// - Device icon and type
/// - IP address with copy
/// - Location
/// - Timestamp
/// - Status badge
class PremiumLoginActivityCard extends StatelessWidget {
  final LoginActivityEntity activity;
  final String? userName;
  final String? userRole;
  final VoidCallback? onTap;

  const PremiumLoginActivityCard({
    required this.activity,
    this.userName,
    this.userRole,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildDetails(context),
                const SizedBox(height: 12),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _DeviceIcon(deviceType: activity.deviceType),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userName != null)
                Text(
                  userName!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              Text(
                activity.deviceName ?? activity.deviceType.displayName,
                style: TextStyle(
                  fontSize: 14,
                  color: userName != null
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                  fontWeight: userName != null
                      ? FontWeight.w500
                      : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        _StatusBadge(status: activity.status),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (activity.ipAddress != null)
            _DetailRow(
              icon: Icons.language_rounded,
              label: 'IP Address',
              value: activity.ipAddress!,
              onCopy: () => _copyToClipboard(context, activity.ipAddress!),
            ),
          if (activity.location != null) ...[
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.location_on_rounded,
              label: 'Location',
              value: activity.location!,
            ),
          ],
          if (userRole != null) ...[
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.person_rounded,
              label: 'Role',
              value: _formatRole(userRole!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 4),
            Text(
              _formatTimestamp(activity.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        if (activity.isCurrentSession)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Current Session',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.accentCyan,
              ),
            ),
          ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  String _formatRole(String role) {
    return role
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Device type icon widget.
class _DeviceIcon extends StatelessWidget {
  final DeviceType deviceType;

  const _DeviceIcon({required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(_getIcon(), color: Colors.white, size: 22),
    );
  }

  IconData _getIcon() {
    switch (deviceType) {
      case DeviceType.mobile:
        return Icons.phone_android_rounded;
      case DeviceType.web:
        return Icons.language_rounded;
      case DeviceType.desktop:
        return Icons.computer_rounded;
    }
  }

  List<Color> _getGradientColors() {
    switch (deviceType) {
      case DeviceType.mobile:
        return const [Color(0xFF6366F1), Color(0xFF8B5CF6)];
      case DeviceType.web:
        return const [Color(0xFF3B82F6), Color(0xFF1D4ED8)];
      case DeviceType.desktop:
        return const [Color(0xFF10B981), Color(0xFF059669)];
    }
  }
}

/// Status badge widget.
class _StatusBadge extends StatelessWidget {
  final LoginStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _getColor(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getColor(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case LoginStatus.success:
        return const Color(0xFF10B981);
      case LoginStatus.failed:
        return const Color(0xFFEF4444);
      case LoginStatus.blocked:
        return const Color(0xFFF59E0B);
    }
  }
}

/// Detail row widget.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (onCopy != null)
          GestureDetector(
            onTap: onCopy,
            child: const Icon(
              Icons.copy_rounded,
              size: 16,
              color: AppColors.accentCyan,
            ),
          ),
      ],
    );
  }
}
