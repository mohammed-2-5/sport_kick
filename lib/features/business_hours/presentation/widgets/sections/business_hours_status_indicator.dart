import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';

/// Status indicator widget showing if field is currently open or closed.
///
/// Displays a card with icon, status text, and description message
/// indicating whether the field is currently accepting bookings.
class BusinessHoursStatusIndicator extends StatelessWidget {
  /// Whether the field is currently open
  final bool isOpen;

  const BusinessHoursStatusIndicator({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isOpen
          ? AppColors.success.withValues(alpha: 0.1)
          : AppColors.error.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(BusinessHoursConstants.cardPadding),
        child: Row(
          children: [
            Icon(
              isOpen ? Icons.check_circle : Icons.cancel,
              color: isOpen ? AppColors.success : AppColors.error,
              size: 32,
            ),
            const SizedBox(width: BusinessHoursConstants.itemSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isOpen
                        ? context.l10n.businessHoursCurrentlyOpen
                        : context.l10n.businessHoursCurrentlyClosed,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isOpen ? AppColors.success : AppColors.error,
                    ),
                  ),
                  const SizedBox(height: BusinessHoursConstants.tinySpacing),
                  Text(
                    isOpen
                        ? context.l10n.businessHoursAcceptingBookings
                        : context.l10n.businessHoursClosedForBookings,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
