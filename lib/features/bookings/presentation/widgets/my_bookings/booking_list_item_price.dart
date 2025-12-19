import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';

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
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.totalPrice,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            priceText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
