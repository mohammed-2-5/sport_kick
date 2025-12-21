import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium owner profile card.
///
/// Features:
/// - PremiumCard container
/// - Profile image with gradient border
/// - Owner info
/// - Stats row
/// - Edit button
class PremiumOwnerProfileCard extends StatelessWidget {
  final String name;
  final String? email;
  final String? phone;
  final String? imageUrl;
  final int fieldsCount;
  final int bookingsCount;
  final VoidCallback? onEdit;

  const PremiumOwnerProfileCard({
    super.key,
    required this.name,
    this.email,
    this.phone,
    this.imageUrl,
    required this.fieldsCount,
    required this.bookingsCount,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        children: [
          // Profile image
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: imageUrl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl!,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                _InitialsAvatar(name: name),
                            errorWidget: (context, url, error) =>
                                _InitialsAvatar(name: name),
                          ),
                        )
                      : _InitialsAvatar(name: name),
                ),
              ),
              if (onEdit != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.accentCyan,
                            AppColors.accentCyanDark,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentCyan.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            name,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Email
          if (email != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  size: 14,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  email!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          // Phone
          if (phone != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  size: 14,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  phone!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Stats
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: context.l10n.fields,
                  value: '$fieldsCount',
                  icon: Icons.sports_soccer,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.border),
              Expanded(
                child: _StatItem(
                  label: context.l10n.bookings,
                  value: '$bookingsCount',
                  icon: Icons.calendar_month,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Initials avatar fallback.
class _InitialsAvatar extends StatelessWidget {
  final String name;

  const _InitialsAvatar({required this.name});

  String get _initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.accentCyan, AppColors.accentCyanDark],
        ),
      ),
      child: Center(
        child: Text(
          _initials,
          style: AppTextStyles.displaySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Stat item widget.
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.accentCyan),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
