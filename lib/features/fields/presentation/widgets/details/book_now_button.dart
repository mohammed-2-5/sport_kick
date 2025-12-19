import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Bottom Book Now Button widget.
///
/// Displays a fixed button at the bottom of the screen
/// for booking the field.
class BookNowButton extends StatelessWidget {
  final FieldEntity field;

  const BookNowButton({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: context.l10n.bookNow,
          onPressed: () {
            // Navigate to create booking page
            context.pushNamed('createBooking', extra: field);
          },
          icon: Icons.event_available,
        ),
      ),
    );
  }
}
