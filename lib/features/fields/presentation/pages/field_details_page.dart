import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_field_details_view.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Field details page - shows complete information about a field.
///
/// Premium features:
/// - Hero image with parallax scroll
/// - Floating glassmorphism header
/// - Premium cards for all sections
/// - Image gallery with zoom
/// - Floating book now button
/// - Staggered animations
class FieldDetailsPage extends StatelessWidget {
  final String fieldId;

  const FieldDetailsPage({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FieldsCubit>()..loadFieldDetails(fieldId),
        ),
        BlocProvider(
          create: (context) => sl<FavoritesCubit>()..checkIsFavorite(fieldId),
        ),
        BlocProvider(create: (context) => FieldDetailsScrollCubit()),
      ],
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: BlocBuilder<FieldsCubit, FieldsState>(
          builder: (context, state) {
            return switch (state) {
              FieldsLoading() => LoadingIndicator.inline(
                message: context.l10n.loading,
              ),
              FieldsError(:final message) => EmptyStates.error(
                context,
                message: message,
                onRetry: () =>
                    context.read<FieldsCubit>().loadFieldDetails(fieldId),
              ),
              FieldDetailsLoaded(:final field, :final category) =>
                PremiumFieldDetailsView(field: field, category: category),
              _ => EmptyStates.error(
                context,
                message: context.l10n.fieldNotFound,
                onRetry: () =>
                    context.read<FieldsCubit>().loadFieldDetails(fieldId),
              ),
            };
          },
        ),
      ),
    );
  }
}
