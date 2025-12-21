import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Header section for user/admin cards: avatar, name, optional status badge.
class UserCardHeader extends StatelessWidget {
  final String name;
  final String initials;
  final Widget? statusBadge;

  const UserCardHeader({
    super.key,
    required this.name,
    required this.initials,
    this.statusBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          child: Text(
            initials,
            style: AppTextStyles.bold(
              AppTextStyles.withColor(AppTextStyles.titleLarge, Colors.blue),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.titleMediumBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 12, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.customerName,
                      style: AppTextStyles.withColor(
                        AppTextStyles.labelSmallBold,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (statusBadge != null) statusBadge!,
      ],
    );
  }
}
