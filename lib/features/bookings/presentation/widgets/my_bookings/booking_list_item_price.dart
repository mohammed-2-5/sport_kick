import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Price container widget displaying total booking price.
class BookingListItemPrice extends StatelessWidget {
  final String formattedPrice;
  final double? amount;
  final String? currency;

  const BookingListItemPrice({
    super.key,
    required this.formattedPrice,
    this.amount,
    this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priceText = amount != null && currency != null
        ? LocaleFormatters.formatPrice(
            context,
            amount: amount!,
            currency: currency!,
            decimalDigits: 0,
          )
        : formattedPrice;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.totalPrice,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Text(
            priceText,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
