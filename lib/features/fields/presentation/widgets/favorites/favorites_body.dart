import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/favorites/favorites_list.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Content body for favorites - handles all state combinations.
///
/// Uses state-based rendering with no business logic in the widget.
class FavoritesBody extends StatelessWidget {
  const FavoritesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favoritesState) {
        // Loading state
        if (favoritesState is FavoritesLoading) {
          return LoadingIndicator.inline(message: context.l10n.loading);
        }

        // Error state
        if (favoritesState is FavoritesError) {
          return EmptyStates.error(
            message: favoritesState.message,
            onRetry: () => context.read<FavoritesCubit>().loadFavorites(),
          );
        }

        // Toggled state - reload
        if (favoritesState is FavoriteToggled) {
          return LoadingIndicator.inline(message: context.l10n.loading);
        }

        // List loaded state
        if (favoritesState is FavoritesListLoaded) {
          if (favoritesState.isEmpty) {
            return EmptyStates.noFavorites(onBrowse: () => context.pop());
          }
          return _FavoritesFieldsLoader(favoritesState: favoritesState);
        }

        // Initial state
        return EmptyStates.noFavorites(onBrowse: () => context.pop());
      },
    );
  }
}

/// Loads fields and filters to show only favorites.
class _FavoritesFieldsLoader extends StatelessWidget {
  final FavoritesListLoaded favoritesState;

  const _FavoritesFieldsLoader({required this.favoritesState});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldsCubit, FieldsState>(
      builder: (context, fieldsState) {
        if (fieldsState is FieldsLoading) {
          return LoadingIndicator.inline(message: context.l10n.loadingFields);
        }

        if (fieldsState is FieldsError) {
          return EmptyStates.error(
            message: fieldsState.message,
            onRetry: () => context.read<FieldsCubit>().loadAllFields(),
          );
        }

        if (fieldsState is FieldsLoaded) {
          // Use state's filterFavorites method - no logic in UI
          final favoriteFields = favoritesState.filterFavorites(
            fieldsState.fields,
            (field) => field.id,
          );

          if (favoriteFields.isEmpty) {
            return EmptyStates.noFavorites(onBrowse: () => context.pop());
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FavoritesCubit>().loadFavorites();
              context.read<FieldsCubit>().loadAllFields();
            },
            child: FavoritesList(favoriteFields: favoriteFields),
          );
        }

        return LoadingIndicator.inline(message: context.l10n.loading);
      },
    );
  }
}
