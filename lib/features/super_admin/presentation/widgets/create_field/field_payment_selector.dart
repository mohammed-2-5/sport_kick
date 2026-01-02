import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/domain/entities/payment_method.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Widget for selecting payment method and entering payment phone.
///
/// Allows selection between Vodafone Cash and InstaPay with phone number input.
class FieldPaymentSelector extends StatelessWidget {
  final String? paymentPhone;
  final String paymentMethod;
  final ValueChanged<String?> onPhoneChanged;
  final ValueChanged<String> onMethodChanged;

  const FieldPaymentSelector({
    super.key,
    required this.paymentPhone,
    required this.paymentMethod,
    required this.onPhoneChanged,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment Method Selection
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _MethodOption(
                  method: PaymentMethod.vodafoneCash,
                  isSelected: paymentMethod == 'vodafone_cash',
                  onTap: () => onMethodChanged('vodafone_cash'),
                ),
              ),
              Expanded(
                child: _MethodOption(
                  method: PaymentMethod.instapay,
                  isSelected: paymentMethod == 'instapay',
                  onTap: () => onMethodChanged('instapay'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Phone Number Input
        TextFormField(
          initialValue: paymentPhone ?? '01068700814',
          onChanged: onPhoneChanged,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Payment Phone Number',
            hintText: context.l10n.phoneHint,
            prefixIcon: Icon(
              paymentMethod == context.l10n.vodafoneCash
                  ? Icons.phone_android_rounded
                  : Icons.account_balance_rounded,
              color: AppColors.accentCyan,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentCyan),
            ),
            helperText: paymentMethod == context.l10n.vodafoneCash
                ? context.l10n.vodafoneCashNumberForReceivingPayments
                : context.l10n.instapayNumberForReceivingTransfers,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Payment phone is required';
            }
            if (!RegExp(r'^01[0-9]{9}$').hasMatch(value)) {
              return 'Enter a valid Egyptian phone number';
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Individual payment method option.
class _MethodOption extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodOption({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? _getMethodColor() : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIcon(),
              size: 20,
              color: isSelected
                  ? Colors.white
                  : colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Text(
              method.displayName,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMethodColor() {
    return method == PaymentMethod.vodafoneCash
        ? const Color(0xFFE60000) // Vodafone red
        : const Color(0xFF1E3A5F); // InstaPay blue
  }

  IconData _getIcon() {
    return method == PaymentMethod.vodafoneCash
        ? Icons.phone_android_rounded
        : Icons.account_balance_rounded;
  }
}
