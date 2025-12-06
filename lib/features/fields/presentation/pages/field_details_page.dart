import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/book_now_button.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_details_content.dart';

/// Field details page - shows complete information about a field.
///
/// Displays:
/// - Image gallery
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
      child: BlocBuilder<FieldsCubit, FieldsState>(
        builder: (context, state) {
          if (state is FieldsLoading) {
            return const Scaffold(
              body: LoadingIndicator.inline(
                message: 'Loading field details...',
              ),
            );
          }

          if (state is FieldsError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Field Details')),
              body: AppErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<FieldsCubit>().loadFieldDetails(fieldId);
                },
              ),
            );
          }

          if (state is FieldDetailsLoaded) {
            return Scaffold(
              body: FieldDetailsContent(
                field: state.field,
                category: state.category,
              ),
              bottomNavigationBar: BookNowButton(field: state.field),
            );
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Field Details')),
            body: const Center(child: Text('Field not found')),
          );
        },
      ),
    );
  }
}
