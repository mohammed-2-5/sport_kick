import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/booking_actions_sheet.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/cancel_booking_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/bookings_list.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/error_view.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/loading_view.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/premium_tab_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/refresh_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/stat_chip.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/tab_item.dart';

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
  late List<TabItem> _tabs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabs = [
      TabItem(label: context.l10n.all, status: null),
      TabItem(label: context.l10n.pending, status: BookingStatus.pending),
      TabItem(
        label: context.l10n.statusConfirmed,
        status: BookingStatus.confirmed,
      ),
      TabItem(
        label: context.l10n.statusCompleted,
        status: BookingStatus.completed,
      ),
      TabItem(
        label: context.l10n.statusCanceled,
        status: BookingStatus.canceled,
      ),
    ];
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

    if (statusFilter != null) {
      result = result.where((b) => b.status == statusFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((b) {
        return (b.userName?.toLowerCase().contains(query) ?? false) ||
            (b.fieldName?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

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
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SuperAdminState state) {
    if (state is SuperAdminLoading) {
      return LoadingView(message: state.message);
    }

    if (state is SuperAdminError) {
      return ErrorView(
        message: state.message,
        onRetry: () => context.read<SuperAdminCubit>().loadAllBookings(),
      );
    }

    if (state is AllBookingsLoaded) {
      return _buildLoadedContent(context, state.bookings.cast<BookingEntity>());
    }

    return LoadingView(message: context.l10n.loadingBookings);
  }

  Widget _buildLoadedContent(
    BuildContext context,
    List<BookingEntity> bookings,
  ) {
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
            SliverToBoxAdapter(
              child: PremiumCurvedHeader(
                title: context.l10n.allBookings,
                subtitle: context.l10n.totalBookingsCount(bookings.length),
                showBackButton: true,
                actions: [
                  RefreshButton(
                    onTap: () =>
                        context.read<SuperAdminCubit>().loadAllBookings(),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: BookingsSearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      StatChip(
                        label: context.l10n.pending,
                        count: pendingCount,
                        color: Theme.of(context).colorScheme.warning,
                      ),
                      const SizedBox(width: 10),
                      StatChip(
                        label: context.l10n.statusConfirmed,
                        count: confirmedCount,
                        color: Theme.of(context).colorScheme.success,
                      ),
                      const SizedBox(width: 10),
                      StatChip(
                        label: context.l10n.statusCompleted,
                        count: completedCount,
                        color: Theme.of(context).colorScheme.info,
                      ),
                      const SizedBox(width: 10),
                      StatChip(
                        label: context.l10n.statusCanceled,
                        count: canceledCount,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: PremiumTabBar(controller: _tabController, tabs: _tabs),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((tab) {
            final filteredBookings = _filterBookings(bookings, tab.status);
            return BookingsList(
              bookings: filteredBookings,
              onBookingTap: _showBookingActions,
            );
          }).toList(),
        ),
      ),
    );
  }
}
