import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';

/// Premium booking summary card for manual booking.
///
/// Features:
/// - PremiumCard container
/// - Summary icon with gradient
/// - Key-value pairs for booking details
/// - Total price with gradient text
class PremiumBookingSummary extends StatelessWidget {
  final String fieldName;
  final String date;
  final String timeSlot;
  final String customerName;
  final String? customerPhone;
  final String price;
  final String? notes;

  const PremiumBookingSummary({
    super.key,
    required this.fieldName,
    required this.date,
    required this.timeSlot,
    required this.customerName,
    this.customerPhone,
    required this.price,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.summarize,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Booking Summary',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Details
          _SummaryRow(
            icon: Icons.sports_soccer,
            label: 'Field',
            value: fieldName,
          ),
          const SizedBox(height: 12),
          _SummaryRow(icon: Icons.calendar_today, label: 'Date', value: date),
          const SizedBox(height: 12),
          _SummaryRow(icon: Icons.access_time, label: 'Time', value: timeSlot),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Icons.person,
            label: 'Customer',
            value: customerName,
          ),
          if (customerPhone != null) ...[
            const SizedBox(height: 12),
            _SummaryRow(
              icon: Icons.phone,
              label: 'Phone',
              value: customerPhone!,
            ),
          ],
          if (notes != null && notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SummaryRow(icon: Icons.notes, label: 'Notes', value: notes!),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                ).createShader(bounds),
                child: Text(
                  price,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Summary row widget.
class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.accentCyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.accentCyan),
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
