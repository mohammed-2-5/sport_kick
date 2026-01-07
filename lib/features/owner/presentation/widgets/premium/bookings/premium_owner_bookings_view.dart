import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_tabs.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_view/bookings_content.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                child: BookingsContent(state: state, cubit: cubit),
              ),
            ],
          );
        },
      ),
    );
  }
}
