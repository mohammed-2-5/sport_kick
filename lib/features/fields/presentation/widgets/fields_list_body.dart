import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/fields_list_content.dart';

/// Content widget that displays fields based on state.
///
/// Handles loading, error, empty, and loaded states.
class FieldsListBody extends StatelessWidget {
  final VoidCallback onClearSearch;
  final VoidCallback? onClearCategory;

  const FieldsListBody({
    super.key,
    required this.onClearSearch,
    this.onClearCategory,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldsCubit, FieldsState>(
      builder: (context, state) {
        if (state is FieldsLoading) {
          return const FieldsListShimmer(itemCount: 5);
        }

        if (state is FieldsError) {
          return EmptyStates.error(
            message: state.message,
            onRetry: () => context.read<FieldsCubit>().loadAllFields(),
          );
        }

        if (state is FieldsLoaded) {
          final fields = state.filteredFields;

          if (fields.isEmpty) {
            // Check if it's search empty or just no fields
            if (state.searchQuery != null) {
              return EmptyStates.noResults(
                onClear: () {
                  onClearCategory?.call();
                  onClearSearch();
                },
              );
            }
            return EmptyStates.noFields(
              onRefresh: () => context.read<FieldsCubit>().refresh(),
            );
          }

          return FieldsListContent(fields: fields);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
