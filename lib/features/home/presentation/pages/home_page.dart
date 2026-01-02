import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/home/presentation/widgets/explore/explore_section.dart';
import 'package:spo_kick/features/home/presentation/widgets/hero/hero_search_section.dart';
import 'package:spo_kick/features/home/presentation/widgets/fields/nearby_fields_preview.dart';
import 'package:spo_kick/features/home/presentation/widgets/bookings/upcoming_bookings_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FieldsCubit>()..loadAllFields()),
        BlocProvider(
          create: (ctx) =>
              sl<BookingCubit>()
                ..loadUserBookings(loadingMessage: 'Loading your bookings...'),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.goNamed('login');
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    const HeroSearchSection(),
                    const SizedBox(height: 24),
                    const UpcomingBookingsWidget(),
                    const SizedBox(height: 24),
                    const NearbyFieldsPreview(),
                    const SizedBox(height: 24),
                    const ExploreSection(),
                    const SizedBox(height: 100), // Bottom padding for nav bar
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
