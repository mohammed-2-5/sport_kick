import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/all_reviews_body.dart';

/// Page displaying all reviews for a specific field.
///
/// Uses [PremiumCurvedHeader] and [AllReviewsBody] for content.
class AllReviewsPage extends StatelessWidget {
  final String fieldId;
  final String fieldName;
  final double? averageRating;
  final int? totalReviews;

  const AllReviewsPage({
    required this.fieldId,
    required this.fieldName,
    this.averageRating,
    this.totalReviews,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReviewsCubit>()..loadFieldReviews(fieldId: fieldId),
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Column(
          children: [
            PremiumCurvedHeader(
              title: 'Reviews',
              subtitle: '$fieldName • ${totalReviews ?? 0} reviews',
              showBackButton: true,
              height: 180,
            ),
            Expanded(
              child: AllReviewsBody(
                fieldId: fieldId,
                fieldName: fieldName,
                averageRating: averageRating,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
