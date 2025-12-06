import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/favorites_empty_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/favorites_list.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listener: (context, state) {
        // Show snackbar when favorite is removed
        if (state is FavoriteToggled && !state.isFavorite) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from favorites'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // Show error message if operation fails
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
      },
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favoritesState) {
          return BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, fieldsState) {
              return _buildBody(context, favoritesState, fieldsState);
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    FavoritesState favoritesState,
    FieldsState fieldsState,
  ) {
    // Show loading if favorites are loading
    if (favoritesState is FavoritesLoading) {
      return const LoadingIndicator.inline(message: 'Loading favorites...');
    }

    // Show error if favorites failed to load
    if (favoritesState is FavoritesError) {
      return AppErrorWidget(
        message: favoritesState.message,
        onRetry: () => context.read<FavoritesCubit>().loadFavorites(),
      );
    }

    // Get favorite IDs
    List<String> favoriteIds = [];
    if (favoritesState is FavoritesListLoaded) {
      favoriteIds = favoritesState.favoriteFieldIds;
    } else if (favoritesState is FavoriteToggled) {
      // Reload favorites after toggle
      final cubit = context.read<FavoritesCubit>();
      Future.microtask(() => cubit.loadFavorites());
      return const LoadingIndicator.inline(message: 'Updating favorites...');
    }

    // Show empty state if no favorites
    if (favoriteIds.isEmpty) {
      return const FavoritesEmptyState();
    }

    // Show loading if fields are loading
    if (fieldsState is FieldsLoading) {
      return const LoadingIndicator.inline(message: 'Loading fields...');
    }

    // Show error if fields failed to load
    if (fieldsState is FieldsError) {
      return AppErrorWidget(
        message: fieldsState.message,
        onRetry: () => context.read<FieldsCubit>().loadAllFields(),
      );
    }

    // Filter and display favorite fields
    if (fieldsState is FieldsLoaded) {
      final favoriteFields = fieldsState.fields
          .where((field) => favoriteIds.contains(field.id))
          .toList();

      if (favoriteFields.isEmpty) {
        return const FavoritesEmptyState();
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<FavoritesCubit>().loadFavorites();
          context.read<FieldsCubit>().loadAllFields();
        },
        child: FavoritesList(favoriteFields: favoriteFields),
      );
    }

    // Default loading state
    return const LoadingIndicator.inline(message: 'Loading...');
  }
}
