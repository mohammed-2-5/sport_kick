import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';

/// Header section for owner profile page.
///
/// Displays avatar, name, email, and role badge.
class OwnerProfileHeader extends StatelessWidget {
  final dynamic user;

  const OwnerProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with gradient border
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGradients.warning,
            boxShadow: [
              BoxShadow(
                color: AppColors.warning.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      user.avatarUrl!,
                      width: 112,
                      height: 112,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildInitials();
                      },
                    ),
                  )
                : _buildInitials(),
          ),
        ),

        const SizedBox(height: 16),

        // Full Name
        Text(
          user.displayName,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 4),

        // Email
        Text(
          user.email,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),

        const SizedBox(height: 12),

        // Role Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: AppGradients.warning,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.warning.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.business_center_rounded,
                size: 16,
                color: Colors.white,
              ),
              SizedBox(width: 6),
              Text(
                'FIELD OWNER',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInitials() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.warning.withValues(alpha: 0.1),
            AppColors.warning.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.warning,
          ),
        ),
      ),
    );
  }
}
