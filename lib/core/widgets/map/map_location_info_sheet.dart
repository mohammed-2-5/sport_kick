import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/map_location_picker_constants.dart';
import 'package:spo_kick/core/models/location_data.dart';

/// Bottom sheet displaying selected location information and confirmation button.
///
/// Shows:
/// - Drag handle for visual feedback
/// - Selected address with location icon
/// - Latitude/longitude coordinates
/// - Confirm button to finalize selection
/// - Loading state while geocoding address
class MapLocationInfoSheet extends StatelessWidget {
  /// The currently selected location, or null if none selected.
  final LocationData? location;

  /// Whether the location is being loaded (geocoding in progress).
  final bool isLoading;

  /// Callback invoked when user taps confirm button.
  final VoidCallback onConfirm;

  const MapLocationInfoSheet({
    super.key,
    required this.location,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MapLocationPickerConstants.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(MapLocationPickerConstants.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDragHandle(),
            const SizedBox(height: 16),
            _buildLocationContent(),
            const SizedBox(height: 16),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the drag handle indicator at the top of the sheet.
  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.disabled,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  /// Builds the location information content (address and coordinates).
  Widget _buildLocationContent() {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (location == null) {
      return const SizedBox.shrink();
    }

    return _buildLocationInfo();
  }

  /// Builds the loading indicator.
  Widget _buildLoadingState() {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  /// Builds the location information display with icon, address, and coordinates.
  Widget _buildLocationInfo() {
    return Row(
      children: [
        _buildLocationIcon(),
        const SizedBox(width: 12),
        Expanded(child: _buildLocationDetails()),
      ],
    );
  }

  /// Builds the icon container for the location.
  Widget _buildLocationIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: AppColors.cyanGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.location_on, color: Colors.white, size: 20),
    );
  }

  /// Builds the text details (address and coordinates).
  Widget _buildLocationDetails() {
    final mainAddress = location!.address.split(',').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mainAddress,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          location!.coordinatesString,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  /// Builds the confirm button, disabled while loading.
  Widget _buildConfirmButton() {
    final isEnabled = location != null && !isLoading;

    return ElevatedButton(
      onPressed: isEnabled ? onConfirm : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentCyan,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: const Text(
        MapLocationPickerConstants.confirmButton,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
