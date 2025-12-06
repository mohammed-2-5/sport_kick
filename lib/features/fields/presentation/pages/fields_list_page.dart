import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/utils/city_helper.dart';
import 'package:spo_kick/features/fields/presentation/widgets/fields_list_view.dart';

/// Fields list page - browse and search sports fields.
///
/// Features:
/// - Filter by sport category
/// - Search fields
/// - Pull to refresh
/// - Navigate to field details
class FieldsListPage extends StatelessWidget {
  final String? categoryId;

  const FieldsListPage({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    // Get the current city if available
    final cityState = context.read<CityCubit>().state;
    final initialCityId = CityHelper.getCurrentCityId(cityState);

    return BlocProvider(
      create: (context) {
        final cubit = sl<FieldsCubit>();

        debugPrint(
          '📋 [FIELDS LIST PAGE] Initializing with categoryId: $categoryId, cityId: $initialCityId',
        );

        // Load fields first, then apply category filter
        if (initialCityId != null) {
          cubit.setCurrentCity(initialCityId).then((_) {
            if (categoryId != null) {
              debugPrint(
                '🔍 [FIELDS LIST PAGE] Applying category filter: $categoryId',
              );
              cubit.filterByCategory(categoryId);
            }
          });
        } else {
          cubit.loadAllFields().then((_) {
            if (categoryId != null) {
              debugPrint(
                '🔍 [FIELDS LIST PAGE] Applying category filter: $categoryId',
              );
              cubit.filterByCategory(categoryId);
            }
          });
        }

        return cubit;
      },
      child: FieldsListView(initialCategoryId: categoryId),
    );
  }
}
