import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/constants/owner_ui_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/booking_summary_row.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';

/// Step 2 of manual booking flow: Customer Information
///
/// Handles entry of:
/// - Customer Name
/// - Phone Number
/// - Email (Optional)
/// - Notes (Optional)
///
/// Also displays a summary of the booking details from Step 1.
class BookingStepTwoWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController notesController;

  // Summary data
  final FieldEntity? selectedField;
  final DateTime? selectedDate;
  final String? selectedStartTime;
  final String? selectedEndTime;
  final double? totalPrice;

  const BookingStepTwoWidget({
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.notesController,
    required this.selectedField,
    required this.selectedDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.totalPrice,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(OwnerUIConstants.spacingMedium),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.customerInfoTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: OwnerUIConstants.spacingSmall),
            Text(
              context.l10n.enterCustomerDetails,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: OwnerUIConstants.spacingLarge),

            // Booking summary card
            Container(
              padding: const EdgeInsets.all(OwnerUIConstants.spacingMedium),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(
                  OwnerUIConstants.cardBorderRadiusSmall,
                ),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: OwnerUIConstants.spacingSmall),
                      Text(
                        context.l10n.bookingSummary,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: OwnerUIConstants.spacingMedium),
                  BookingSummaryRow(
                    label: context.l10n.fieldLabel,
                    value: selectedField?.name ?? '-',
                  ),
                  BookingSummaryRow(
                    label: context.l10n.bookingDate,
                    value: selectedDate == null
                        ? '-'
                        : DateFormat(
                            'MMM d, y',
                            context.l10n.localeName,
                          ).format(selectedDate!),
                  ),
                  BookingSummaryRow(
                    label: context.l10n.timeSlot,
                    value: '$selectedStartTime - $selectedEndTime',
                  ),
                  BookingSummaryRow(
                    label: context.l10n.priceLabel,
                    value: totalPrice == null
                        ? '-'
                        : LocaleFormatters.formatPrice(
                            context,
                            amount: totalPrice!,
                            currency: context.l10n.currencyEgp,
                            decimalDigits: 0,
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: OwnerUIConstants.spacingLarge),

            // Customer name
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: context.l10n.customerNameLabel,
                hintText: context.l10n.enterFullName,
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    OwnerUIConstants.cardBorderRadiusSmall,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.customerNameRequired;
                }
                if (value.trim().length < 2) {
                  return context.l10n.customerNameTooShort;
                }
                return null;
              },
            ),

            const SizedBox(height: OwnerUIConstants.spacingMedium),

            // Customer phone
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: context.l10n.phoneLabel,
                hintText: context.l10n.phoneHint,
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    OwnerUIConstants.cardBorderRadiusSmall,
                  ),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.phoneRequired;
                }
                final phoneRegex = RegExp(r'^01[0-2,5]\d{8}$');
                final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
                if (!phoneRegex.hasMatch(cleanPhone)) {
                  return context.l10n.invalidEgyPhone;
                }
                return null;
              },
            ),

            const SizedBox(height: OwnerUIConstants.spacingMedium),

            // Customer email (optional)
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: context.l10n.emailLabel,
                hintText: context.l10n.emailHint,
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    OwnerUIConstants.cardBorderRadiusSmall,
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return context.l10n.invalidEmailFormat;
                  }
                }
                return null;
              },
            ),

            const SizedBox(height: OwnerUIConstants.spacingMedium),

            // Notes (optional)
            TextFormField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: context.l10n.notesLabel,
                hintText: context.l10n.notesHint,
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    OwnerUIConstants.cardBorderRadiusSmall,
                  ),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: OwnerUIConstants.spacingLarge),
          ],
        ),
      ),
    );
  }
}
