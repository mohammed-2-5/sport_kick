import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/premium/premium_field_list_item.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium favorites page with enhanced UI.
///
/// Features:
/// - Premium curved header
/// - Staggered list animations
/// - Swipe to delete
/// - Empty state
/// - Pull to refresh
class PremiumFavoritesPage extends StatelessWidget {
  const PremiumFavoritesPage({super.key});

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
        backgroundColor: AppColors.lightBackground,
        body: Column(
          children: [
            PremiumCurvedHeader(
              title: context.l10n.myFavorites,
              subtitle: context.l10n.favoritesSubtitle,
              showBackButton: true,
            ),
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, favoritesState) {
                  if (favoritesState is FavoritesLoading) {
                    return LoadingIndicator.inline(
                      message: context.l10n.loading,
                    );
                  }

                  if (favoritesState is FavoritesError) {
                    return EmptyStates.error(
                      message: favoritesState.message,
                      onRetry: () =>
                          context.read<FavoritesCubit>().loadFavorites(),
                    );
                  }

                  if (favoritesState is FavoritesListLoaded) {
                    if (favoritesState.isEmpty) {
                      return EmptyStates.noFavorites(
                        onBrowse: () => Navigator.pop(context),
                      );
                    }

                    return BlocBuilder<FieldsCubit, FieldsState>(
                      builder: (context, fieldsState) {
                        if (fieldsState is! FieldsLoaded) {
                          return const LoadingIndicator.inline(
                            message: 'Loading fields...',
                          );
                        }

                        final favoriteFields = fieldsState.fields
                            .where(
                              (field) => favoritesState.isFavorite(field.id),
                            )
                            .toList();

                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<FavoritesCubit>().loadFavorites();
                            context.read<FieldsCubit>().loadAllFields();
                          },
                          color: AppColors.accentCyan,
                          child: AnimationLimiter(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: favoriteFields.length,
                              itemBuilder: (context, index) {
                                final field = favoriteFields[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Dismissible(
                                        key: Key(field.id),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(
                                            right: 20,
                                          ),
                                          margin: const EdgeInsets.only(
                                            bottom: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Colors.red,
                                                Colors.redAccent,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.delete_outline,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Remove',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onDismissed: (_) {
                                          context
                                              .read<FavoritesCubit>()
                                              .toggleFavorite(field.id, true);
                                        },
                                        child: PremiumFieldListItem(
                                          field: field,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
