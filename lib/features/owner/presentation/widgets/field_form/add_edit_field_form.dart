import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_facilities_selector.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_dropdown.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_section_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_text_field.dart';

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
          const FieldFormSectionHeader(
            title: 'Basic Information',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 16),

          FieldFormTextField(
            controller: nameController,
            label: 'Field Name',
            hint: 'e.g., Premium Soccer Field',
            icon: Icons.sports_soccer_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter field name';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          FieldFormTextField(
            controller: descriptionController,
            label: 'Description',
            hint: 'Describe your field...',
            icon: Icons.description_outlined,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Location Section
          const FieldFormSectionHeader(
            title: 'Location',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),

          FieldFormTextField(
            controller: addressController,
            label: 'Address',
            hint: 'Street address',
            icon: Icons.home_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter address';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          FieldFormTextField(
            controller: cityController,
            label: 'City',
            hint: 'e.g., Los Angeles',
            icon: Icons.location_city_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter city';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Field Details Section
          const FieldFormSectionHeader(
            title: 'Field Details',
            icon: Icons.settings_outlined,
          ),
          const SizedBox(height: 16),

          FieldFormDropdown(
            label: 'Field Size',
            value: selectedSize,
            items: OwnerConstants.fieldSizes,
            icon: Icons.straighten_rounded,
            onChanged: onSizeChanged,
          ),

          const SizedBox(height: 16),

          FieldFormDropdown(
            label: 'Surface Type',
            value: selectedSurface,
            items: OwnerConstants.surfaceTypes,
            icon: Icons.grass_rounded,
            onChanged: onSurfaceChanged,
          ),

          const SizedBox(height: 16),

          FieldFormDropdown(
            label: 'Field Type',
            value: selectedType,
            items: OwnerConstants.fieldTypes,
            icon: Icons.wb_sunny_outlined,
            onChanged: onTypeChanged,
          ),

          const SizedBox(height: 24),

          // Pricing Section
          const FieldFormSectionHeader(
            title: 'Pricing',
            icon: Icons.attach_money_rounded,
          ),
          const SizedBox(height: 16),

          FieldFormTextField(
            controller: priceController,
            label: 'Price per Hour',
            hint: 'e.g., 50',
            icon: Icons.payments_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Facilities Section
          const FieldFormSectionHeader(
            title: 'Facilities',
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
            const FieldFormSectionHeader(
              title: 'Business Hours',
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manage Business Hours',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Set working hours for each day of the week',
                            style: TextStyle(
                              fontSize: 13,
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
            text: 'Update Field',
            onPressed: onSave,
            variant: ButtonVariant.primary,
            icon: Icons.check_rounded,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
