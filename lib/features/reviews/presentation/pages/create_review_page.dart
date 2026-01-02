import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_state.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/create/create_review_body.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Page for creating or editing a review.
///
/// Uses [ReviewFormCubit] for form state management.
class CreateReviewPage extends StatelessWidget {
  final String fieldId;
  final String fieldName;
  final String? bookingId;
  final int? existingRating;
  final String? existingComment;
  final String? reviewId;

  const CreateReviewPage({
    required this.fieldId,
    required this.fieldName,
    this.bookingId,
    this.existingRating,
    this.existingComment,
    this.reviewId,
    super.key,
  });

  bool get _isEditing => reviewId != null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : null;

    return BlocProvider(
      create: (context) => ReviewFormCubit(
        reviewsCubit: sl<ReviewsCubit>(),
        fieldId: fieldId,
        bookingId: bookingId,
        reviewId: reviewId,
        userId: userId,
        initialRating: existingRating,
        initialComment: existingComment,
      ),
      child: BlocListener<ReviewFormCubit, ReviewFormState>(
        listener: (context, state) => _handleStateChange(context, state),
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          body: Column(
            children: [
              PremiumCurvedHeader(
                title: _isEditing
                    ? context.l10n.editReview
                    : context.l10n.writeAReview,
                subtitle: fieldName,
                showBackButton: true,
                height: 180,
              ),
              const Expanded(child: CreateReviewBody()),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, ReviewFormState state) {
    if (state is ReviewFormSuccess) {
      SnackbarHelper.showSuccess(
        context,
        state.isEdit
            ? 'Review updated successfully'
            : 'Review submitted successfully',
      );
      Navigator.pop(context, true);
    } else if (state is ReviewFormError) {
      SnackbarHelper.showError(context, state.message);
    }
  }
}
