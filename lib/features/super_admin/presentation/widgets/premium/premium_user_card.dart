import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';

/// Premium user card for super admin user management.
///
/// Features:
/// - PremiumCard container
/// - Avatar with status indicator
/// - User info (name, email, phone)
/// - Status badge
/// - Selectable mode for bulk actions
/// - Action buttons
class PremiumUserCard extends StatelessWidget {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final bool isActive;
  final DateTime? lastLoginAt;
  final int bookingsCount;
  final bool isSelected;
  final bool isSelectable;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onSelectionChanged;

  const PremiumUserCard({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.imageUrl,
    required this.isActive,
    this.lastLoginAt,
    this.bookingsCount = 0,
    this.isSelected = false,
    this.isSelectable = false,
    this.onTap,
    this.onToggleStatus,
    this.onDelete,
    this.onSelectionChanged,
  });

  String get _initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      onTap: onTap,
      borderColor: isSelected ? AppColors.premiumGold : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and selection
          Row(
            children: [
              // Selection checkbox
              if (isSelectable) ...[
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelectionChanged?.call(!isSelected);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                AppColors.premiumGold,
                                AppColors.premiumGoldDark,
                              ],
                            )
                          : null,
                      color: isSelected ? null : colorScheme.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : colorScheme.outline,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Avatar
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentCyan,
                          AppColors.accentCyanDark,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _initials,
                        style: AppTextStyles.titleMediumWhite,
                      ),
                    ),
                  ),
                  // Status indicator
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: isActive
                            ? colorScheme.success
                            : colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.bold(AppTextStyles.bodyLarge),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: AppTextStyles.bodySmallSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Status badge
              _StatusBadge(isActive: isActive),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              _StatChip(
                icon: Icons.calendar_month,
                label: context.l10n.bookingsCount(bookingsCount, bookingsCount),
              ),
              if (phone != null) ...[
                const SizedBox(width: 12),
                _StatChip(icon: Icons.phone, label: phone!),
              ],
            ],
          ),

          // Action buttons (if not selectable)
          if (!isSelectable &&
              (onToggleStatus != null || onDelete != null)) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (onToggleStatus != null)
                  Expanded(
                    child: _ActionButton(
                      label: isActive
                          ? context.l10n.deactivate
                          : context.l10n.activate,
                      icon: isActive ? Icons.block : Icons.check_circle_outline,
                      color: isActive
                          ? colorScheme.warning
                          : colorScheme.success,
                      onTap: onToggleStatus!,
                    ),
                  ),
                if (onToggleStatus != null && onDelete != null)
                  const SizedBox(width: 8),
                if (onDelete != null)
                  Expanded(
                    child: _ActionButton(
                      label: context.l10n.delete,
                      icon: Icons.delete_outline,
                      color: colorScheme.error,
                      onTap: onDelete!,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Status badge widget.
class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = isActive
        ? colorScheme.success
        : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? context.l10n.active : context.l10n.inactive,
        style: AppTextStyles.withColor(
          AppTextStyles.labelSmallBold,
          statusColor,
        ),
      ),
    );
  }
}

/// Stat chip widget.
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.withColor(
              AppTextStyles.labelSmall,
              colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action button widget.
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.withColor(
                AppTextStyles.labelSmallBold,
                color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
