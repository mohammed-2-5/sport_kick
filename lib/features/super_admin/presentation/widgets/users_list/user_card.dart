import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_card_actions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_card_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_info_row.dart';
import 'package:spo_kick/features/super_admin/utils/user_card_utils.dart';

/// User card widget displaying customer information.
class UserCard extends StatelessWidget {
  final UserEntity user;
  final VoidCallback? onTap;

  const UserCard({super.key, required this.user, this.onTap});

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
              UserCardHeader(
                name: user.fullName ?? user.email,
                initials: getInitials(user.fullName),
                statusBadge: null,
              ),
              const SizedBox(height: 12),
              UserInfoRow(
                icon: Icons.email_outlined,
                text: user.email,
                iconColor: Colors.blue,
              ),
              if (user.phone != null && user.phone!.isNotEmpty) ...[
                const SizedBox(height: 8),
                UserInfoRow(
                  icon: Icons.phone_outlined,
                  text: user.phone!,
                  iconColor: AppColors.success,
                ),
              ],
              const SizedBox(height: 8),
              UserInfoRow(
                icon: Icons.calendar_today_outlined,
                text: 'Joined ${formatRelativeDate(user.createdAt)}',
                iconColor: Colors.grey,
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              UserCardActions(onViewDetails: onTap, onViewBookings: onTap),
            ],
          ),
        ),
      ),
    );
  }
}
