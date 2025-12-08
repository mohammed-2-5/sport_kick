import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/star_rating_input.dart';

/// Body content for create review page.
///
/// Contains star rating and comment input.
class CreateReviewBody extends StatelessWidget {
  const CreateReviewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewFormCubit, ReviewFormState>(
      builder: (context, state) {
        final cubit = context.read<ReviewFormCubit>();
        final isSubmitting = state is ReviewFormSubmitting;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Rating section
              const Text(
                'How would you rate this field?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              StarRatingInput(
                rating: cubit.rating,
                onRatingChanged: cubit.updateRating,
                enabled: !isSubmitting,
              ),

              const SizedBox(height: 32),

              // Comment section
              const Text(
                'Share your experience (optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: cubit.comment,
                onChanged: cubit.updateComment,
                maxLines: 5,
                enabled: !isSubmitting,
                decoration: InputDecoration(
                  hintText: 'Tell others about your experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit button
              PremiumButton(
                label: cubit.isEditing ? 'Update Review' : 'Submit Review',
                onPressed: isSubmitting ? null : () => cubit.submit(),
                loading: isSubmitting,
              ),
            ],
          ),
        );
      },
    );
  }
}
