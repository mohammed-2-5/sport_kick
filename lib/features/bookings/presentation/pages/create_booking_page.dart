import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking_view.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Page for creating a new booking.
///
/// Allows users to:
/// - Select a date
/// - View available time slots
/// - Select a time slot
/// - Confirm booking
class CreateBookingPage extends StatelessWidget {
  final FieldEntity field;

  const CreateBookingPage({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingCubit>()..startBookingFlow(field.id),
      child: CreateBookingView(field: field),
    );
  }
}
