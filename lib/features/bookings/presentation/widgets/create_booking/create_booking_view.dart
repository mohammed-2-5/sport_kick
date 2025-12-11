import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/create_booking_body.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Create Booking View - handles the main booking creation UI.
///
/// Uses [PremiumCurvedHeader] and delegates content to [CreateBookingBody].
class CreateBookingView extends StatelessWidget {
  final FieldEntity field;

  const CreateBookingView({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) => _handleStateChange(context, state),
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Column(
          children: [
            PremiumCurvedHeader(
              title: BookingConstants.bookFieldTitle,
              subtitle: field.name,
              showBackButton: true,
              height: 180,
            ),
            Expanded(child: CreateBookingBody(field: field)),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, BookingState state) {
    if (state is BookingError) {
      ErrorHandler.showErrorSnackbar(context, state.message);
    } else if (state is BookingCreated) {
      ErrorHandler.showSuccessSnackbar(
        context,
        BookingConstants.bookingConfirmedMessage,
      );
      context.goNamed('myBookings');
    }
  }
}
