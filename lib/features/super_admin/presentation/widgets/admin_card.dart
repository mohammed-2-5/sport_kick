import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:intl/intl.dart';

/// Admin card widget displaying field owner information
///
/// Shows:
/// - Admin name and email
/// - Phone number
/// - Account status (active/inactive)
/// - Created date
/// - Role badge
class AdminCard extends StatelessWidget {
  final UserEntity admin;
  final VoidCallback? onTap;

  const AdminCard({super.key, required this.admin, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Name and Status
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      _getInitials(admin.fullName),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name and Role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          admin.fullName ?? admin.email,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        _buildRoleBadge(),
                      ],
                    ),
                  ),

                  // Status Badge
                  _buildStatusBadge(),
                ],
              ),

              const SizedBox(height: 12),

              // Email
              _buildInfoRow(Icons.email_outlined, admin.email, Colors.blue),

              // Phone (if available)
              if (admin.phone != null && admin.phone!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow(Icons.phone_outlined, admin.phone!, Colors.green),
              ],

              // Created Date
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                'Joined ${_formatDate(admin.createdAt)}',
                Colors.grey,
              ),

              // Actions Row
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('View Details'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.add_business, size: 18),
                      label: const Text('Assign Field'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge() {
    final isSuper = admin.role == 'super_admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSuper
            ? Colors.deepPurple.withValues(alpha: 0.1)
            : Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuper ? Icons.verified_user : Icons.admin_panel_settings,
            size: 12,
            color: isSuper ? Colors.deepPurple : Colors.purple,
          ),
          const SizedBox(width: 4),
          Text(
            isSuper ? 'Super Admin' : 'Field Owner',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSuper ? Colors.deepPurple : Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isActive = admin.isActive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
}
