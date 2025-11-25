import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/booking_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/booking_filter_sheet.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/bookings_statistics_section.dart';
import 'package:spo_kick/features/super_admin/utils/booking_filter_helper.dart';

/// All Bookings Management Page
///
/// Super admin page showing all bookings in the system with:
/// - Search functionality with debouncing
/// - Advanced filters (status, date range, field)
/// - Booking statistics
/// - Booking cards with details
class AllBookingsPage extends StatelessWidget {
  const AllBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAllBookings(),
      child: const _AllBookingsView(),
    );
  }
}

class _AllBookingsView extends StatefulWidget {
  const _AllBookingsView();

  @override
  State<_AllBookingsView> createState() => _AllBookingsViewState();
}

class _AllBookingsViewState extends State<_AllBookingsView> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';

  // Filter state
  BookingStatus? _statusFilter;
  DateTimeRange? _dateRange;
  String? _fieldFilter;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = value;
      });
    });
  }

  bool get _hasActiveFilters =>
      _statusFilter != null || _dateRange != null || _fieldFilter != null;

  List<BookingEntity> _filterBookings(List<BookingEntity> bookings) {
    return BookingFilterHelper.filterBookings(
      bookings,
      searchQuery: _searchQuery,
      statusFilter: _statusFilter,
      dateRange: _dateRange,
      fieldFilter: _fieldFilter,
    );
  }

  void _showFilterSheet(List<BookingEntity> allBookings) {
    final fieldNames = BookingFilterHelper.getUniqueFieldNames(allBookings);

    BookingStatus? tempStatus = _statusFilter;
    DateTimeRange? tempDateRange = _dateRange;
    String? tempField = _fieldFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (c) => StatefulBuilder(
        builder: (_, setSheetState) => BookingFilterSheet(
          statusFilter: tempStatus,
          dateRange: tempDateRange,
          fieldFilter: tempField,
          availableFields: fieldNames,
          onStatusChanged: (v) => setSheetState(() => tempStatus = v),
          onDateRangeChanged: (r) => setSheetState(() => tempDateRange = r),
          onFieldChanged: (v) => setSheetState(() => tempField = v),
          onApply: () {
            setState(() {
              _statusFilter = tempStatus;
              _dateRange = tempDateRange;
              _fieldFilter = tempField;
            });
            Navigator.pop(context);
          },
          onReset: () {
            setState(() {
              _statusFilter = null;
              _dateRange = null;
              _fieldFilter = null;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Bookings'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<SuperAdminCubit, SuperAdminState>(
            builder: (context, state) {
              if (state is AllBookingsLoaded) {
                return IconButton(
                  icon: Badge(
                    isLabelVisible: _hasActiveFilters,
                    child: const Icon(Icons.filter_list),
                  ),
                  onPressed: () =>
                      _showFilterSheet(state.bookings.cast<BookingEntity>()),
                  tooltip: 'Filter',
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SuperAdminCubit>().loadAllBookings(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SuperAdminLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (state is SuperAdminError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading bookings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<SuperAdminCubit>().loadAllBookings(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AllBookingsLoaded) {
            final allBookings = state.bookings.cast<BookingEntity>();
            final filteredBookings = _filterBookings(allBookings);

            // Sort by date (most recent first)
            filteredBookings.sort((a, b) => b.date.compareTo(a.date));

            return RefreshIndicator(
              onRefresh: () async {
                context.read<SuperAdminCubit>().loadAllBookings();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                slivers: [
                  // Statistics Section
                  SliverToBoxAdapter(
                    child: BookingsStatisticsSection(bookings: allBookings),
                  ),

                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by customer, field, or booking ID...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                  ),

                  // Results count
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${filteredBookings.length} booking${filteredBookings.length != 1 ? 's' : ''} found',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                  // Bookings List
                  if (filteredBookings.isEmpty)
                    _buildEmptyState(context)
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

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
