import 'package:flutter/material.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

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
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.reviewing,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fieldName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
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
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
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
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: colorScheme.onSurface.withValues(
                  alpha: 0.12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isSubmitting
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
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
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
