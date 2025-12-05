import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/dismissible_field_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/favorites_header.dart';

/// Favorites list widget with header.
///
/// Displays:
/// - Gradient header with favorites count
/// - Swipe-to-delete field cards
class FavoritesList extends StatelessWidget {
  final List<FieldEntity> favoriteFields;

  const FavoritesList({super.key, required this.favoriteFields});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with gradient
        FavoritesHeader(count: favoriteFields.length),

        // Favorites list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: favoriteFields.length,
            itemBuilder: (context, index) {
              return DismissibleFieldCard(field: favoriteFields[index]);
            },
          ),
        ),
      ],
    );
  }
}
