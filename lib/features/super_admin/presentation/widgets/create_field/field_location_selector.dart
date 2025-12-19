import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/models/location_data.dart';
import 'package:spo_kick/core/widgets/map/map_location_picker.dart';

/// Location selector with address field and map picker button.
///
/// Allows users to:
/// - Type address manually
/// - Pick location from map (stores lat/lng)
class FieldLocationSelector extends StatelessWidget {
  final TextEditingController addressController;
  final LocationData? selectedLocation;
  final ValueChanged<LocationData?> onLocationChanged;
  final String? Function(String?)? validator;

  const FieldLocationSelector({
    super.key,
    required this.addressController,
    required this.selectedLocation,
    required this.onLocationChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address text field with map button
        TextFormField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            hintText: 'Street address or select on map',
            prefixIcon: const Icon(Icons.location_on_outlined),
            suffixIcon: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.map_outlined,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
              ),
              onPressed: () => _openMapPicker(context),
              tooltip: 'Select on map',
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.disabled.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentCyan),
            ),
          ),
          validator: validator,
        ),

        // Show coordinates if location selected from map
        if (selectedLocation != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.gps_fixed,
                  size: 16,
                  color: AppColors.accentCyan,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'GPS: ${selectedLocation!.coordinatesString}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => onLocationChanged(null),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _openMapPicker(BuildContext context) async {
    final result = await MapLocationPicker.show(
      context,
      initialLocation: selectedLocation,
      title: 'Select Field Location',
    );

    if (result != null) {
      addressController.text = result.address.split(',').take(3).join(', ');
      onLocationChanged(result);
    }
  }
}
