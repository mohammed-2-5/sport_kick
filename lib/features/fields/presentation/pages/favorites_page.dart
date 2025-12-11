import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/widgets/favorites/favorites_view.dart';

/// Favorites page - displays user's favorite fields.
///
/// Features:
/// - Premium curved header
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
      child: const Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Column(
          children: [
            // Premium Header
            PremiumCurvedHeader(
              title: 'My Favorites',
              subtitle: 'Fields you love',
              showBackButton: true,
              height: 180,
            ),
            // Content
            Expanded(child: FavoritesView()),
          ],
        ),
      ),
    );
  }
}
