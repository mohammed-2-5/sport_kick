import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Dialog for confirming city deletion.
///
/// Features:
/// - Premium design with warning styling
/// - Option for soft delete (deactivate) or hard delete
/// - Shows warning about associated fields
class DeleteCityDialog extends StatefulWidget {
  final CityEntity city;
  final void Function(bool hardDelete) onConfirm;

  const DeleteCityDialog({
    super.key,
    required this.city,
    required this.onConfirm,
  });

  /// Show the delete city confirmation dialog.
  static Future<void> show({
    required BuildContext context,
    required CityEntity city,
    required void Function(bool hardDelete) onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteCityDialog(city: city, onConfirm: onConfirm),
    );
  }

  @override
  State<DeleteCityDialog> createState() => _DeleteCityDialogState();
}

class _DeleteCityDialogState extends State<DeleteCityDialog> {
  bool _hardDelete = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildHeader(), _buildContent(), _buildActions()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.error, Color(0xFFDC6A5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.deleteCity,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.city.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.warning,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.thisActionMayBeIrreversible,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.cityFieldsAssociatedCount(
                          widget.city.fieldsCount,
                        ),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Deactivate option
          _buildDeleteOption(
            title: context.l10n.deactivateCity,
            subtitle: context.l10n.hideThisCityFromUsersCanBeReactivatedLat,
            icon: Icons.visibility_off_outlined,
            isSelected: !_hardDelete,
            onTap: () => setState(() => _hardDelete = false),
          ),
          const SizedBox(height: 12),
          // Permanent delete option
          _buildDeleteOption(
            title: context.l10n.permanentDelete,
            subtitle: context.l10n.removeCityFromDatabaseCannotBeUndone,
            icon: Icons.delete_forever,
            isSelected: _hardDelete,
            isDangerous: true,
            disabled: widget.city.fieldsCount > 0,
            onTap: widget.city.fieldsCount > 0
                ? null
                : () => setState(() => _hardDelete = true),
          ),
          if (widget.city.fieldsCount > 0 && _hardDelete == false)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.permanentDeleteIsDisabledForCities,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeleteOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    bool isDangerous = false,
    bool disabled = false,
    VoidCallback? onTap,
  }) {
    final color = isDangerous ? AppColors.error : AppColors.warning;
    final effectiveColor = disabled ? AppColors.mediumGrey : color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? effectiveColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? effectiveColor
                  : AppColors.border.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: effectiveColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: disabled
                            ? AppColors.mediumGrey
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: disabled
                            ? AppColors.mediumGrey
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: effectiveColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.l10n.cancel,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onConfirm(_hardDelete);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _hardDelete
                    ? AppColors.error
                    : AppColors.warning,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _hardDelete
                    ? context.l10n.deleteForever
                    : context.l10n.deactivate,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
