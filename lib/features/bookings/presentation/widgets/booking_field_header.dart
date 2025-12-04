import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Field header showing field image, name, location, and price.
///
/// Displays at the top of the create booking page to provide
/// context about which field is being booked.
class BookingFieldHeader extends StatelessWidget {
  final FieldEntity field;

  const BookingFieldHeader({
    super.key,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      child: Row(
        children: [
          // Field Image
          _buildFieldImage(),

          const SizedBox(width: BookingConstants.itemSpacing),

          // Field Details
          Expanded(
            child: _buildFieldDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(BookingConstants.smallPadding),
      child: field.images.isNotEmpty
          ? Image.network(
              field.images.first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      color: AppColors.border,
      child: const Icon(Icons.sports_soccer),
    );
  }

  Widget _buildFieldDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${field.city} • ${field.formattedPrice}/hour',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
