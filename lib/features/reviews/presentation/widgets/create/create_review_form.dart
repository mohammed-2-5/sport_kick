import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/rating/rating_selector.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class CreateReviewForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController commentController;
  final int rating;
  final bool isSubmitting;
  final bool isEditing;
  final String fieldName;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;

  const CreateReviewForm({
    super.key,
    required this.formKey,
    required this.commentController,
    required this.rating,
    required this.isSubmitting,
    required this.isEditing,
    required this.fieldName,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field name card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.reviewing,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fieldName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Rating selector
          RatingSelector(
            initialRating: rating,
            onRatingChanged: onRatingChanged,
            label: context.l10n.yourRating,
            size: 40,
          ),

          const SizedBox(height: 32),

          // Comment field
          Text(
            context.l10n.yourReviewOptional,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: commentController,
            maxLines: 6,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: context.l10n.shareYourExperienceWithThisField,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isEditing
                          ? context.l10n.updateReview
                          : context.l10n.submitReview,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Help text
          Center(
            child: Text(
              isEditing
                  ? context.l10n.youCanUpdateYourRatingAnd
                  : 'Your review will help other users choose the best field',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
