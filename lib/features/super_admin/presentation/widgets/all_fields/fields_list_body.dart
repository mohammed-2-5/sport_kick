import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_list_empty_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_list_search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/field_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_statistics_section.dart';

/// Main body widget for fields list.
class FieldsListBody extends StatelessWidget {
  final List<FieldEntity> allFields;
  final List<FieldEntity> filteredFields;
  final TextEditingController searchController;
  final String searchQuery;
  final bool hasFilters;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const FieldsListBody({
    required this.allFields,
    required this.filteredFields,
    required this.searchController,
    required this.searchQuery,
    required this.hasFilters,
    required this.onSearchChanged,
    required this.onClearSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SuperAdminCubit>().loadAllFields();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: FieldsStatisticsSection(fields: allFields)),
          SliverToBoxAdapter(
            child: FieldsListSearchBar(
              controller: searchController,
              searchQuery: searchQuery,
              onChanged: onSearchChanged,
              onClear: onClearSearch,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${filteredFields.length} field${filteredFields.length != 1 ? 's' : ''} found',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),
          ),
          if (filteredFields.isEmpty)
            SliverFillRemaining(
              child: FieldsListEmptyState(hasFilters: hasFilters),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FieldCard(field: filteredFields[index]),
                  ),
                  childCount: filteredFields.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
