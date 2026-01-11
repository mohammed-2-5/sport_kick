import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_card/components/admin_card_action_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_card/components/admin_card_stat_chip.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_card/components/admin_card_status_badge.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

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
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: colorScheme.onPrimary,
                          )
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
                        color: isActive
                            ? successColor
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
                              color: colorScheme.onSurface,
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
                            context.l10n.admin,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Status badge
              AdminCardStatusBadge(isActive: isActive),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              AdminCardStatChip(
                icon: Icons.sports_soccer,
                label: context.l10n.fieldsCount(fieldsCount),
                color: AppColors.accentCyan,
              ),
              const SizedBox(width: 12),
              AdminCardStatChip(
                icon: Icons.attach_money,
                label: LocaleFormatters.formatPrice(
                  context,
                  amount: revenue ?? 0,
                  currency: context.l10n.currencyEgp,
                  decimalDigits: 0,
                ),
                color: successColor,
              ),
              if (phone != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: AdminCardStatChip(
                    icon: Icons.phone,
                    label: phone!,
                    color: colorScheme.secondary,
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
                    child: AdminCardActionButton(
                      label: context.l10n.assignField,
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
                    child: AdminCardActionButton(
                      label: isActive
                          ? context.l10n.deactivate
                          : context.l10n.activate,
                      icon: isActive ? Icons.block : Icons.check_circle_outline,
                      color: isActive
                          ? (isDark ? AppColors.darkWarning : AppColors.warning)
                          : successColor,
                      onTap: onToggleStatus!,
                    ),
                  ),
                if (onToggleStatus != null && onDelete != null)
                  const SizedBox(width: 8),
                if (onDelete != null)
                  Expanded(
                    child: AdminCardActionButton(
                      label: context.l10n.delete,
                      icon: Icons.delete_outline,
                      color: isDark ? AppColors.darkError : AppColors.error,
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
