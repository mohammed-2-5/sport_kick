import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/constants/owner_ui_constants.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/booking_summary_row.dart';

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
              'Customer Information',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: OwnerUIConstants.spacingSmall),
            Text(
              'Enter customer details for walk-in booking',
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
                        'Booking Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                          fontSize: OwnerUIConstants.fontSizeLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: OwnerUIConstants.spacingMedium),
                  BookingSummaryRow(
                    label: 'Field',
                    value: selectedField?.name ?? '-',
                  ),
                  BookingSummaryRow(
                    label: 'Date',
                    value: selectedDate == null
                        ? '-'
                        : DateFormat('MMM d, y').format(selectedDate!),
                  ),
                  BookingSummaryRow(
                    label: 'Time',
                    value: '$selectedStartTime - $selectedEndTime',
                  ),
                  BookingSummaryRow(
                    label: 'Price',
                    value: 'EGP ${totalPrice?.toStringAsFixed(0) ?? '-'}',
                  ),
                ],
              ),
            ),

            const SizedBox(height: OwnerUIConstants.spacingLarge),

            // Customer name
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Customer Name *',
                hintText: 'Enter full name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    OwnerUIConstants.cardBorderRadiusSmall,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Customer name is required';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: OwnerUIConstants.spacingMedium),

            // Customer phone
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                hintText: '01XXXXXXXXX',
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
                  return 'Phone number is required';
                }
                final phoneRegex = RegExp(r'^01[0-2,5]\d{8}$');
                final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
                if (!phoneRegex.hasMatch(cleanPhone)) {
                  return 'Invalid Egyptian phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: OwnerUIConstants.spacingMedium),

            // Customer email (optional)
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email (Optional)',
                hintText: 'customer@example.com',
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
                    return 'Invalid email format';
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
                labelText: 'Notes (Optional)',
                hintText: 'Any special requests or notes...',
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
