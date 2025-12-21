import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/payment_method.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Card displaying payment information with phone number and instructions.
class PaymentInfoCard extends StatelessWidget {
  final FieldEntity field;

  const PaymentInfoCard({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: _getPaymentMethodGradient(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPaymentMethodIcon(),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.paymentMethod.displayName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.sendPaymentToNumber,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Phone Number
          if (field.paymentPhone != null && field.paymentPhone!.isNotEmpty)
            GestureDetector(
              onTap: () => _copyPhoneNumber(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.phone_android_rounded,
                        color: AppColors.accentCyan,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.paymentPhone,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            field.paymentPhone!,
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.copy_rounded,
                            size: 16,
                            color: AppColors.accentCyan,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.copy,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n.paymentPhoneMissing,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Payment Instructions
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.info,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.paymentInstructions,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  field.effectivePaymentInstructions,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon() {
    switch (field.paymentMethod) {
      case PaymentMethod.vodafoneCash:
        return Icons.phone_android_rounded;
      case PaymentMethod.instapay:
        return Icons.account_balance_rounded;
    }
  }

  LinearGradient _getPaymentMethodGradient() {
    switch (field.paymentMethod) {
      case PaymentMethod.vodafoneCash:
        return const LinearGradient(
          colors: [Color(0xFFE60000), Color(0xFFCC0000)], // Vodafone red
        );
      case PaymentMethod.instapay:
        return const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF0F1E32)], // InstaPay dark blue
        );
    }
  }

  void _copyPhoneNumber(BuildContext context) {
    if (field.paymentPhone != null) {
      Clipboard.setData(ClipboardData(text: field.paymentPhone!));
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.phoneCopied(field.paymentPhone!)),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
