import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Card displaying invoice and booking details.
class InvoiceDetailsCard extends StatelessWidget {
  final BookingEntity booking;
  final FieldEntity field;

  const InvoiceDetailsCard({
    super.key,
    required this.booking,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.invoiceDetails,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (booking.invoiceNumber != null)
                GestureDetector(
                  onTap: () =>
                      _copyToClipboard(context, booking.invoiceNumber!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          booking.invoiceNumber!,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentCyan,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: AppColors.accentCyan,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),

          // Field Name
          _DetailRow(
            icon: Icons.sports_soccer_rounded,
            label: context.l10n.field,
            value: field.name,
          ),
          const SizedBox(height: 12),

          // Date
          _DetailRow(
            icon: Icons.calendar_today_rounded,
            label: context.l10n.bookingDate,
            value: LocaleFormatters.formatDate(context, booking.date),
          ),
          const SizedBox(height: 12),

          // Time
          _DetailRow(
            icon: Icons.access_time_rounded,
            label: context.l10n.bookingTime,
            value: LocaleFormatters.formatTimeRange(
              context,
              startTime: booking.startTime,
              endTime: booking.endTime,
              baseDate: booking.date,
            ),
          ),
          const SizedBox(height: 12),

          // Duration
          _DetailRow(
            icon: Icons.timer_outlined,
            label: context.l10n.durationLabel,
            value: context.l10n.durationHours(booking.durationHours),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),

          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.totalAmount,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.cyanGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  LocaleFormatters.formatPrice(
                    context,
                    amount: booking.totalPrice,
                    currency: booking.currency,
                    decimalDigits: 0,
                  ),
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.invoiceCopied(text)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// A single detail row with icon, label, and value.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.textSecondary),
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
                ),
              ),
              const SizedBox(height: 2),
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
      ],
    );
  }
}
