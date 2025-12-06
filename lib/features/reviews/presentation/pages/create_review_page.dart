import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/create_review_form.dart';

/// Page for creating or editing a review.
class CreateReviewPage extends StatefulWidget {
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

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.existingRating ?? 0;
    _commentController.text = widget.existingComment ?? '';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.reviewId != null;

  void _handleRatingChanged(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    if (_rating == 0) {
      SnackbarHelper.showError(context, 'Please select a rating');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final authState = context.read<AuthCubit>().state;
    if (authState is! Authenticated) {
      SnackbarHelper.showError(context, 'You must be logged in to review');
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    final userId = authState.user.id;
    final comment = _commentController.text.trim().isEmpty
        ? null
        : _commentController.text.trim();

    if (_isEditing) {
      await context.read<ReviewsCubit>().updateReview(
        reviewId: widget.reviewId!,
        rating: _rating,
        comment: comment,
      );
    } else {
      await context.read<ReviewsCubit>().createReview(
        fieldId: widget.fieldId,
        userId: userId,
        bookingId: widget.bookingId,
        rating: _rating,
        comment: comment,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Review' : 'Write a Review'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ReviewsCubit, ReviewsState>(
        listener: (context, state) {
          if (state is ReviewCreated || state is ReviewUpdated) {
            SnackbarHelper.showSuccess(
              context,
              _isEditing
                  ? 'Review updated successfully'
                  : 'Review submitted successfully',
            );
            Navigator.pop(context, true); // Return true to indicate success
          } else if (state is ReviewsError) {
            setState(() {
              _isSubmitting = false;
            });
            SnackbarHelper.showError(context, state.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: CreateReviewForm(
            formKey: _formKey,
            commentController: _commentController,
            rating: _rating,
            isSubmitting: _isSubmitting,
            isEditing: _isEditing,
            fieldName: widget.fieldName,
            onRatingChanged: _handleRatingChanged,
            onSubmit: _submitReview,
          ),
        ),
      ),
    );
  }
}
