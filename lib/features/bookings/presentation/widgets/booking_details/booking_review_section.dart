import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/write_review_section.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/list/review_card.dart';

/// Widget for showing review section in booking details.
///
/// Shows:
/// - "Write Review" button for completed/verified bookings
/// - Existing review if user already reviewed
/// - Nothing if booking is not completed
class BookingReviewSection extends StatelessWidget {
  final BookingEntity booking;

  const BookingReviewSection({super.key, required this.booking});

  bool get _canShowReviewSection {
    // Only show for completed bookings or verified payments
    return booking.status == BookingStatus.completed ||
        booking.paymentStatus == PaymentStatus.verified;
  }

  @override
  Widget build(BuildContext context) {
    if (!_canShowReviewSection) {
      return const SizedBox.shrink();
    }

    final authState = context.read<AuthCubit>().state;
    if (authState is! Authenticated) {
      return const SizedBox.shrink();
    }

    final userId = authState.user.id;

    return BlocProvider(
      create: (context) => sl<ReviewsCubit>()
        ..loadFieldReviews(
          fieldId: booking.fieldId,
          limit: 100, // Load all to find user's review
        ),
      child: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          if (state is ReviewsLoading) {
            return const PremiumCard(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ReviewsLoaded) {
            // Check if user already reviewed this field
            final userReview = state.reviews
                .where((review) => review.userId == userId)
                .firstOrNull;

            if (userReview != null) {
              // User already reviewed - show their review
              return PremiumCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFFB74D)
                              : const Color(0xFFFFA000),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.yourReview,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ReviewCard(review: userReview),
                  ],
                ),
              );
            }

            // User hasn't reviewed yet - show write review button
            return WriteReviewSection(
              fieldId: booking.fieldId,
              fieldName: booking.fieldName,
              bookingId: booking.id,
            );
          }

          // Error or initial state - show write review button
          return WriteReviewSection(
            fieldId: booking.fieldId,
            fieldName: booking.fieldName,
            bookingId: booking.id,
          );
        },
      ),
    );
  }
}
