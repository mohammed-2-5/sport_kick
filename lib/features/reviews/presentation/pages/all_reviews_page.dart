import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/reviews_header.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/reviews_list_content.dart';

/// Page displaying all reviews for a specific field.
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (_) => sl<ReviewsCubit>()..loadFieldReviews(fieldId: fieldId),
        child: Column(
          children: [
            // Header with field info and stats
            ReviewsHeader(
              fieldName: fieldName,
              averageRating: averageRating,
              totalReviews: totalReviews,
            ),

            // Reviews list
            Expanded(
              child: ReviewsListContent(fieldId: fieldId, fieldName: fieldName),
            ),
          ],
        ),
      ),
    );
  }
}
