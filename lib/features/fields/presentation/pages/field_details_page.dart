import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
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
        backgroundColor: AppColors.lightBackground,
        body: BlocBuilder<FieldsCubit, FieldsState>(
          builder: (context, state) => _buildPageContent(context, state),
        ),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, FieldsState state) {
    if (state is FieldsLoading) {
      return LoadingIndicator.inline(message: context.l10n.loading);
    }

    if (state is FieldsError) {
      return EmptyStates.error(
        message: state.message,
        onRetry: () => context.read<FieldsCubit>().loadFieldDetails(fieldId),
      );
    }

    if (state is FieldDetailsLoaded) {
      return PremiumFieldDetailsView(
        field: state.field,
        category: state.category,
      );
    }

    return EmptyStates.error(
      message: context.l10n.fieldNotFound,
      onRetry: () => context.read<FieldsCubit>().loadFieldDetails(fieldId),
    );
  }
}
