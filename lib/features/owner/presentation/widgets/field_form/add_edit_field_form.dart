import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_facilities_selector.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_dropdown.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_section_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_text_field.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

class AddEditFieldForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController priceController;
  final String selectedSize;
  final String selectedSurface;
  final String selectedType;
  final List<String> selectedFacilities;
  final String title;
  final String subtitle;
  final VoidCallback onSave;
  final VoidCallback? onManageBusinessHours;
  final ValueChanged<String?> onSizeChanged;
  final ValueChanged<String?> onSurfaceChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String> onFacilityToggled;

  const AddEditFieldForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.addressController,
    required this.cityController,
    required this.priceController,
    required this.selectedSize,
    required this.selectedSurface,
    required this.selectedType,
    required this.selectedFacilities,
    required this.title,
    required this.subtitle,
    required this.onSave,
    this.onManageBusinessHours,
    required this.onSizeChanged,
    required this.onSurfaceChanged,
    required this.onTypeChanged,
    required this.onFacilityToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          FieldFormHeader(title: title, subtitle: subtitle),

          const SizedBox(height: 24),

          // Basic Information Section
          FieldFormSectionHeader(
            title: context.l10n.basicInformation,
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 16),

          FieldFormTextField(
            controller: nameController,
            label: context.l10n.enterFieldName,
            hint: context.l10n.fieldNameExample,
            icon: Icons.sports_soccer_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.enterFieldName;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          FieldFormTextField(
            controller: descriptionController,
            label: context.l10n.description,
            hint: context.l10n.enterDescription,
            icon: Icons.description_outlined,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.enterDescription;
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Location Section
          FieldFormSectionHeader(
            title: context.l10n.location,
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),

          FieldFormTextField(
            controller: addressController,
            label: context.l10n.location, // Address uses location/address key
            hint: context.l10n.enterAddress,
            icon: Icons.home_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.enterAddress;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          FieldFormTextField(
            controller: cityController,
            label: context.l10n.city,
            hint: context.l10n.enterCity,
            icon: Icons.location_city_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.enterCity;
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Field Details Section
          FieldFormSectionHeader(
            title: context.l10n.fieldDetails,
            icon: Icons.settings_outlined,
          ),
          const SizedBox(height: 16),

          FieldFormDropdown(
            label: context.l10n.fieldSize,
            value: selectedSize,
            items: OwnerConstants.fieldSizes,
            icon: Icons.straighten_rounded,
            onChanged: onSizeChanged,
          ),

          const SizedBox(height: 16),

          FieldFormDropdown(
            label: context.l10n.surfaceType,
            value: selectedSurface,
            items: OwnerConstants.surfaceTypes,
            itemLabelBuilder: (item) => _getLocalizedSurface(context, item),
            icon: Icons.grass_rounded,
            onChanged: onSurfaceChanged,
          ),

          const SizedBox(height: 16),

          FieldFormDropdown(
            label: context.l10n.fieldType,
            value: selectedType,
            items: OwnerConstants.fieldTypes,
            itemLabelBuilder: (item) => _getLocalizedFieldType(context, item),
            icon: Icons.wb_sunny_outlined,
            onChanged: onTypeChanged,
          ),

          const SizedBox(height: 24),

          // Pricing Section
          FieldFormSectionHeader(
            title: context.l10n.price,
            icon: Icons.attach_money_rounded,
          ),
          const SizedBox(height: 16),

          FieldFormTextField(
            controller: priceController,
            label: context.l10n.pricePerHour,
            hint: context.l10n.enterPrice,
            icon: Icons.payments_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.enterPrice;
              }
              if (double.tryParse(value) == null) {
                return context.l10n.enterValidNumber;
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Facilities Section
          FieldFormSectionHeader(
            title: context.l10n.facilities,
            icon: Icons.widgets_outlined,
          ),
          const SizedBox(height: 16),

          FieldFacilitiesSelector(
            selectedFacilities: selectedFacilities,
            onFacilityToggled: onFacilityToggled,
          ),

          const SizedBox(height: 24),

          // Business Hours Section
          if (onManageBusinessHours != null) ...[
            FieldFormSectionHeader(
              title: context.l10n.businessHours,
              icon: Icons.schedule_rounded,
            ),
            const SizedBox(height: 16),
            PremiumCard(
              onTap: onManageBusinessHours,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.schedule_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.manageBusinessHours,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.setWorkingHoursDesc,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          const SizedBox(height: 8),

          // Save Button
          CustomButton(
            text: context.l10n.updateField,
            onPressed: onSave,
            variant: ButtonVariant.primary,
            icon: Icons.check_rounded,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getLocalizedSurface(BuildContext context, String surface) {
    if (surface == 'Natural Grass') return context.l10n.surfaceGrass;
    if (surface == 'Artificial Turf') return context.l10n.surfaceTurf;
    if (surface == 'Hybrid') return context.l10n.surfaceHybrid;
    return surface;
  }

  String _getLocalizedFieldType(BuildContext context, String type) {
    if (type == 'Outdoor') return context.l10n.outdoor;
    if (type == 'Indoor') return context.l10n.indoor;
    return type;
  }
}
