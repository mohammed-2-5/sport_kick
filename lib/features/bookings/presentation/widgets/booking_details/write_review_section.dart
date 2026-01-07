import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';

/// Widget displaying the "Write Review" section for completed bookings.
class WriteReviewSection extends StatelessWidget {
  final String fieldId;
  final String? fieldName;
  final String bookingId;

  const WriteReviewSection({
    super.key,
    required this.fieldId,
    this.fieldName,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final starColor = isDark
        ? const Color(0xFFFFB74D)
        : const Color(0xFFFFA000);

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: starColor),
              const SizedBox(width: 8),
              Text(
                context.l10n.rateYourExperience,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.helpOthersMakeInformedDecisions,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await context.pushNamed(
                  'createReview',
                  extra: {
                    'fieldId': fieldId,
                    'fieldName': fieldName ?? 'Field',
                    'bookingId': bookingId,
                  },
                );

                if (result == true && context.mounted) {
                  context.read<ReviewsCubit>().loadFieldReviews(
                    fieldId: fieldId,
                    limit: 100,
                  );
                }
              },
              icon: const Icon(Icons.rate_review),
              label: Text(context.l10n.writeReview),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
