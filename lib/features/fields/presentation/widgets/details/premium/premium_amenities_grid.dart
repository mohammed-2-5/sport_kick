import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium amenities/facilities grid with animations.
///
/// Features:
/// - Staggered entrance animations
/// - Icon-based facility cards
/// - Premium card styling
/// - Organized grid layout
class PremiumAmenitiesGrid extends StatelessWidget {
  final List<String> facilities;

  const PremiumAmenitiesGrid({super.key, required this.facilities});

  @override
  Widget build(BuildContext context) {
    if (facilities.isEmpty) {
      return const SizedBox.shrink();
    }

    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star_outline,
                color: AppColors.accentCyan,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.amenities,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          AnimationLimiter(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                facilities.length,
                (index) => AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: FadeInAnimation(
                      child: _AmenityCard(facility: facilities[index]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual amenity card.
class _AmenityCard extends StatelessWidget {
  final String facility;

  const _AmenityCard({required this.facility});

  @override
  Widget build(BuildContext context) {
    final icon = _getFacilityIcon(facility);
    final color = _getFacilityColor(facility);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Text(
            facility,
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFacilityIcon(String facility) {
    final lowerFacility = facility.toLowerCase();
    if (lowerFacility.contains('parking')) return Icons.local_parking;
    if (lowerFacility.contains('shower')) return Icons.shower;
    if (lowerFacility.contains('changing') ||
        lowerFacility.contains('locker')) {
      return Icons.checkroom;
    }
    if (lowerFacility.contains('light') || lowerFacility.contains('flood')) {
      return Icons.lightbulb;
    }
    if (lowerFacility.contains('cafe') || lowerFacility.contains('food')) {
      return Icons.restaurant;
    }
    if (lowerFacility.contains('air') || lowerFacility.contains('ac')) {
      return Icons.ac_unit;
    }
    if (lowerFacility.contains('wifi')) return Icons.wifi;
    if (lowerFacility.contains('seating') || lowerFacility.contains('bench')) {
      return Icons.chair;
    }
    if (lowerFacility.contains('water') || lowerFacility.contains('drink')) {
      return Icons.water_drop;
    }
    if (lowerFacility.contains('security') ||
        lowerFacility.contains('camera')) {
      return Icons.security;
    }
    return Icons.check_circle;
  }

  Color _getFacilityColor(String facility) {
    final lowerFacility = facility.toLowerCase();
    if (lowerFacility.contains('parking')) return AppColors.accentCyan;
    if (lowerFacility.contains('shower') ||
        lowerFacility.contains('changing')) {
      return Colors.blue;
    }
    if (lowerFacility.contains('light') || lowerFacility.contains('flood')) {
      return Colors.amber;
    }
    if (lowerFacility.contains('cafe') || lowerFacility.contains('food')) {
      return Colors.orange;
    }
    if (lowerFacility.contains('air') || lowerFacility.contains('ac')) {
      return Colors.cyan;
    }
    if (lowerFacility.contains('wifi')) return Colors.purple;
    if (lowerFacility.contains('security')) return Colors.red;
    return AppColors.success;
  }
}
