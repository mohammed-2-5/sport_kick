import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Dismissible field card for favorites list.
///
/// Allows swipe-to-delete with confirmation dialog.
class DismissibleFieldCard extends StatelessWidget {
  final FieldEntity field;

  const DismissibleFieldCard({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;

    return Dismissible(
      key: Key(field.id),
      direction: DismissDirection.endToStart,
      background: Builder(
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          // Use onPrimary for content on colored gradients (white in both themes)
          final contentColor = colorScheme.onPrimary;

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              gradient: AppGradients.error,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: errorColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: contentColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: contentColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.removeFromFavorites,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: contentColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(context.l10n.removeFromFavoritesQuestion),
              content: Text(context.l10n.removeFromFavoritesBody(field.name)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(context.l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    context.l10n.removeFromFavorites,
                    style: AppTextStyles.bodyMedium.copyWith(color: errorColor),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<FavoritesCubit>().removeFavorite(field.id);
      },
      child: FieldCard(
        field: field,
        onTap: () {
          context.pushNamed(
            'fieldDetails',
            pathParameters: {'fieldId': field.id},
          );
        },
      ),
    );
  }
}
