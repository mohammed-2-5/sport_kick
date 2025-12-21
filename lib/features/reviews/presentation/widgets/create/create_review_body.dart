import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/rating/star_rating_input.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
              Text(
                context.l10n.howWouldYouRateThisField,
                style: AppTextStyles.titleMedium,
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
              Text(
                context.l10n.shareYourExperienceOptional,
                style: AppTextStyles.labelLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: cubit.comment,
                onChanged: cubit.updateComment,
                maxLines: 5,
                enabled: !isSubmitting,
                decoration: InputDecoration(
                  hintText: context.l10n.tellOthersAboutYourExperience,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit button
              PremiumButton(
                label: cubit.isEditing
                    ? context.l10n.updateReview
                    : context.l10n.submitReview,
                onPressed: isSubmitting
                    ? null
                    : () => cubit.submit(
                        errorRating: context.l10n.selectRating,
                        errorLogin: context.l10n.youMustBeLoggedInToReview,
                      ),
                loading: isSubmitting,
              ),
            ],
          ),
        );
      },
    );
  }
}
