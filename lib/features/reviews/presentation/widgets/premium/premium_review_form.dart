import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/premium/premium_star_rating_selector.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium review form with enhanced styling.
///
/// Features:
/// - Field info card
/// - Premium star rating selector
/// - Character counter for comment
/// - Submit button with loading state
class PremiumReviewForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController commentController;
  final int rating;
  final bool isSubmitting;
  final bool isEditing;
  final String fieldName;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;

  const PremiumReviewForm({
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
    final onSurfaceVariant = colorScheme.onSurfaceVariant;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field info card
          PremiumCard(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sports_soccer,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing
                            ? context.l10n.editingReviewFor
                            : context.l10n.reviewing,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fieldName,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Rating selector
          PremiumStarRatingSelector(
            initialRating: rating,
            onRatingChanged: onRatingChanged,
            label: context.l10n.yourRating,
            size: 44,
          ),

          const SizedBox(height: 32),

          // Comment field
          Text(
            context.l10n.yourReviewOptional,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.shareYourExperienceToHelpOthers,
            style: AppTextStyles.labelMedium.copyWith(color: onSurfaceVariant),
          ),
          const SizedBox(height: 12),

          _CommentField(controller: commentController),

          const SizedBox(height: 32),

          // Submit button
          PremiumButton(
            label: isEditing
                ? context.l10n.updateReview
                : context.l10n.submitReview,
            onPressed: rating > 0 ? onSubmit : null,
            loading: isSubmitting,
            fullWidth: true,
            icon: isEditing ? Icons.update : Icons.send,
          ),

          const SizedBox(height: 16),

          // Help text
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: onSurfaceVariant.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    isEditing
                        ? context.l10n.updateRatingPrompt
                        : 'Your review helps others find the best fields',
                    style: AppTextStyles.caption.copyWith(
                      color: onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
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

/// Comment text field with character counter.
class _CommentField extends StatefulWidget {
  final TextEditingController controller;

  const _CommentField({required this.controller});

  @override
  State<_CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<_CommentField> {
  static const int _maxLength = 1000;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surface = colorScheme.surface;
    final outline = colorScheme.outline;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final currentLength = widget.controller.text.length;
    final isNearLimit = currentLength > _maxLength * 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: outline, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            maxLines: 6,
            maxLength: _maxLength,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            decoration: InputDecoration(
              hintText: context.l10n.shareDetailsAboutYourExperience,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: onSurfaceVariant.withValues(alpha: 0.6),
                height: 1.5,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$currentLength / $_maxLength',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isNearLimit
                ? (currentLength >= _maxLength ? Colors.red : Colors.orange)
                : onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
