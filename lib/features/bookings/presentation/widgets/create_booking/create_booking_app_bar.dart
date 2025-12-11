import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';

class CreateBookingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CreateBookingAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primary),
      ),
      title: const Text(
        BookingConstants.bookFieldTitle,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    );
  }
}
