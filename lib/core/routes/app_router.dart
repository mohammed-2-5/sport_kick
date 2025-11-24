import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/pages/login_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/profile_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/register_page.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/pages/booking_details_page.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:spo_kick/features/bookings/presentation/pages/my_bookings_page.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/pages/favorites_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/field_details_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/fields_list_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/search_page.dart';
import 'package:spo_kick/features/home/presentation/pages/home_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/add_edit_field_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_analytics_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_bookings_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_dashboard_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_fields_page.dart';
import 'package:spo_kick/features/splash/splash_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_dashboard_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/create_admin_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/admins_list_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/users_list_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/cities_page.dart';

/// Application routing configuration.
///
/// Centralized routing for the entire application using named routes.
/// Handles navigation and route arguments.
///
/// Usage:
/// ```dart
/// // In MaterialApp
/// onGenerateRoute: AppRouter.generateRoute,
///
/// // Navigate to a route
/// Navigator.pushNamed(context, AppRouter.fieldDetails, arguments: fieldId);
/// ```
class AppRouter {
  // Prevent instantiation
  AppRouter._();

  // ==================== ROUTE NAMES ====================

  /// Splash screen route (initial route)
  static const String splash = '/';

  /// Login screen route
  static const String login = '/login';

  /// Register screen route
  static const String register = '/register';

  /// Home screen route (fields list)
  static const String home = '/home';

  /// Fields list screen route
  static const String fieldsList = '/fields';

  /// Field details screen route
  /// Arguments: String fieldId
  static const String fieldDetails = '/field-details';

  /// Create booking screen route
  /// Arguments: FieldEntity field
  static const String createBooking = '/create-booking';

  /// My bookings screen route
  static const String myBookings = '/my-bookings';

  /// Booking details screen route
  /// Arguments: String bookingId
  static const String bookingDetails = '/booking-details';

  /// Profile screen route
  static const String profile = '/profile';

  /// Edit profile screen route
  static const String editProfile = '/edit-profile';

  /// Settings screen route
  static const String settings = '/settings';

  /// Search fields screen route
  static const String search = '/search';

  /// Favorites screen route
  static const String favorites = '/favorites';

  // Owner Dashboard Routes
  /// Owner dashboard main screen route
  static const String ownerDashboard = '/owner/dashboard';

  /// Owner bookings management screen route
  static const String ownerBookings = '/owner/bookings';

  /// Owner fields management screen route
  static const String ownerFields = '/owner/fields';

  /// Owner add field screen route
  static const String ownerAddField = '/owner/fields/add';

  /// Owner edit field screen route
  /// Arguments: String fieldId
  static const String ownerEditField = '/owner/fields/edit';

  /// Owner analytics screen route
  static const String ownerAnalytics = '/owner/analytics';

  /// Owner settings screen route
  static const String ownerSettings = '/owner/settings';

  // Super Admin Routes
  /// Super admin dashboard main screen route
  static const String superAdminDashboard = '/super-admin/dashboard';

  /// Super admin create admin screen route
  static const String superAdminCreateAdmin = '/super-admin/create-admin';

  /// Super admin view admins screen route
  static const String superAdminAdmins = '/super-admin/admins';

  /// Super admin view users screen route
  static const String superAdminUsers = '/super-admin/users';

  /// Super admin manage cities screen route
  static const String superAdminCities = '/super-admin/cities';

  // ==================== ROUTE GENERATOR ====================

  /// Generate routes based on route settings.
  ///
  /// Handles all route navigation and argument passing.
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return _buildRoute(
          settings: routeSettings,
          builder: (_) => const SplashPage(),
        );

      case login:
        return _buildRoute(
          settings: routeSettings,
          builder: (_) => const LoginPage(),
        );

      case register:
        return _buildRoute(
          settings: routeSettings,
          builder: (_) => const RegisterPage(),
        );

      case home:
        return _buildRoute(
          settings: routeSettings,
          builder: (_) => const HomePage(),
        );

      case fieldsList:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => const FieldsListPage(),
        );

      case fieldDetails:
        // Expects: String fieldId
        final fieldId = routeSettings.arguments as String?;
        if (fieldId == null) {
          return _buildErrorRoute('Field ID is required');
        }
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => FieldDetailsPage(fieldId: fieldId),
        );

      case createBooking:
        // Expects: FieldEntity field
        final field = routeSettings.arguments as FieldEntity?;
        if (field == null) {
          return _buildErrorRoute('Field data is required');
        }
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => CreateBookingPage(field: field),
        );

      case myBookings:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => BlocProvider(
            create: (_) => sl<BookingCubit>()..loadUserBookings(),
            child: const MyBookingsPage(),
          ),
        );

      case bookingDetails:
        // Expects: String bookingId
        final bookingId = routeSettings.arguments as String?;
        if (bookingId == null) {
          return _buildErrorRoute('Booking ID is required');
        }
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => BlocProvider(
            create: (_) => sl<BookingCubit>()..loadBookingById(bookingId),
            child: BookingDetailsPage(bookingId: bookingId),
          ),
        );

      case profile:
        return _buildRoute(
          settings: routeSettings,
          builder: (_) => const ProfilePage(),
        );

      case editProfile:
        return _buildRoute(
          settings: routeSettings,
          // TODO: Import and use EditProfilePage when implemented
          builder: (_) => const Scaffold(
            body: Center(child: Text('Edit Profile Page')),
          ),
        );

      case settings:
        return _buildRoute(
          settings: routeSettings,
          // TODO: Import and use SettingsPage when implemented
          builder: (_) => const Scaffold(
            body: Center(child: Text('Settings Page')),
          ),
        );

      case search:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => const SearchPage(),
        );

      case favorites:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => const FavoritesPage(),
        );

      // Owner Dashboard Routes
      case ownerDashboard:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<BookingCubit>()..loadOwnerBookings(),
              ),
              BlocProvider(
                create: (_) => sl<FieldsCubit>()..loadAllFields(),
              ),
            ],
            child: const OwnerDashboardPage(),
          ),
        );

      case ownerBookings:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => BlocProvider(
            create: (_) => sl<BookingCubit>()..loadOwnerBookings(),
            child: const OwnerBookingsPage(),
          ),
        );

      case ownerFields:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => BlocProvider(
            create: (_) => sl<FieldsCubit>()..loadAllFields(),
            child: const OwnerFieldsPage(),
          ),
        );

      case ownerAddField:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => const AddEditFieldPage(),
        );

      case ownerEditField:
        // Expects: String fieldId
        final fieldId = routeSettings.arguments as String?;
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => AddEditFieldPage(fieldId: fieldId),
        );

      case ownerAnalytics:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<BookingCubit>()..loadOwnerBookings(),
              ),
              BlocProvider(
                create: (_) => sl<FieldsCubit>()..loadAllFields(),
              ),
            ],
            child: const OwnerAnalyticsPage(),
          ),
        );

      case ownerSettings:
        return _buildRoute(
          settings: routeSettings,
          // TODO: Create owner settings page
          builder: (_) =>  Scaffold(
            appBar: AppBar(title:  Text('Owner Settings')),
            body: Center(child: Text('Owner Settings Page')),
          ),
        );

      // Super Admin Routes
      case superAdminDashboard:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => const SuperAdminDashboardPage(),
        );

      case superAdminCreateAdmin:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => const CreateAdminPage(),
        );

      case superAdminAdmins:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => const AdminsListPage(),
        );

      case superAdminUsers:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => const UsersListPage(),
        );

      case superAdminCities:
        return _buildSlideRoute(
          settings: routeSettings,
          builder: (_) => const CitiesPage(),
        );

      default:
        return _buildErrorRoute('Route not found: ${routeSettings.name}');
    }
  }

  // ==================== HELPER METHODS ====================

  /// Build a route with custom transitions
  static Route<dynamic> _buildRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: builder,
    );
  }

  /// Build a route with fade transition
  static Route<dynamic> _buildFadeRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Build a route with slide transition
  static Route<dynamic> _buildSlideRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Build error route when navigation fails
  static Route<dynamic> _buildErrorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension methods for easier navigation
extension NavigationExtensions on BuildContext {
  /// Push named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }

  /// Push named route and remove all previous routes
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      this,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Replace current route with named route
  Future<T?> pushReplacementNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, void>(
      this,
      routeName,
      arguments: arguments,
    );
  }

  /// Pop current route
  void pop<T>([T? result]) {
    Navigator.pop<T>(this, result);
  }

  /// Pop until specific route
  void popUntil(String routeName) {
    Navigator.popUntil(this, ModalRoute.withName(routeName));
  }
}
