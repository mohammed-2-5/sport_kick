import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_strings.dart';
import 'package:spo_kick/features/owner/presentation/constants/owner_strings.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/owner_bookings_list_widget.dart';

/// Owner Bookings Management Page
///
/// Allows owners to:
/// - View all bookings for their fields
/// - Filter by status (pending, confirmed, canceled)
/// - Approve or reject pending bookings
/// - View booking details
class OwnerBookingsPage extends StatefulWidget {
  const OwnerBookingsPage({super.key});

  @override
  State<OwnerBookingsPage> createState() => _OwnerBookingsPageState();
}

class _OwnerBookingsPageState extends State<OwnerBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Load bookings using cubit
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadOwnerBookings(ownerId: authState.user.id);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(OwnerStrings.manageBookings),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primary),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: OwnerStrings.tabAll),
            Tab(text: OwnerStrings.tabPending),
            Tab(text: OwnerStrings.tabConfirmed),
            Tab(text: OwnerStrings.tabCanceled),
          ],
        ),
      ),
      body: BlocConsumer<OwnerCubit, OwnerState>(
        listener: (context, state) {
          if (state is OwnerError) {
            SnackbarHelper.showError(context, state.message);
          } else if (state is OwnerActionSuccess) {
            SnackbarHelper.showSuccess(context, state.message);
            // Reload bookings to reflect changes
            final authState = context.read<AuthCubit>().state;
            if (authState is Authenticated) {
              context.read<OwnerCubit>().loadOwnerBookings(
                ownerId: authState.user.id,
              );
            }
          }
        },
        builder: (context, state) {
          if (state is OwnerLoading) {
            return const LoadingIndicator.inline(
              message: 'Loading bookings...',
            );
          }

          if (state is OwnerDataLoaded || state is OwnerBookingsLoaded) {
            final bookings = state is OwnerDataLoaded
                ? state.bookings
                : (state as OwnerBookingsLoaded).bookings;

            return TabBarView(
              controller: _tabController,
              children: [
                OwnerBookingsListWidget(bookings: bookings),
                OwnerBookingsListWidget(
                  bookings: bookings
                      .where((b) => b.status == BookingStatus.pending)
                      .toList(),
                ),
                OwnerBookingsListWidget(
                  bookings: bookings
                      .where((b) => b.status == BookingStatus.confirmed)
                      .toList(),
                ),
                OwnerBookingsListWidget(
                  bookings: bookings
                      .where((b) => b.status == BookingStatus.canceled)
                      .toList(),
                ),
              ],
            );
          }

          if (state is OwnerError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        final authState = context.read<AuthCubit>().state;
                        if (authState is Authenticated) {
                          context.read<OwnerCubit>().loadOwnerBookings(
                            ownerId: authState.user.id,
                          );
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text(AppStrings.retry),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
