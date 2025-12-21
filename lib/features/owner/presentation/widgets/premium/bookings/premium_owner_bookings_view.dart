import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_proof_viewer.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_verification_dialog.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_tabs.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_list.dart';

import '../../../../../../core/localization/l10n_extensions.dart';

/// Premium view for owner bookings management.
///
/// Features:
/// - Premium header with search and stats
/// - Tab-based filtering
/// - Pull-to-refresh
/// - Approve/Reject actions
/// - Payment verification actions
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
              PremiumOwnerBookingsHeader(
                searchQuery: state is OwnerBookingsLoaded
                    ? state.searchQuery
                    : '',
                onSearchChanged: (query) => cubit.search(query),
                onClearSearch: () => cubit.clearSearch(),
                stats: stats,
              ),
              const SizedBox(height: 20),
              PremiumOwnerBookingsTabs(
                selectedIndex: state is OwnerBookingsLoaded
                    ? state.selectedTabIndex
                    : 0,
                onTabChanged: (index) => cubit.changeTab(index),
                stats: stats,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _BookingsContent(state: state, cubit: cubit),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BookingsContent extends StatelessWidget {
  final OwnerBookingsState state;
  final OwnerBookingsCubit cubit;

  const _BookingsContent({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
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
      final loadedState = state as OwnerBookingsLoaded;
      final filteredBookings = loadedState.filteredBookings;

      return PremiumOwnerBookingsList(
        bookings: filteredBookings,
        isLoading: false,
        isRefreshing: loadedState.isRefreshing,
        onRefresh: () => cubit.refresh(),
        onTap: (booking) => _handleBookingTap(context, booking),
        onApprove: (id) => _handleApprove(context, id),
        onReject: (id) => _handleReject(context, id),
        onViewPaymentProof: (booking) =>
            _handleViewPaymentProof(context, booking),
        onVerifyPayment: (id) => _handleVerifyPayment(context, id),
        onRejectPayment: (id) => _handleRejectPayment(context, id),
        emptyMessage: _getEmptyMessage(context, loadedState),
      );
    }

    return _ErrorState(onRetry: () => cubit.loadBookings());
  }

  Future<void> _handleBookingTap(
    BuildContext context,
    BookingEntity booking,
  ) async {
    final result = await context.pushNamed<bool>(
      'ownerBookingDetail',
      extra: booking,
    );
    if (result == true && context.mounted) {
      cubit.refresh();
    }
  }

  String _getEmptyMessage(BuildContext context, OwnerBookingsLoaded state) {
    if (state.searchQuery.isNotEmpty) {
      return context.l10n.noBookingsMatchYourSearch;
    }
    switch (state.selectedTabIndex) {
      case 1:
        return context.l10n.noPendingBookings;
      case 2:
        return context.l10n.noConfirmedBookings;
      case 3:
        return context.l10n.noCanceledBookings;
      default:
        return context.l10n.noBookingsYet;
    }
  }

  Future<void> _handleApprove(BuildContext context, String bookingId) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: context.l10n.approveBooking,
      message: context.l10n.ownerApproveBookingConfirm,
      confirmText: context.l10n.approve,
      confirmColor: Colors.green,
    );
    if (confirmed) {
      await cubit.approveBooking(bookingId);
    }
  }

  Future<void> _handleReject(BuildContext context, String bookingId) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: context.l10n.rejectBooking,
      message: context.l10n.ownerRejectBookingConfirm,
      confirmText: context.l10n.reject,
      confirmColor: Colors.red,
    );
    if (confirmed) {
      await cubit.rejectBooking(bookingId);
    }
  }

  void _handleViewPaymentProof(BuildContext context, BookingEntity booking) {
    if (booking.paymentProofUrl != null) {
      PaymentProofViewer.show(
        context,
        imageUrl: booking.paymentProofUrl!,
        bookingId: booking.id,
      );
    }
  }

  Future<void> _handleVerifyPayment(
    BuildContext context,
    String bookingId,
  ) async {
    final confirmed = await PaymentVerificationDialog.showVerifyDialog(context);
    if (confirmed == true) {
      await cubit.verifyPayment(bookingId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.paymentVerifiedSuccess),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleRejectPayment(
    BuildContext context,
    String bookingId,
  ) async {
    final reason = await PaymentVerificationDialog.showRejectDialog(context);
    if (reason != null && reason.isNotEmpty) {
      await cubit.rejectPayment(bookingId, reason);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.paymentRejectedSuccess),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
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
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              context.l10n.cancel,
              style: AppTextStyles.bodyMedium.copyWith(
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
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            context.l10n.failedToLoadBookings,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
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
}
