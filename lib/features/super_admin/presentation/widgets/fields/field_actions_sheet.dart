import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Bottom sheet with action buttons for field management.
///
/// Provides options for:
/// - Edit field
/// - Verify/Unverify field
/// - Delete field
class FieldActionsSheet extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback onEdit;
  final VoidCallback onToggleVerify;
  final VoidCallback onDelete;

  const FieldActionsSheet({
    super.key,
    required this.field,
    required this.onEdit,
    required this.onToggleVerify,
    required this.onDelete,
  });

  /// Show the field actions bottom sheet.
  static void show({
    required BuildContext context,
    required FieldEntity field,
    required VoidCallback onEdit,
    required VoidCallback onToggleVerify,
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FieldActionsSheet(
        field: field,
        onEdit: () {
          Navigator.of(context).pop();
          onEdit();
        },
        onToggleVerify: () {
          Navigator.of(context).pop();
          onToggleVerify();
        },
        onDelete: () {
          Navigator.of(context).pop();
          onDelete();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const Divider(height: 1, color: AppColors.border),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary,
            ),
            child: field.images.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      field.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.sports_soccer,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.sports_soccer,
                    color: AppColors.white,
                    size: 28,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        field.name,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (field.isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              context.l10n.verified,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${field.city} • ${field.formattedPrice}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.edit,
            title: context.l10n.editField,
            subtitle: context.l10n.updateFieldDetailsPricingAndLocation,
            color: AppColors.info,
            onTap: onEdit,
          ),
          const SizedBox(height: 8),
          _buildActionTile(
            icon: field.isVerified ? Icons.verified_outlined : Icons.verified,
            title: field.isVerified
                ? context.l10n.removeVerification
                : context.l10n.verifyField,
            subtitle: field.isVerified
                ? context.l10n.removeVerifiedBadgeFromThisField
                : context.l10n.addVerifiedBadgeToThisField,
            color: AppColors.success,
            onTap: onToggleVerify,
          ),
          const SizedBox(height: 8),
          _buildActionTile(
            icon: Icons.delete,
            title: context.l10n.deleteField,
            subtitle: context.l10n.deactivateOrPermanentlyRemoveThisField,
            color: AppColors.error,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color.withValues(alpha: 0.7)),
            ],
          ),
        ),
      ),
    );
  }
}
