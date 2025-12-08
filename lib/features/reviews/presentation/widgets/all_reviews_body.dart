import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/reviews_header.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/reviews_list_content.dart';

/// Body content for all reviews page.
///
/// Displays reviews header and list based on state.
class AllReviewsBody extends StatelessWidget {
  final String fieldId;
  final String fieldName;
  final double? averageRating;

  const AllReviewsBody({
    super.key,
    required this.fieldId,
    required this.fieldName,
    this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return const LoadingIndicator.inline(message: 'Loading reviews...');
        }

        if (state is ReviewsError) {
          return EmptyStates.error(
            message: state.message,
            onRetry: () =>
                context.read<ReviewsCubit>().loadFieldReviews(fieldId: fieldId),
          );
        }

        if (state is ReviewsLoaded) {
          if (state.reviews.isEmpty) {
            return EmptyStates.noReviews(
              onWrite: () {
                // Navigate to create review
              },
            );
          }

          return Column(
            children: [
              ReviewsHeader(
                fieldName: fieldName,
                averageRating: averageRating,
                totalReviews: state.reviews.length,
              ),
              Expanded(
                child: ReviewsListContent(
                  fieldId: fieldId,
                  fieldName: fieldName,
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
