import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/pages/profile_page.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/pages/my_bookings_page.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/pages/fields_list_page.dart';
import 'package:spo_kick/features/home/presentation/cubit/navigation/navigation_cubit.dart';
import 'package:spo_kick/features/home/presentation/cubit/navigation/navigation_state.dart';
import 'package:spo_kick/features/home/presentation/pages/home_page.dart';
import 'package:spo_kick/features/home/presentation/widgets/premium/navigation/premium_bottom_nav_bar.dart';
import 'package:spo_kick/features/home/presentation/widgets/premium/navigation/premium_floating_action_button.dart';

/// Premium main layout view with glassmorphism navigation.
///
/// Features:
/// - Floating glassmorphism bottom navigation
/// - Animated page transitions
/// - Premium floating action button
/// - All logic handled by NavigationCubit
class PremiumMainLayoutView extends StatelessWidget {
  const PremiumMainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        if (state is! NavigationActive) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<NavigationCubit>();

        return Scaffold(
          extendBody: true,
          body: _MainContent(
            currentIndex: state.currentIndex,
            previousIndex: state.previousIndex,
          ),
          floatingActionButton: _FloatingButton(
            visible: state.showFab && state.currentIndex == 0,
            onPressed: () => context.pushNamed('fieldsList'),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: PremiumBottomNavBar(
            currentIndex: state.currentIndex,
            onTap: cubit.changeTab,
          ),
        );
      },
    );
  }
}

/// Main content with page transitions.
class _MainContent extends StatelessWidget {
  final int currentIndex;
  final int previousIndex;

  const _MainContent({required this.currentIndex, required this.previousIndex});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: [
        // Home
        const HomePage(),

        // Explore (Fields List)
        BlocProvider(
          create: (_) => sl<FieldsCubit>()..loadAllFields(),
          child: const FieldsListPage(),
        ),

        // Bookings
        BlocProvider(
          create: (_) => sl<BookingCubit>()..loadUserBookings(),
          child: const MyBookingsPage(),
        ),

        // Profile
        const ProfilePage(),
      ],
    );
  }
}

/// Floating action button wrapper.
class _FloatingButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  const _FloatingButton({required this.visible, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: PremiumFloatingActionButton(
        visible: visible,
        onPressed: onPressed,
      ),
    );
  }
}
