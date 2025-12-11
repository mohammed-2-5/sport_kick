import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/role_badge.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_info_row.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_status_badge.dart';
import 'package:spo_kick/features/super_admin/utils/user_card_utils.dart';

/// Admin card widget displaying field owner information.
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
              _buildHeader(context),
              const SizedBox(height: 12),
              UserInfoRow(
                icon: Icons.email_outlined,
                text: admin.email,
                iconColor: Colors.blue,
              ),
              if (admin.phone != null && admin.phone!.isNotEmpty) ...[
                const SizedBox(height: 8),
                UserInfoRow(
                  icon: Icons.phone_outlined,
                  text: admin.phone!,
                  iconColor: Colors.green,
                ),
              ],
              const SizedBox(height: 8),
              UserInfoRow(
                icon: Icons.calendar_today_outlined,
                text: 'Joined ${formatRelativeDate(admin.createdAt)}',
                iconColor: Colors.grey,
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            getInitials(admin.fullName),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
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
              RoleBadge(isSuperAdmin: admin.role == 'super_admin'),
            ],
          ),
        ),
        UserStatusBadge(isActive: admin.isActive),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
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
    );
  }
}
