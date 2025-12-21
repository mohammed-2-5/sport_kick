import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium location card with map preview.
///
/// Features:
/// - Address display
/// - Phone number with call action
/// - Map preview (static for now)
/// - Get Directions button
/// - Premium card styling
class PremiumLocationCard extends StatelessWidget {
  final FieldEntity field;

  const PremiumLocationCard({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.accentCyan,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.location,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Address
          _InfoRow(
            icon: Icons.place_outlined,
            label: context.l10n.searchTipAddressTitle,
            value: field.address,
          ),

          const SizedBox(height: 16),

          const SizedBox(height: 20),

          // Map Preview Placeholder
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Map placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: AppColors.backgroundLight,
                    child: Center(
                      child: Icon(
                        Icons.map,
                        size: 64,
                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),

                // Map marker
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentCyan.withValues(alpha: 0.5),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Get Directions Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: field.hasLocation
                  ? () => _openMaps(
                      context,
                      field.latitude!,
                      field.longitude!,
                      field.address,
                    )
                  : () => _openMapsByAddress(context, field.address),
              icon: const Icon(Icons.directions, size: 20),
              label: Text(
                context.l10n.getDirections,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMaps(
    BuildContext context,
    double latitude,
    double longitude,
    String address,
  ) async {
    // Try Google Maps with coordinates first
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to address-based search
        if (context.mounted) {
          await _openMapsByAddress(context, address);
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, context.l10n.homeErrorOpenMaps);
      }
    }
  }

  Future<void> _openMapsByAddress(BuildContext context, String address) async {
    final query = Uri.encodeComponent(address);
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          SnackbarHelper.showError(context, context.l10n.homeErrorOpenMaps);
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, context.l10n.homeErrorOpenMaps);
      }
    }
  }
}

/// Info row widget.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentCyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.accentCyan),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
