import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';

/// Facilities display widget for field card.
///
/// Shows up to 3 facility chips with colored gradients and icons.
/// Each facility has a unique color scheme for better visual distinction.
class FieldCardFacilities extends StatelessWidget {
  /// List of facility names to display
  final List<String> facilities;

  /// Maximum number of facilities to show (default: 3)
  final int maxFacilities;

  const FieldCardFacilities({
    super.key,
    required this.facilities,
    this.maxFacilities = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (facilities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: facilities
          .take(maxFacilities)
          .map((facility) => _buildFacilityChip(context, facility))
          .toList(),
    );
  }

  /// Builds a single facility chip with gradient background and icon
  Widget _buildFacilityChip(BuildContext context, String facility) {
    final facilityGradients = _getFacilityGradients();
    final gradient =
        facilityGradients[facility] ??
        [AppColors.primary, AppColors.primaryLight];
    final displayName = FacilityLocalizer.localize(context, facility);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.3),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getFacilityIcon(facility), size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns gradient colors for each facility type
  Map<String, List<Color>> _getFacilityGradients() {
    return {
      'Parking': [const Color(0xFF5C6BC0), const Color(0xFF7986CB)],
      'Changing Room': [const Color(0xFF26A69A), const Color(0xFF4DB6AC)],
      'Shower': [const Color(0xFF42A5F5), const Color(0xFF64B5F6)],
      'Cafeteria': [const Color(0xFFFF7043), const Color(0xFFFF8A65)],
      'WiFi': [const Color(0xFFAB47BC), const Color(0xFFBA68C8)],
      'Lighting': [const Color(0xFFFFA726), const Color(0xFFFFB74D)],
    };
  }

  /// Returns the appropriate icon for each facility type
  IconData _getFacilityIcon(String facility) {
    switch (facility) {
      case 'Parking':
        return Icons.local_parking_rounded;
      case 'Changing Room':
        return Icons.checkroom_rounded;
      case 'Shower':
        return Icons.shower_rounded;
      case 'Cafeteria':
        return Icons.restaurant_rounded;
      case 'WiFi':
        return Icons.wifi_rounded;
      case 'Lighting':
        return Icons.lightbulb_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }
}
