import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Form widget for editing field details.
///
/// Contains all input fields for updating field information.
class EditFieldForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final TextEditingController priceController;
  final String selectedSize;
  final String selectedSurface;
  final bool isActive;
  final List<String> selectedFacilities;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<String> onSurfaceChanged;
  final ValueChanged<bool> onActiveChanged;
  final ValueChanged<String> onFacilityToggled;

  const EditFieldForm({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.addressController,
    required this.priceController,
    required this.selectedSize,
    required this.selectedSurface,
    required this.isActive,
    required this.selectedFacilities,
    required this.onSizeChanged,
    required this.onSurfaceChanged,
    required this.onActiveChanged,
    required this.onFacilityToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context.l10n.basicInformation),
        const SizedBox(height: 12),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: context.l10n.enterFieldName,
            hintText: context.l10n.enterFieldName,
            prefixIcon: const Icon(Icons.sports_soccer),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.l10n.enterFieldName;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: context.l10n.description,
            hintText: context.l10n.enterDescription,
            prefixIcon: const Icon(Icons.description),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: context.l10n.location,
            hintText: context.l10n.enterAddress,
            prefixIcon: const Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.l10n.enterAddress;
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildSectionTitle(context.l10n.price),
        const SizedBox(height: 12),
        TextFormField(
          controller: priceController,
          decoration: InputDecoration(
            labelText: context.l10n.pricePerHour,
            hintText: context.l10n.enterPrice,
            prefixIcon: const Icon(Icons.attach_money),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.enterPrice;
            }
            final price = double.tryParse(value);
            if (price == null || price <= 0) {
              return context.l10n.enterValidNumber;
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildSectionTitle(context.l10n.fieldDetails),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: selectedSize,
          decoration: InputDecoration(
            labelText: context.l10n.fieldSize,
            prefixIcon: const Icon(Icons.people_outline),
          ),
          items: OwnerConstants.fieldSizes.map((size) {
            return DropdownMenuItem(value: size, child: Text(size));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onSizeChanged(value);
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: selectedSurface,
          decoration: InputDecoration(
            labelText: context.l10n.surfaceType,
            prefixIcon: const Icon(Icons.grass),
          ),
          items: OwnerConstants.surfaceTypes.map((surface) {
            return DropdownMenuItem(
              value: surface,
              child: Text(_facilityLabel(context, surface)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onSurfaceChanged(value);
            }
          },
        ),
        const SizedBox(height: 24),
        _buildSectionTitle(context.l10n.facilities),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: OwnerConstants.facilities.map((facility) {
            final isSelected = selectedFacilities.contains(facility);
            return FilterChip(
              label: Text(_facilityLabel(context, facility)),
              selected: isSelected,
              onSelected: (_) => onFacilityToggled(facility),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle(context.l10n.bookingStatus),
        const SizedBox(height: 12),
        SwitchListTile(
          title: Text(context.l10n.fieldActive),
          subtitle: Text(
            isActive
                ? context.l10n.fieldVisibleToCustomers
                : context.l10n.fieldHiddenFromCustomers,
          ),
          value: isActive,
          onChanged: onActiveChanged,
          activeTrackColor: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  String _facilityLabel(BuildContext context, String facility) {
    switch (facility) {
      case 'Parking':
        return context.l10n.parking;
      case 'Changing Room':
        return context.l10n.changingRooms;
      case 'Shower':
        return context.l10n.showers;
      case 'Cafeteria':
        return context.l10n.cafeteria;
      case 'WiFi':
        return context.l10n.wifi;
      case 'Lighting':
        return context.l10n.lighting;
      case 'Natural Grass':
        return context.l10n.surfaceGrass;
      case 'Artificial Turf':
        return context.l10n.surfaceTurf;
      case 'Hybrid':
        return context.l10n.surfaceHybrid;
      default:
        return facility;
    }
  }
}
