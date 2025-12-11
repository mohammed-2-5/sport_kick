import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/my_bookings_content.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/my_bookings_header.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/my_bookings_tab_selector.dart';

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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshBookings() async {
    await context.read<BookingCubit>().refreshBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          Column(
            children: [
              MyBookingsHeader(onBack: () => Navigator.of(context).maybePop()),

              MyBookingsTabSelector(tabController: _tabController),

              // Bookings Content
              Expanded(
                child: BlocConsumer<BookingCubit, BookingState>(
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

  void _handleStateChanges(BuildContext context, BookingState state) {
    if (state is BookingError) {
      ErrorHandler.showErrorSnackbar(context, state.message);
    } else if (state is BookingCanceled) {
      ErrorHandler.showSuccessSnackbar(
        context,
        BookingConstants.bookingCancelledMessage,
      );
      context.read<BookingCubit>().refreshBookings();
    }
  }
}
