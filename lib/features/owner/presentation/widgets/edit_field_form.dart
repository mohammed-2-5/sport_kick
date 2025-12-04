import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';

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
        _buildSectionTitle('Basic Information'),
        const SizedBox(height: 12),
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Field Name',
            hintText: 'Enter field name',
            prefixIcon: Icon(Icons.sports_soccer),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter field name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            hintText: 'Enter field description',
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            hintText: 'Enter field address',
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter address';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Pricing'),
        const SizedBox(height: 12),
        TextFormField(
          controller: priceController,
          decoration: const InputDecoration(
            labelText: 'Price per Hour (EGP)',
            hintText: 'Enter price',
            prefixIcon: Icon(Icons.attach_money),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter price';
            }
            final price = double.tryParse(value);
            if (price == null || price <= 0) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Field Specifications'),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: selectedSize,
          decoration: const InputDecoration(
            labelText: 'Field Size',
            prefixIcon: Icon(Icons.people_outline),
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
          decoration: const InputDecoration(
            labelText: 'Surface Type',
            prefixIcon: Icon(Icons.grass),
          ),
          items: OwnerConstants.surfaceTypes.map((surface) {
            return DropdownMenuItem(value: surface, child: Text(surface));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onSurfaceChanged(value);
            }
          },
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Facilities'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: OwnerConstants.facilities.map((facility) {
            final isSelected = selectedFacilities.contains(facility);
            return FilterChip(
              label: Text(facility),
              selected: isSelected,
              onSelected: (_) => onFacilityToggled(facility),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Status'),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Field Active'),
          subtitle: Text(
            isActive
                ? 'Field is visible to customers'
                : 'Field is hidden from customers',
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}
