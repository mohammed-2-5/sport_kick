import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_bookings/bookings_list_empty_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_bookings/bookings_list_search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_bookings/booking_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_bookings/bookings_statistics_section.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Main body widget for bookings list.
class BookingsListBody extends StatelessWidget {
  final List<BookingEntity> allBookings;
  final List<BookingEntity> filteredBookings;
  final TextEditingController searchController;
  final String searchQuery;
  final bool hasFilters;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const BookingsListBody({
    required this.allBookings,
    required this.filteredBookings,
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
        context.read<SuperAdminCubit>().loadAllBookings();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BookingsStatisticsSection(bookings: allBookings),
          ),
          SliverToBoxAdapter(
            child: BookingsListSearchBar(
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
                context.l10n.bookingsFoundCount(filteredBookings.length),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
          if (filteredBookings.isEmpty)
            SliverFillRemaining(
              child: BookingsListEmptyState(hasFilters: hasFilters),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: BookingCard(booking: filteredBookings[index]),
                  ),
                  childCount: filteredBookings.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
