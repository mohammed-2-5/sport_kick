import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';

/// Premium admin card for super admin management.
///
/// Features:
/// - PremiumCard container
/// - Avatar with gold border for admins
/// - Admin info (name, email, phone)
/// - Status badge
/// - Assigned fields count
/// - Revenue display
/// - Selectable mode for bulk actions
/// - Action buttons
class PremiumAdminCard extends StatelessWidget {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final bool isActive;
  final DateTime? createdAt;
  final int fieldsCount;
  final double? revenue;
  final bool isSelected;
  final bool isSelectable;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onAssignField;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onSelectionChanged;

  const PremiumAdminCard({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.imageUrl,
    required this.isActive,
    this.createdAt,
    this.fieldsCount = 0,
    this.revenue,
    this.isSelected = false,
    this.isSelectable = false,
    this.onTap,
    this.onToggleStatus,
    this.onAssignField,
    this.onDelete,
    this.onSelectionChanged,
  });

  String get _initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'A';
  }

  @override
  Widget build(BuildContext context) {
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
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.border,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Avatar with gold border for admin
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.premiumGold,
                          AppColors.premiumGoldDark,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.premiumSurface,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _initials,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.premiumGold,
                          ),
                        ),
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
                        color: isActive ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Admin info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Admin badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.premiumGold,
                                AppColors.premiumGoldDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'ADMIN',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
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
                icon: Icons.sports_soccer,
                label: '$fieldsCount fields',
                color: AppColors.accentCyan,
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.attach_money,
                label: '${revenue?.toStringAsFixed(0) ?? '0'} EGP',
                color: Colors.green,
              ),
              if (phone != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _StatChip(
                    icon: Icons.phone,
                    label: phone!,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),

          // Action buttons (if not selectable)
          if (!isSelectable &&
              (onAssignField != null ||
                  onToggleStatus != null ||
                  onDelete != null)) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (onAssignField != null)
                  Expanded(
                    child: _ActionButton(
                      label: 'Assign Field',
                      icon: Icons.add_circle_outline,
                      color: AppColors.accentCyan,
                      onTap: onAssignField!,
                    ),
                  ),
                if (onAssignField != null &&
                    (onToggleStatus != null || onDelete != null))
                  const SizedBox(width: 8),
                if (onToggleStatus != null)
                  Expanded(
                    child: _ActionButton(
                      label: isActive ? 'Deactivate' : 'Activate',
                      icon: isActive ? Icons.block : Icons.check_circle_outline,
                      color: isActive ? Colors.orange : Colors.green,
                      onTap: onToggleStatus!,
                    ),
                  ),
                if (onToggleStatus != null && onDelete != null)
                  const SizedBox(width: 8),
                if (onDelete != null)
                  Expanded(
                    child: _ActionButton(
                      label: 'Delete',
                      icon: Icons.delete_outline,
                      color: Colors.red,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}

/// Stat chip widget.
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
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
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
