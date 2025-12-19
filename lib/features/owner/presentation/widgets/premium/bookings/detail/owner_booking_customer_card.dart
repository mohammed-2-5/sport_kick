import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Customer information card.
///
/// Updated: 2025-12-19
class OwnerBookingCustomerCard extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingCustomerCard({super.key, required this.booking});

  String get _customerName {
    return booking.customerName ?? booking.userName ?? '';
  }

  String? get _customerPhone => booking.customerPhone;

  String? get _customerEmail => booking.customerEmail;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_rounded,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  booking.isManual
                      ? context.l10n.walkInCustomer
                      : context.l10n.customerInformation,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (booking.isManual) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      context.l10n.manualBooking,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.badge_outlined,
              label: context.l10n.nameLabel,
              value: _customerName.isEmpty
                  ? context.l10n.unknownCustomer
                  : _customerName,
            ),
            if (_customerPhone != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: context.l10n.phone,
                value: _customerPhone!,
                onTap: () => _copyToClipboard(context, _customerPhone!),
              ),
            ],
            if (_customerEmail != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.email_outlined,
                label: context.l10n.email,
                value: _customerEmail!,
              ),
            ],
            if (_customerPhone == null && _customerEmail == null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.info_outline,
                label: context.l10n.contact,
                value: context.l10n.noContactInfoAvailable,
              ),
            ],
            // Show admin information for manual bookings
            if (booking.isManual && booking.createdByName != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.navyDeep.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.navyDeep.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.admin_panel_settings,
                          color: AppColors.navyDeep,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.createdBy,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.navyDeep,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: context.l10n.admin,
                      value: booking.createdByName!,
                    ),
                    if (booking.createdByEmail != null) ...[
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.email_outlined,
                        label: context.l10n.email,
                        value: booking.createdByEmail!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.copyValueMessage(text)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.accentCyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.accentCyan, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.copy_rounded,
            size: 18,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: content,
      );
    }

    return content;
  }
}
