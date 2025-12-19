import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_image_gallery.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_share_button.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Sliver app bar for field details page.
///
/// Contains image gallery, share button, and favorite button.
class FieldDetailsSliverAppBar extends StatelessWidget {
  final FieldEntity field;

  const FieldDetailsSliverAppBar({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: FieldConstants.imageGalleryHeight,
      pinned: true,
      actions: [
        FieldShareButton(field: field),
        FieldDetailsFavoriteButton(field: field),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: FieldImageGallery(
          images: field.images,
          fieldId: field.id,
          isVerified: field.isVerified,
          isPopular: field.isPopular,
        ),
      ),
    );
  }
}

/// Favorite toggle button for field details.
class FieldDetailsFavoriteButton extends StatelessWidget {
  final FieldEntity field;

  const FieldDetailsFavoriteButton({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFavorite = _isFavorite(state);

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            context.read<FavoritesCubit>().toggleFavorite(field.id, isFavorite);
          },
          tooltip: isFavorite
              ? context.l10n.removeFromFavorites
              : context.l10n.addToFavorites,
        );
      },
    );
  }

  bool _isFavorite(FavoritesState state) {
    if (state is FavoriteStatusLoaded) return state.isFavorite;
    if (state is FavoriteToggled) return state.isFavorite;
    return false;
  }
}
