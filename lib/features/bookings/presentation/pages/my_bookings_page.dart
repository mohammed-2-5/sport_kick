import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/management/booking_management_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/management/booking_management_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/my_bookings_content.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/my_bookings_header.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/my_bookings_tab_selector.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_cubit.dart';

/// Page displaying user's bookings with a premium curved header design.
class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshBookings() async {
    await context.read<BookingManagementCubit>().refreshBookings();
    // Also refresh recurring bookings if the cubit exists
    if (!mounted) return;
    context.read<MyRecurringBookingsCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              MyBookingsHeader(onBack: () => Navigator.of(context).maybePop()),

              MyBookingsTabSelector(tabController: _tabController),

              // Bookings Content
              Expanded(
                child:
                    BlocConsumer<
                      BookingManagementCubit,
                      BookingManagementState
                    >(
                      listener: _handleStateChanges,
                      builder: (context, state) => MyBookingsContent(
                        state: state,
                        tabController: _tabController,
                        onRefresh: _refreshBookings,
                        onBrowseFields: () => Navigator.of(context).maybePop(),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleStateChanges(BuildContext context, BookingManagementState state) {
    if (state is BookingManagementError) {
      ErrorHandler.showErrorSnackbar(context, state.message);
    } else if (state is BookingCanceled) {
      ErrorHandler.showSuccessSnackbar(context, context.l10n.bookingCancelled);
      context.read<BookingManagementCubit>().refreshBookings();
    }
  }
}
