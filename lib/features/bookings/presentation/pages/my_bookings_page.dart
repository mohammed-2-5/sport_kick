import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings_empty_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings_loading_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings_tab_view.dart';
import 'package:spo_kick/features/home/presentation/widgets/curved_header_clipper.dart';

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
              // Custom Header
              _buildCustomHeader(),

              // Tab Bar Container
              Transform.translate(
                offset: const Offset(0, -25),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicator: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    padding: const EdgeInsets.all(6),
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_available, size: 20),
                            SizedBox(width: 8),
                            Text(BookingConstants.upcomingTabLabel),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 20),
                            SizedBox(width: 8),
                            Text(BookingConstants.historyTabLabel),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bookings Content
              Expanded(
                child: BlocConsumer<BookingCubit, BookingState>(
                  listener: _handleStateChanges,
                  builder: _buildBody,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Stack(
      children: [
        ClipPath(
          clipper: CurvedHeaderClipper(),
          child: Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1F3A), // Deep Navy
                  Color(0xFF2C3E50), // Lighter Navy
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button & Title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      BookingConstants.myBookingsTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildBody(BuildContext context, BookingState state) {
    if (state is BookingLoading) {
      return const MyBookingsLoadingState();
    }

    if (state is BookingsEmpty) {
      return MyBookingsEmptyState(
        message: state.message ?? BookingConstants.noBookingsMessage,
        onBrowseFields: () => Navigator.of(context).pop(),
      );
    }

    if (state is BookingsLoaded) {
      return TabBarView(
        controller: _tabController,
        children: [
          MyBookingsTabView(
            bookings: state.upcomingBookings,
            emptyMessage: BookingConstants.noUpcomingMessage,
            onRefresh: _refreshBookings,
            isHistory: false,
          ),
          MyBookingsTabView(
            bookings: state.historyBookings,
            emptyMessage: BookingConstants.noHistoryMessage,
            onRefresh: _refreshBookings,
            isHistory: true,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
