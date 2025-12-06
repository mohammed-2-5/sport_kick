import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/widgets/favorites_view.dart';

/// Favorites page - displays user's favorite fields.
///
/// Features:
/// - Shows all favorited fields
/// - Pull to refresh
/// - Empty state with call-to-action
/// - Remove from favorites functionality
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FavoritesCubit>()..loadFavorites(),
        ),
        BlocProvider(create: (context) => sl<FieldsCubit>()..loadAllFields()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Favorites'), elevation: 0),
        body: const FavoritesView(),
      ),
    );
  }
}
