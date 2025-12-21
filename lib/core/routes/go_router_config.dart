import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/routes/route_builders.dart';
import 'package:spo_kick/core/routes/modules/auth_routes.dart';
import 'package:spo_kick/core/routes/modules/common_routes.dart';
import 'package:spo_kick/core/routes/modules/owner_routes.dart';
import 'package:spo_kick/core/routes/modules/super_admin_routes.dart';
import 'package:spo_kick/core/routes/modules/user_routes.dart';

/// GoRouter configuration for the Sport Kick application.
///
/// Centralized routing configuration using the GoRouter package.
/// Routes are organized by feature modules for better maintainability:
/// - common_routes: Splash, onboarding, settings, notifications
/// - auth_routes: Login, register, profile, password management
/// - user_routes: Fields browsing, bookings, reviews, recurring bookings
/// - owner_routes: Owner dashboard, field management, revenue tracking
/// - super_admin_routes: Platform management, user/admin management, analytics
///
/// All routes use type-safe navigation with named routes and declarative patterns.
class AppRouterConfig {
  // Prevent instantiation
  AppRouterConfig._();

  /// Create and configure the GoRouter instance
  static GoRouter createRouter() {
    return GoRouter(
      debugLogDiagnostics: false,
      initialLocation: '/',
      errorBuilder: (context, state) =>
          ErrorPage(error: state.error?.toString() ?? 'Unknown error'),
      routes: [
        // Combine all route modules
        ...commonRoutes,
        ...authRoutes,
        ...userRoutes,
        ...ownerRoutes,
        ...superAdminRoutes,
      ],
    );
  }
}
