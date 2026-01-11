import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/models/time_slot_ui_model.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_booking_summary.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

class ManualBookingStepThree extends StatelessWidget {
  final AppLocalizations l10n;
  final FieldEntity? selectedField;
  final DateTime? selectedDate;
  final TimeSlotUiModel? selectedSlot;
  final String customerName;
  final String customerPhone;
  final String price;
  final String? notes;

  const ManualBookingStepThree({
    super.key,
    required this.l10n,
    required this.selectedField,
    required this.selectedDate,
    required this.selectedSlot,
    required this.customerName,
    required this.customerPhone,
    required this.price,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final localeName = l10n.localeName;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PremiumBookingSummary(
            fieldName: selectedField?.name ?? l10n.notSelected,
            date: selectedDate != null
                ? DateFormat.yMMMMEEEEd(localeName).format(selectedDate!)
                : l10n.notSelected,
            timeSlot: selectedSlot?.displayTime ?? l10n.notSelected,
            customerName: customerName.isEmpty ? l10n.notEntered : customerName,
            customerPhone: customerPhone.isEmpty ? null : customerPhone,
            price: '$price EGP',
            notes: notes,
          ),

          const SizedBox(height: 24),

          // Confirmation message
          PremiumCard(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.info_outline, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.bookingConfirmationMessage,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
