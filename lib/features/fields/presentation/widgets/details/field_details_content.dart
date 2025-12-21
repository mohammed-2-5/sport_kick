import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_details_body.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_details_sliver_app_bar.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Content widget for field details page.
///
/// Displays:
/// - Sliver app bar with image gallery
/// - Field info, description, location, facilities, reviews
class FieldDetailsContent extends StatelessWidget {
  final FieldEntity field;
  final dynamic category;

  const FieldDetailsContent({super.key, required this.field, this.category});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listener: (context, state) => _handleFavoritesState(context, state),
      child: CustomScrollView(
        slivers: [
          FieldDetailsSliverAppBar(field: field),
          FieldDetailsBody(field: field, category: category),
        ],
      ),
    );
  }

  void _handleFavoritesState(BuildContext context, FavoritesState state) {
    if (state is FavoriteToggled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.isFavorite
                ? context.l10n.addedToFavorites
                : context.l10n.removedFromFavorites,
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (state is FavoritesError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
