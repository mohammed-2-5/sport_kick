import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/field_admin_selector.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/field_facilities_selector.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/field_form_dropdown.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/field_form_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/field_form_section_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/field_form_text_field.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/field_indoor_switch.dart';

/// Form body for creating a new field.
///
/// Contains all form fields organized into sections:
/// - Admin assignment
/// - Basic information
/// - Location
/// - Field details
/// - Pricing
/// - Facilities
class CreateFieldFormBody extends StatelessWidget {
  /// Form key for validation
  final GlobalKey<FormState> formKey;

  /// Controllers for text fields
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final TextEditingController priceController;

  /// Selected values
  final UserEntity? selectedAdmin;
  final String? selectedCity;
  final String? selectedSportCategory;
  final String selectedSize;
  final String selectedSurface;
  final bool isIndoor;
  final List<String> selectedFacilities;

  /// Available options
  final List<UserEntity> admins;
  final List<CityEntity> cities;
  final Map<String, String> sportCategories;
  final List<String> sizes;
  final List<String> surfaces;
  final List<String> availableFacilities;

  /// Loading states
  final bool isLoadingAdmins;
  final bool isLoadingCities;
  final bool isLoadingSportCategories;

  /// Callbacks
  final ValueChanged<UserEntity?> onAdminChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onSportCategoryChanged;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<String> onSurfaceChanged;
  final ValueChanged<bool> onIndoorChanged;
  final ValueChanged<List<String>> onFacilitiesChanged;
  final VoidCallback onSubmit;

  const CreateFieldFormBody({
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.addressController,
    required this.priceController,
    required this.selectedAdmin,
    required this.selectedCity,
    required this.selectedSportCategory,
    required this.selectedSize,
    required this.selectedSurface,
    required this.isIndoor,
    required this.selectedFacilities,
    required this.admins,
    required this.cities,
    required this.sportCategories,
    required this.sizes,
    required this.surfaces,
    required this.availableFacilities,
    required this.isLoadingAdmins,
    required this.isLoadingCities,
    required this.isLoadingSportCategories,
    required this.onAdminChanged,
    required this.onCityChanged,
    required this.onSportCategoryChanged,
    required this.onSizeChanged,
    required this.onSurfaceChanged,
    required this.onIndoorChanged,
    required this.onFacilitiesChanged,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const FieldFormHeader(),
          const SizedBox(height: 24),

          // Admin Assignment Section
          const FieldFormSectionHeader(
            title: 'Assign to Admin',
            icon: Icons.admin_panel_settings,
          ),
          const SizedBox(height: 12),
          FieldAdminSelector(
            selectedAdmin: selectedAdmin,
            admins: admins,
            isLoading: isLoadingAdmins,
            onChanged: onAdminChanged,
          ),

          const SizedBox(height: 24),

          // Basic Information Section
          const FieldFormSectionHeader(
            title: 'Basic Information',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 12),
          FieldFormTextField(
            controller: nameController,
            label: 'Field Name',
            hint: 'e.g., Champions Field',
            icon: Icons.sports_soccer,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          FieldFormTextField(
            controller: descriptionController,
            label: 'Description (Optional)',
            hint: 'Brief description',
            icon: Icons.description_outlined,
            maxLines: 3,
          ),

          const SizedBox(height: 24),

          // Location Section
          const FieldFormSectionHeader(
            title: 'Location',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          FieldFormTextField(
            controller: addressController,
            label: 'Address',
            hint: 'Street address',
            icon: Icons.home_outlined,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          FieldFormDropdown<String>(
            label: 'Select City',
            value: selectedCity,
            items: cities
                .map(
                  (city) =>
                      DropdownMenuItem(value: city.id, child: Text(city.name)),
                )
                .toList(),
            onChanged: onCityChanged,
            icon: Icons.location_city,
            isLoading: isLoadingCities,
            loadingText: 'Loading cities...',
            validator: (v) => v == null ? 'Please select a city' : null,
          ),
          const SizedBox(height: 16),
          FieldFormDropdown<String>(
            label: 'Select Sport Category',
            value: selectedSportCategory,
            items: sportCategories.keys
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: onSportCategoryChanged,
            icon: Icons.sports,
            isLoading: isLoadingSportCategories,
            loadingText: 'Loading categories...',
            validator: (v) => v == null ? 'Please select a category' : null,
          ),

          const SizedBox(height: 24),

          // Field Details Section
          const FieldFormSectionHeader(
            title: 'Field Details',
            icon: Icons.settings_outlined,
          ),
          const SizedBox(height: 12),
          FieldFormDropdown<String>(
            label: 'Field Size',
            value: selectedSize,
            items: sizes
                .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                .toList(),
            onChanged: (v) => onSizeChanged(v!),
            icon: Icons.straighten_rounded,
          ),
          const SizedBox(height: 16),
          FieldFormDropdown<String>(
            label: 'Surface Type',
            value: selectedSurface,
            items: surfaces
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => onSurfaceChanged(v!),
            icon: Icons.grass_rounded,
          ),
          const SizedBox(height: 16),
          FieldIndoorSwitch(value: isIndoor, onChanged: onIndoorChanged),

          const SizedBox(height: 24),

          // Pricing Section
          const FieldFormSectionHeader(
            title: 'Pricing',
            icon: Icons.monetization_on_outlined,
          ),
          const SizedBox(height: 12),
          FieldFormTextField(
            controller: priceController,
            label: 'Price per Hour (EGP)',
            hint: '200',
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (double.tryParse(v) == null) return 'Invalid number';
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Facilities Section
          const FieldFormSectionHeader(
            title: 'Facilities',
            icon: Icons.business_outlined,
          ),
          const SizedBox(height: 12),
          FieldFacilitiesSelector(
            selectedFacilities: selectedFacilities,
            availableFacilities: availableFacilities,
            onChanged: onFacilitiesChanged,
          ),

          const SizedBox(height: 32),

          // Submit Button
          CustomButton(
            text: 'Create Field',
            onPressed: onSubmit,
            icon: Icons.add_rounded,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
