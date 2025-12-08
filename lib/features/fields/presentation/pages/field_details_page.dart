import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/book_now_button.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_details_content.dart';

/// Field details page - shows complete information about a field.
///
/// Displays:
/// - Image gallery with sliver app bar
/// - Field name, rating, and price
/// - Full description
/// - Location and contact info
/// - Facilities
/// - Reviews and ratings
/// - Book now button
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
      return const LoadingIndicator.inline(message: 'Loading field details...');
    }

    if (state is FieldsError) {
      return EmptyStates.error(
        message: state.message,
        onRetry: () => context.read<FieldsCubit>().loadFieldDetails(fieldId),
      );
    }

    if (state is FieldDetailsLoaded) {
      return Stack(
        children: [
          FieldDetailsContent(field: state.field, category: state.category),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BookNowButton(field: state.field),
          ),
        ],
      );
    }

    return EmptyStates.error(
      message: 'Field not found',
      onRetry: () => context.read<FieldsCubit>().loadFieldDetails(fieldId),
    );
  }
}
