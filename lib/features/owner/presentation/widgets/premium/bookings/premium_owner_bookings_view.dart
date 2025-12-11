import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_tabs.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_list.dart';

/// Premium view for owner bookings management.
///
/// Features:
/// - Premium header with search and stats
/// - Tab-based filtering
/// - Pull-to-refresh
/// - Approve/Reject actions
/// - Search functionality
class PremiumOwnerBookingsView extends StatefulWidget {
  const PremiumOwnerBookingsView({super.key});

  @override
  State<PremiumOwnerBookingsView> createState() =>
      _PremiumOwnerBookingsViewState();
}

class _PremiumOwnerBookingsViewState extends State<PremiumOwnerBookingsView> {
  @override
  void initState() {
    super.initState();
    context.read<OwnerBookingsCubit>().loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<OwnerBookingsCubit, OwnerBookingsState>(
        listener: (context, state) {
          if (state is OwnerBookingsError) {
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
          final cubit = context.read<OwnerBookingsCubit>();
          final stats = cubit.getStats();

          return Column(
            children: [
              // Header with search and stats
              PremiumOwnerBookingsHeader(
                searchQuery: state is OwnerBookingsLoaded
                    ? state.searchQuery
                    : '',
                onSearchChanged: (query) => cubit.search(query),
                onClearSearch: () => cubit.clearSearch(),
                stats: stats,
              ),

              const SizedBox(height: 20),

              // Tab bar for filtering
              PremiumOwnerBookingsTabs(
                selectedIndex: state is OwnerBookingsLoaded
                    ? state.selectedTabIndex
                    : 0,
                onTabChanged: (index) => cubit.changeTab(index),
                stats: stats,
              ),

              const SizedBox(height: 20),

              // Bookings list
              Expanded(child: _buildContent(context, state, cubit)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    OwnerBookingsState state,
    OwnerBookingsCubit cubit,
  ) {
    if (state is OwnerBookingsLoading) {
      return PremiumOwnerBookingsList(
        bookings: const [],
        isLoading: true,
        isRefreshing: false,
        onRefresh: () {},
        onApprove: (_) {},
        onReject: (_) {},
      );
    }

    if (state is OwnerBookingsLoaded) {
      final filteredBookings = state.filteredBookings;

      return PremiumOwnerBookingsList(
        bookings: filteredBookings,
        isLoading: false,
        isRefreshing: state.isRefreshing,
        onRefresh: () => cubit.refresh(),
        onApprove: (id) => _handleApprove(context, cubit, id),
        onReject: (id) => _handleReject(context, cubit, id),
        emptyMessage: _getEmptyMessage(state),
      );
    }

    // Error state - show empty with error message
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load bookings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => cubit.loadBookings(),
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

  String _getEmptyMessage(OwnerBookingsLoaded state) {
    if (state.searchQuery.isNotEmpty) {
      return 'No bookings match your search';
    }

    switch (state.selectedTabIndex) {
      case 1:
        return 'No pending bookings';
      case 2:
        return 'No confirmed bookings';
      case 3:
        return 'No canceled bookings';
      default:
        return 'No bookings yet';
    }
  }

  Future<void> _handleApprove(
    BuildContext context,
    OwnerBookingsCubit cubit,
    String bookingId,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Approve Booking',
      message: 'Are you sure you want to approve this booking?',
      confirmText: 'Approve',
      confirmColor: Colors.green,
    );

    if (confirmed) {
      await cubit.approveBooking(bookingId);
    }
  }

  Future<void> _handleReject(
    BuildContext context,
    OwnerBookingsCubit cubit,
    String bookingId,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Reject Booking',
      message: 'Are you sure you want to reject this booking?',
      confirmText: 'Reject',
      confirmColor: Colors.red,
    );

    if (confirmed) {
      await cubit.rejectBooking(bookingId);
    }
  }

  Future<bool> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        content: Text(
          message,
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
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              confirmText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
