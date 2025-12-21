import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/premium/premium_review_form.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/premium/review_success_overlay.dart';

import '../../../../../core/localization/l10n_extensions.dart';

/// Premium create review view with enhanced UI.
///
/// Features:
/// - Premium form styling
/// - Loading overlay
/// - Success animation
class PremiumCreateReviewView extends StatefulWidget {
  final String fieldName;
  final bool isEditing;

  const PremiumCreateReviewView({
    super.key,
    required this.fieldName,
    this.isEditing = false,
  });

  @override
  State<PremiumCreateReviewView> createState() =>
      _PremiumCreateReviewViewState();
}

class _PremiumCreateReviewViewState extends State<PremiumCreateReviewView> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    // Load initial comment if editing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ReviewFormCubit>().state;
      if (state is ReviewFormInitial && state.comment.isNotEmpty) {
        _commentController.text = state.comment;
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewFormCubit, ReviewFormState>(
      listener: (context, state) {
        if (state is ReviewFormSuccess) {
          setState(() => _showSuccess = true);
        }
      },
      builder: (context, state) {
        if (state is ReviewFormSubmitting) {
          return LoadingIndicator.inline(
            message: context.l10n.submittingReview,
          );
        }

        if (_showSuccess) {
          return ReviewSuccessOverlay(
            isEdit: widget.isEditing,
            onDone: () => Navigator.pop(context, true),
          );
        }

        int currentRating = 0;
        if (state is ReviewFormInitial) {
          currentRating = state.rating;
        } else if (state is ReviewFormValid) {
          currentRating = state.rating;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: PremiumReviewForm(
            formKey: _formKey,
            commentController: _commentController,
            rating: currentRating,
            isSubmitting: state is ReviewFormSubmitting,
            isEditing: widget.isEditing,
            fieldName: widget.fieldName,
            onRatingChanged: (rating) {
              context.read<ReviewFormCubit>().updateRating(rating);
            },
            onSubmit: () {
              context.read<ReviewFormCubit>().updateComment(
                _commentController.text,
              );
              context.read<ReviewFormCubit>().submit(
                errorRating: context.l10n.selectRating,
                errorLogin: context.l10n.youMustBeLoggedInToReview,
              );
            },
          ),
        );
      },
    );
  }
}
