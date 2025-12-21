import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_bookings/bookings_list_body.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_bookings/bookings_list_error_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_bookings/bookings_list_loading_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_bookings/booking_filter_sheet.dart';
import 'package:spo_kick/features/super_admin/utils/booking_filter_helper.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// All Bookings View - displays and manages the bookings list with filtering.
class AllBookingsView extends StatefulWidget {
  const AllBookingsView({super.key});

  @override
  State<AllBookingsView> createState() => _AllBookingsViewState();
}

class _AllBookingsViewState extends State<AllBookingsView> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';

  String? _statusFilter;
  DateTimeRange? _dateRange;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() => _searchQuery = value);
    });
  }

  bool get _hasActiveFilters => _statusFilter != null || _dateRange != null;

  List<BookingEntity> _filterBookings(List<BookingEntity> bookings) {
    return BookingFilterHelper.filterBookings(
      bookings,
      searchQuery: _searchQuery,
      statusFilter: _statusFilter != null
          ? BookingStatus.values.firstWhere((s) => s.name == _statusFilter)
          : null,
      dateRange: _dateRange,
    );
  }

  void _showFilterSheet(List<BookingEntity> allBookings) {
    String? tempStatus = _statusFilter;
    DateTimeRange? tempDate = _dateRange;
    final availableFields = allBookings
        .map((b) => b.fieldName ?? 'Unknown')
        .toSet()
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (c) => StatefulBuilder(
        builder: (_, setSheetState) => BookingFilterSheet(
          statusFilter: tempStatus != null
              ? BookingStatus.values.firstWhere((s) => s.name == tempStatus)
              : null,
          dateRange: tempDate,
          fieldFilter: null,
          availableFields: availableFields,
          onStatusChanged: (status) =>
              setSheetState(() => tempStatus = status?.name),
          onDateRangeChanged: (r) => setSheetState(() => tempDate = r),
          onFieldChanged: (_) {},
          onApply: () {
            setState(() {
              _statusFilter = tempStatus;
              _dateRange = tempDate;
            });
            Navigator.pop(context);
          },
          onReset: () {
            setState(() {
              _statusFilter = null;
              _dateRange = null;
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
        title: Text(context.l10n.allBookings),
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
                  tooltip: context.l10n.filterFields,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SuperAdminCubit>().loadAllBookings(),
            tooltip: context.l10n.refresh,
          ),
        ],
      ),
      body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            SnackbarHelper.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is SuperAdminLoading) {
            return BookingsListLoadingState(message: state.message);
          }

          if (state is SuperAdminError) {
            return BookingsListErrorState(
              message: state.message,
              onRetry: () => context.read<SuperAdminCubit>().loadAllBookings(),
            );
          }

          if (state is AllBookingsLoaded) {
            final allBookings = state.bookings.cast<BookingEntity>();
            final filteredBookings = _filterBookings(allBookings);

            return BookingsListBody(
              allBookings: allBookings,
              filteredBookings: filteredBookings,
              searchController: _searchController,
              searchQuery: _searchQuery,
              hasFilters: _hasActiveFilters || _searchQuery.isNotEmpty,
              onSearchChanged: _onSearchChanged,
              onClearSearch: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
