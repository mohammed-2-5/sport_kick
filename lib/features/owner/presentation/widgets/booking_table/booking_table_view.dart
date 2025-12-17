import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_grid.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/field_selector_dropdown.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/week_navigation_bar.dart';

/// Premium booking table view with animated grid.
class BookingTableView extends StatelessWidget {
  const BookingTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingTableCubit, BookingTableState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BookingTableState state) {
    if (state is BookingTableLoading) {
      return _LoadingView(message: state.message ?? 'Loading...');
    }

    if (state is BookingTableError) {
      return _ErrorView(
        message: state.message,
        onRetry: () => context.read<BookingTableCubit>().initialize(),
      );
    }

    if (state is BookingTableLoaded) {
      return _buildLoadedContent(context, state);
    }

    return const _LoadingView(message: 'Initializing...');
  }

  Widget _buildLoadedContent(BuildContext context, BookingTableLoaded state) {
    return RefreshIndicator(
      color: AppColors.goldAccent,
      onRefresh: () async {
        await context.read<BookingTableCubit>().refresh();
      },
      child: CustomScrollView(
        slivers: [
          // Premium Header
          SliverToBoxAdapter(
            child: PremiumCurvedHeader(
              title: 'Booking Table',
              subtitle: state.selectedField.name,
              showBackButton: true,
              actions: [
                _RefreshButton(
                  onTap: () => context.read<BookingTableCubit>().refresh(),
                  isLoading: state.isRefreshing,
                ),
              ],
            ),
          ),

          // Field Selector (if multiple fields)
          if (state.ownerFields.length > 1)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: FieldSelectorDropdown(
                  selectedField: state.selectedField,
                  fields: state.ownerFields,
                  onFieldSelected: (field) {
                    context.read<BookingTableCubit>().selectField(field);
                  },
                ),
              ),
            ),

          // Week Navigation
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: WeekNavigationBar(
                weekRangeString: state.weekRangeString,
                isCurrentWeek: state.isCurrentWeek,
                onPreviousWeek: () {
                  context.read<BookingTableCubit>().previousWeek();
                },
                onNextWeek: () {
                  context.read<BookingTableCubit>().nextWeek();
                },
                onToday: () {
                  context.read<BookingTableCubit>().goToToday();
                },
              ),
            ),
          ),

          // Missing business hours notice
          if (state.businessHours.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _MissingHoursCard(
                  fieldName: state.selectedField.name,
                  onSetup: () {
                    context.pushNamed(
                      'manageBusinessHours',
                      pathParameters: {'fieldId': state.selectedField.id},
                      extra: {'fieldName': state.selectedField.name},
                    );
                  },
                ),
              ),
            ),

          // Booking Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BookingGrid(state: state),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

/// Banner shown when business hours are missing.
class _MissingHoursCard extends StatelessWidget {
  final String fieldName;
  final VoidCallback onSetup;

  const _MissingHoursCard({required this.fieldName, required this.onSetup});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.goldAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.schedule_outlined,
              color: AppColors.goldAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Business hours missing',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set hours for $fieldName to enable booking slots.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSetup,
            child: const Text(
              'Set up',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.goldAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Refresh button with loading state.
class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const _RefreshButton({required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassHighlight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
        onPressed: isLoading ? null : onTap,
      ),
    );
  }
}

/// Loading view.
class _LoadingView extends StatelessWidget {
  final String message;
  const _LoadingView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.navyDeep.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.goldAccent,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error view.
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Failed to load',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navyDeep,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
