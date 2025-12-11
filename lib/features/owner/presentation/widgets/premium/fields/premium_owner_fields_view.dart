import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/fields/premium_owner_fields_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/fields/premium_owner_fields_filters.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/fields/premium_owner_fields_list.dart';

/// Premium view for owner fields management.
///
/// Features:
/// - Premium header with search and stats
/// - Filter chips (All/Active/Inactive)
/// - Pull-to-refresh
/// - Edit/Delete actions
/// - Search functionality
/// - Floating add button
class PremiumOwnerFieldsView extends StatefulWidget {
  const PremiumOwnerFieldsView({super.key});

  @override
  State<PremiumOwnerFieldsView> createState() => _PremiumOwnerFieldsViewState();
}

class _PremiumOwnerFieldsViewState extends State<PremiumOwnerFieldsView> {
  @override
  void initState() {
    super.initState();
    context.read<OwnerFieldsCubit>().loadFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      floatingActionButton: _buildFAB(context),
      body: BlocConsumer<OwnerFieldsCubit, OwnerFieldsState>(
        listener: (context, state) {
          if (state is OwnerFieldsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<OwnerFieldsCubit>();
          final stats = cubit.getStats();

          return Column(
            children: [
              // Header with search and stats
              PremiumOwnerFieldsHeader(
                searchQuery: state is OwnerFieldsLoaded
                    ? state.searchQuery
                    : '',
                onSearchChanged: (query) => cubit.search(query),
                onClearSearch: () => cubit.clearSearch(),
                stats: stats,
              ),

              const SizedBox(height: 20),

              // Filter chips
              PremiumOwnerFieldsFilters(
                selectedFilter: state is OwnerFieldsLoaded
                    ? state.activeFilter
                    : null,
                onFilterChanged: (filter) => cubit.filterByStatus(filter),
                stats: stats,
              ),

              const SizedBox(height: 20),

              // Fields list
              Expanded(child: _buildContent(context, state, cubit)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    OwnerFieldsState state,
    OwnerFieldsCubit cubit,
  ) {
    if (state is OwnerFieldsLoading) {
      return PremiumOwnerFieldsList(
        fields: const [],
        isLoading: true,
        isRefreshing: false,
        onRefresh: () {},
        onEdit: (_) {},
        onDelete: (_) {},
      );
    }

    if (state is OwnerFieldsLoaded) {
      final filteredFields = state.filteredFields;

      return PremiumOwnerFieldsList(
        fields: filteredFields,
        isLoading: false,
        isRefreshing: state.isRefreshing,
        onRefresh: () => cubit.refresh(),
        onEdit: (field) => context.pushNamed('ownerEditField', extra: field),
        onDelete: (field) =>
            _handleDelete(context, cubit, field.id, field.name),
        emptyMessage: _getEmptyMessage(state),
      );
    }

    // Error state - show empty with retry
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load fields',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => cubit.loadFields(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pushNamed('ownerAddField');
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accentCyan, AppColors.accentCyanDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentCyan.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 10),
            Text(
              'Add Field',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmptyMessage(OwnerFieldsLoaded state) {
    if (state.searchQuery.isNotEmpty) {
      return 'No fields match your search';
    }

    if (state.activeFilter != null) {
      return state.activeFilter == true
          ? 'No active fields'
          : 'No inactive fields';
    }

    return 'No fields yet';
  }

  Future<void> _handleDelete(
    BuildContext context,
    OwnerFieldsCubit cubit,
    String fieldId,
    String fieldName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Field',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        content: Text(
          'Are you sure you want to delete "$fieldName"? This action cannot be undone.',
          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.deleteField(fieldId);
    }
  }
}
