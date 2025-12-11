import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/category_filters.dart';

/// Category filters section for fields list.
///
/// Shows category chips when fields are loaded.
class FieldsCategorySection extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const FieldsCategorySection({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldsCubit, FieldsState>(
      builder: (context, state) {
        if (state is! FieldsLoaded) {
          return const SizedBox.shrink();
        }
        return CategoryFilters(
          categories: state.categories,
          selectedCategoryId: selectedCategoryId,
          onCategorySelected: onCategorySelected,
        );
      },
    );
  }
}
