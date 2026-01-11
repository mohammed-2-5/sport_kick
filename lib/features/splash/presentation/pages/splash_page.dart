import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../widgets/premium/premium_splash_view.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>()..initializeApp(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToHome) {
            if (state.userRole == 'super_admin') {
              context.goNamed('superAdminDashboard');
            } else if (state.userRole == 'admin') {
              context.goNamed('ownerDashboard');
            } else {
              context.goNamed('home');
            }
          } else if (state is SplashNavigateToLogin) {
            context.goNamed('login');
          } else if (state is SplashNavigateToOnboarding) {
            context.goNamed('onboarding');
          } else if (state is SplashNavigateToCitySelection) {
            context.goNamed('citySelection');
          }
        },
        child: Builder(
          builder: (context) {
            return PremiumSplashView(
              appName: context.l10n.appName,
              tagline: context.l10n.appTagline,
              child: const SizedBox(),
            );
          },
        ),
      ),
    );
  }
}
