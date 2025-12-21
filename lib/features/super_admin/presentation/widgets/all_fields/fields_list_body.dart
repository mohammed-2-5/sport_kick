import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_list_empty_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_list_search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/field_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_statistics_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dialogs/delete_options_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/fields/field_actions_sheet.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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

  void _showFieldActions(BuildContext context, FieldEntity field) {
    final cubit = context.read<SuperAdminCubit>();

    FieldActionsSheet.show(
      context: context,
      field: field,
      onEdit: () {
        context.pushNamed('superAdminEditField', extra: field);
      },
      onToggleVerify: () {
        cubit.verifyField(fieldId: field.id, isVerified: !field.isVerified);
      },
      onDelete: () {
        DeleteOptionsDialog.show(
          context: context,
          fieldName: field.name,
          onSoftDelete: () {
            cubit.deleteField(fieldId: field.id, hardDelete: false);
          },
          onHardDelete: () {
            cubit.deleteField(fieldId: field.id, hardDelete: true);
          },
        );
      },
    );
  }

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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.fieldsFoundCount(filteredFields.length),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                  Text(
                    context.l10n.longPressForActions,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
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
                delegate: SliverChildBuilderDelegate((context, index) {
                  final field = filteredFields[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FieldCard(
                      field: field,
                      onLongPress: () => _showFieldActions(context, field),
                    ),
                  );
                }, childCount: filteredFields.length),
              ),
            ),
        ],
      ),
    );
  }
}
