import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_field_floating_header.dart';

/// Floating header builder that appears on scroll.
///
/// Combines scroll state and favorites state to render animated header.
class FieldDetailsFloatingHeaderBuilder extends StatelessWidget {
  final FieldEntity field;

  const FieldDetailsFloatingHeaderBuilder({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldDetailsScrollCubit, FieldDetailsScrollState>(
      builder: (context, scrollState) {
        final opacity = _calculateOpacity(scrollState);

        return BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, favState) {
            final isFavorite = _checkIsFavorite(favState);

            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: PremiumFieldFloatingHeader(
                fieldName: field.name,
                rating: field.averageRating ?? 0.0,
                reviewCount: field.totalReviews,
                opacity: opacity,
                onBackPressed: () => context.pop(),
                onSharePressed: () => _shareField(context),
                onFavoritePressed: () {
                  context.read<FavoritesCubit>().toggleFavorite(
                    field.id,
                    isFavorite,
                  );
                },
                isFavorite: isFavorite,
              ),
            );
          },
        );
      },
    );
  }

  double _calculateOpacity(FieldDetailsScrollState state) {
    if (state is FieldDetailsScrollActive) {
      return state.headerOpacity;
    }
    return 0.0;
  }

  bool _checkIsFavorite(FavoritesState state) {
    if (state is FavoriteStatusLoaded) return state.isFavorite;
    if (state is FavoriteToggled) return state.isFavorite;
    return false;
  }

  void _shareField(BuildContext context) {
    final price = '${field.pricePerHour.toStringAsFixed(0)} ${field.currency}';
    final rating = field.hasReviews
        ? '${field.averageRating?.toStringAsFixed(1)} (${field.totalReviews})'
        : context.l10n.noReviews;

    SharePlus.instance.share(
      ShareParams(
        text: context.l10n.shareFieldMessage(
          field.name,
          field.description ?? '',
          field.address,
          field.city,
          price,
          rating,
        ),
      ),
    );
  }
}
