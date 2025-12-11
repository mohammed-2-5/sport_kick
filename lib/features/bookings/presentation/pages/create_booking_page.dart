import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_booking_flow_view.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Page for creating a new booking with premium wizard UI.
///
/// Features a multi-step booking flow:
/// 1. Select Date - Horizontal date picker with time slot preview
/// 2. Choose Time - Premium time slot grid with animations
/// 3. Confirm - Summary with glassmorphism design
/// 4. Success - Animated confirmation overlay
class CreateBookingPage extends StatelessWidget {
  final FieldEntity field;

  const CreateBookingPage({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingFlowCubit>()..initializeFlow(field),
      child: PremiumBookingFlowView(field: field),
    );
  }
}
