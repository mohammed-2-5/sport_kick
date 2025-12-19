import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/booking_actions_sheet.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/cancel_booking_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/premium_all_booking_card.dart';

/// Premium All Bookings view with tabbed filtering.
///
/// Features:
/// - Premium curved header
/// - Tab-based status filtering
/// - Search bar with blur effect
/// - Stats row with booking counts
/// - Staggered booking cards list
/// - Pull-to-refresh
/// - Booking actions (confirm, complete, cancel)
/// - Empty and error states
class PremiumAllBookingsView extends StatefulWidget {
  const PremiumAllBookingsView({super.key});

  @override
  State<PremiumAllBookingsView> createState() => _PremiumAllBookingsViewState();
}

class _PremiumAllBookingsViewState extends State<PremiumAllBookingsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';

  final _tabs = const [
    _TabItem(label: 'All', status: null),
    _TabItem(label: 'Pending', status: BookingStatus.pending),
    _TabItem(label: 'Confirmed', status: BookingStatus.confirmed),
    _TabItem(label: 'Completed', status: BookingStatus.completed),
    _TabItem(label: 'Canceled', status: BookingStatus.canceled),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  void _showBookingActions(BookingEntity booking) {
    BookingActionsSheet.show(
      context: context,
      booking: booking,
      onConfirm: () {
        context.read<SuperAdminCubit>().updateBookingStatus(
          bookingId: booking.id,
          status: BookingStatus.confirmed,
        );
      },
      onComplete: () {
        context.read<SuperAdminCubit>().updateBookingStatus(
          bookingId: booking.id,
          status: BookingStatus.completed,
        );
      },
      onCancel: () => _showCancelDialog(booking),
    );
  }

  void _showCancelDialog(BookingEntity booking) {
    CancelBookingDialog.show(
      context: context,
      booking: booking,
      onConfirm: (reason) {
        context.read<SuperAdminCubit>().cancelBooking(
          bookingId: booking.id,
          reason: reason,
        );
      },
    );
  }

  List<BookingEntity> _filterBookings(
    List<BookingEntity> bookings,
    BookingStatus? statusFilter,
  ) {
    var result = bookings;

    // Filter by status
    if (statusFilter != null) {
      result = result.where((b) => b.status == statusFilter).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((b) {
        return (b.userName?.toLowerCase().contains(query) ?? false) ||
            (b.fieldName?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Sort by date (newest first)
    result.sort((a, b) => b.date.compareTo(a.date));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuperAdminCubit, SuperAdminState>(
      listener: (context, state) {
        if (state is SuperAdminError) {
          SnackbarHelper.showError(context, state.message);
        } else if (state is BookingStatusUpdated) {
          SnackbarHelper.showSuccess(context, state.successMessage);
        } else if (state is BookingCancelled) {
          SnackbarHelper.showSuccess(context, state.successMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SuperAdminState state) {
    if (state is SuperAdminLoading) {
      return _LoadingView(message: state.message);
    }

    if (state is SuperAdminError) {
      return _ErrorView(
        message: state.message,
        onRetry: () => context.read<SuperAdminCubit>().loadAllBookings(),
      );
    }

    if (state is AllBookingsLoaded) {
      return _buildLoadedContent(context, state.bookings.cast<BookingEntity>());
    }

    return const _LoadingView(message: 'Loading bookings...');
  }

  Widget _buildLoadedContent(
    BuildContext context,
    List<BookingEntity> bookings,
  ) {
    // Calculate counts for each status
    final pendingCount = bookings
        .where((b) => b.status == BookingStatus.pending)
        .length;
    final confirmedCount = bookings
        .where((b) => b.status == BookingStatus.confirmed)
        .length;
    final completedCount = bookings
        .where((b) => b.status == BookingStatus.completed)
        .length;
    final canceledCount = bookings
        .where((b) => b.status == BookingStatus.canceled)
        .length;

    return RefreshIndicator(
      color: AppColors.goldAccent,
      onRefresh: () async {
        context.read<SuperAdminCubit>().loadAllBookings();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Premium Header
            SliverToBoxAdapter(
              child: PremiumCurvedHeader(
                title: 'All Bookings',
                subtitle: '${bookings.length} total bookings',
                showBackButton: true,
                actions: [
                  _RefreshButton(
                    onTap: () =>
                        context.read<SuperAdminCubit>().loadAllBookings(),
                  ),
                ],
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _SearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ),
            ),

            // Stats Row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _StatChip(
                        label: 'Pending',
                        count: pendingCount,
                        color: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        label: 'Confirmed',
                        count: confirmedCount,
                        color: const Color(0xFF10B981),
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        label: 'Completed',
                        count: completedCount,
                        color: const Color(0xFF6366F1),
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        label: 'Canceled',
                        count: canceledCount,
                        color: const Color(0xFFEF4444),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tab Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: _PremiumTabBar(controller: _tabController, tabs: _tabs),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((tab) {
            final filteredBookings = _filterBookings(bookings, tab.status);
            return _BookingsList(
              bookings: filteredBookings,
              onBookingTap: _showBookingActions,
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Tab item data.
class _TabItem {
  final String label;
  final BookingStatus? status;

  const _TabItem({required this.label, this.status});
}

/// Premium tab bar.
class _PremiumTabBar extends StatelessWidget {
  final TabController controller;
  final List<_TabItem> tabs;

  const _PremiumTabBar({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        indicator: BoxDecoration(
          color: AppColors.navyDeep,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(4),
        tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
      ),
    );
  }
}

/// Bookings list widget.
class _BookingsList extends StatelessWidget {
  final List<BookingEntity> bookings;
  final void Function(BookingEntity booking)? onBookingTap;

  const _BookingsList({required this.bookings, this.onBookingTap});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const _EmptyState();
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: PremiumAllBookingCard(
                  bookingId: booking.id,
                  userName: booking.userName ?? 'Unknown User',
                  fieldName: booking.fieldName ?? 'Unknown Field',
                  formattedDate: booking.formattedDate,
                  formattedTimeSlot: booking.formattedTimeSlot,
                  formattedPrice: booking.formattedPrice,
                  status: booking.status,
                  isManual: booking.isManual,
                  onTap: () {
                    onBookingTap?.call(booking);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Search bar widget.
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search by user or field...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

/// Stat chip widget.
class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Refresh button.
class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RefreshButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassHighlight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.refresh_rounded,
          color: AppColors.textOnNavy,
          size: 22,
        ),
        onPressed: onTap,
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
          const CircularProgressIndicator(
            color: AppColors.goldAccent,
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary,
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
            Text(
              'Failed to load bookings',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
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

/// Empty state.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: AppColors.accentCyan.withValues(alpha: 0.6),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No bookings found',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search\nor filters',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
