import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/pages/my_bookings_page.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/pages/fields_list_page.dart';
import 'package:spo_kick/features/home/presentation/pages/home_page.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/pages/user_settings_page.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      BlocProvider(
        create: (_) => sl<FieldsCubit>()..loadAllFields(),
        child: const FieldsListPage(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<BookingCubit>()
              ..loadUserBookings(loadingMessage: 'Loading your bookings...'),
          ),
          BlocProvider(
            create: (_) =>
                sl<MyRecurringBookingsCubit>()..loadRecurringBookings(),
          ),
        ],
        child: const MyBookingsPage(),
      ),
      const UserSettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: AppColors.primary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.primary.withValues(alpha: 0.1),
              color: AppColors.textSecondary,
              tabs: [
                GButton(
                  icon: Icons.home_rounded,
                  text: context.l10n.homeNavHome,
                ),
                GButton(
                  icon: Icons.search_rounded,
                  text: context.l10n.homeNavExplore,
                ),
                GButton(
                  icon: Icons.calendar_today_rounded,
                  text: context.l10n.homeNavBookings,
                ),
                GButton(
                  icon: Icons.settings_rounded,
                  text: context.l10n.homeNavSettings,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
