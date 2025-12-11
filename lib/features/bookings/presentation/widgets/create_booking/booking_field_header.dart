import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/booking_field_details.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/booking_field_image.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Field header showing field image, name, location, and price.
///
/// Displays at the top of the create booking page to provide
/// context about which field is being booked.
class BookingFieldHeader extends StatelessWidget {
  final FieldEntity field;

  const BookingFieldHeader({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      child: Row(
        children: [
          BookingFieldImage(images: field.images),
          const SizedBox(width: BookingConstants.itemSpacing),
          Expanded(
            child: BookingFieldDetails(
              name: field.name,
              city: field.city,
              formattedPrice: field.formattedPrice,
            ),
          ),
        ],
      ),
    );
  }
}
