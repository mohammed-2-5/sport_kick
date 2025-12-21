import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/route_builders.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/pages/city_selection_page.dart';
import 'package:spo_kick/features/home/presentation/pages/main_layout_page.dart';
import 'package:spo_kick/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:spo_kick/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:spo_kick/features/settings/presentation/pages/terms_of_service_page.dart';
import 'package:spo_kick/features/settings/presentation/pages/user_settings_page.dart';
import 'package:spo_kick/features/splash/presentation/pages/splash_page.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:spo_kick/features/notifications/presentation/pages/notification_list_page.dart';

/// Common application routes (splash, onboarding, settings, etc.)
final List<GoRoute> commonRoutes = [
  // ==================== SPLASH & ONBOARDING ====================
  GoRoute(
    path: '/',
    name: 'splash',
    pageBuilder: (context, state) =>
        buildPage(child: const SplashPage(), state: state),
  ),
  GoRoute(
    path: '/onboarding',
    name: 'onboarding',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const OnboardingPage(), state: state),
  ),

  // ==================== MAIN APP ====================
  GoRoute(
    path: '/city-selection',
    name: 'citySelection',
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<CityCubit>()..loadCities(),
        child: const CitySelectionPage(),
      ),
      state: state,
    ),
  ),
  GoRoute(
    path: '/home',
    name: 'home',
    pageBuilder: (context, state) =>
        buildPage(child: const MainLayoutPage(), state: state),
  ),

  // ==================== SETTINGS ====================
  GoRoute(
    path: '/settings',
    name: 'settings',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const UserSettingsPage(), state: state),
  ),
  GoRoute(
    path: '/privacy-policy',
    name: 'privacyPolicy',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const PrivacyPolicyPage(), state: state),
  ),
  GoRoute(
    path: '/terms-of-service',
    name: 'termsOfService',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const TermsOfServicePage(), state: state),
  ),

  // ==================== NOTIFICATIONS ====================
  GoRoute(
    path: '/notifications',
    name: 'notifications',
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<NotificationCubit>(),
        child: const NotificationListPage(),
      ),
      state: state,
    ),
  ),
];
