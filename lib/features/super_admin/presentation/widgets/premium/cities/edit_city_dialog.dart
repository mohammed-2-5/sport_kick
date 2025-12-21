import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Dialog for editing an existing city.
///
/// Features:
/// - Pre-filled data from existing city
/// - Premium glassmorphic design
/// - Name editing with validation
/// - Active status toggle
class EditCityDialog extends StatefulWidget {
  final CityEntity city;
  final void Function(String name, bool isActive) onSubmit;

  const EditCityDialog({super.key, required this.city, required this.onSubmit});

  /// Show the edit city dialog.
  static Future<void> show({
    required BuildContext context,
    required CityEntity city,
    required void Function(String name, bool isActive) onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditCityDialog(city: city, onSubmit: onSubmit),
    );
  }

  @override
  State<EditCityDialog> createState() => _EditCityDialogState();
}

class _EditCityDialogState extends State<EditCityDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late bool _isActive;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.city.name);
    _isActive = widget.city.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newName = _nameController.text.trim();
      // Check if anything changed
      if (newName == widget.city.name && _isActive == widget.city.isActive) {
        Navigator.of(context).pop();
        return;
      }
      setState(() => _isSubmitting = true);
      Navigator.of(context).pop();
      widget.onSubmit(newName, _isActive);
    }
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildHeader(), _buildContent(), _buildActions()],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.info, AppColors.accentCyan],
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
              Icons.edit_location_alt_rounded,
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
                  context.l10n.editCity,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.editingCity(widget.city.name),
                  style: AppTextStyles.labelMedium.copyWith(
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
          Text(
            context.l10n.cityName,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: context.l10n.enterCityName,
              prefixIcon: const Icon(
                Icons.location_city,
                color: AppColors.mediumGrey,
              ),
              filled: true,
              fillColor: AppColors.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.accentCyan,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.pleaseEnterACityName;
              }
              if (value.trim().length < 2) {
                return context.l10n.cityNameMustBeAtLeast2Characters;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isActive ? Icons.visibility : Icons.visibility_off,
                  color: _isActive ? AppColors.success : AppColors.mediumGrey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.activeStatus,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _isActive
                            ? context.l10n.cityIsVisibleToUsers
                            : context.l10n.cityIsHiddenFromUsers,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                  activeTrackColor: AppColors.successLight,
                  thumbColor: WidgetStatePropertyAll(
                    _isActive ? AppColors.success : AppColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // City info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.cityFieldsRegisteredCount(
                      widget.city.fieldsCount,
                    ),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              onPressed: _isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(),
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
              onPressed: _isSubmitting ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.info,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      context.l10n.saveChanges,
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
