import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_grid.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_error_view.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_loading_view.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_missing_hours_card.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_refresh_button.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/field_selector_dropdown.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/week_navigation_bar.dart';

/// Premium booking table view with animated grid.
///
/// This view displays a weekly booking calendar for field owners.
/// Features:
/// - Field selector (if owner has multiple fields)
/// - Week navigation
/// - Business hours setup reminder
/// - Interactive booking grid
class BookingTableView extends StatelessWidget {
  const BookingTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<BookingTableCubit, BookingTableState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BookingTableState state) {
    if (state is BookingTableLoading) {
      return BookingTableLoadingView(
        message: state.message ?? context.l10n.initializing,
      );
    }

    if (state is BookingTableError) {
      return BookingTableErrorView(
        message: state.message,
        onRetry: () => context.read<BookingTableCubit>().initialize(),
      );
    }

    if (state is BookingTableLoaded) {
      return _buildLoadedContent(context, state);
    }

    return BookingTableLoadingView(message: context.l10n.initializing);
  }

  Widget _buildLoadedContent(BuildContext context, BookingTableLoaded state) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.tertiary,
      onRefresh: () async {
        await context.read<BookingTableCubit>().refresh();
      },
      child: CustomScrollView(
        slivers: [
          // Premium Header
          SliverToBoxAdapter(
            child: PremiumCurvedHeader(
              title: context.l10n.bookingTableTitle,
              subtitle: state.selectedField.name,
              showBackButton: true,
              actions: [
                BookingTableRefreshButton(
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
                child: BookingTableMissingHoursCard(
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

          // Bottom spacing with SafeArea
          const SliverToBoxAdapter(
            child: SafeArea(top: false, child: SizedBox(height: 32)),
          ),
        ],
      ),
    );
  }
}
