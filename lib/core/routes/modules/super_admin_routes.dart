import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/route_builders.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/admin_details_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/admins_list_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/all_bookings_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/all_fields_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/cities_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/create_admin_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/create_field_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/edit_field_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/manage_notifications_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/manage_reviews_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/manage_sport_categories_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/platform_analytics_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/platform_operating_hours_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_dashboard_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_login_activity_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_reports_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_settings_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/user_details_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/users_list_page.dart';

/// Super Admin routes (platform management, user management, etc.)
final List<GoRoute> superAdminRoutes = [
  // ==================== SUPER ADMIN DASHBOARD ====================
  GoRoute(
    path: '/super-admin/dashboard',
    name: 'superAdminDashboard',
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<SuperAdminCubit>()..loadPlatformStatistics(),
        child: const SuperAdminDashboardPage(),
      ),
      state: state,
    ),
  ),

  // ==================== SUPER ADMIN - USER MANAGEMENT ====================
  GoRoute(
    path: '/super-admin/users',
    name: 'superAdminUsers',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const UsersListPage(), state: state),
  ),
  GoRoute(
    path: '/super-admin/user-details',
    name: 'superAdminUserDetails',
    pageBuilder: (context, state) {
      final user = state.extra as UserEntity?;
      if (user == null) {
        return buildPage(
          child: const ErrorPage(error: 'User data is required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: UserDetailsPage(user: user),
        state: state,
      );
    },
  ),

  // ==================== SUPER ADMIN - ADMIN MANAGEMENT ====================
  GoRoute(
    path: '/super-admin/admins',
    name: 'superAdminAdmins',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const AdminsListPage(), state: state),
  ),
  GoRoute(
    path: '/super-admin/admin-details',
    name: 'superAdminAdminDetails',
    pageBuilder: (context, state) {
      final admin = state.extra as UserEntity?;
      if (admin == null) {
        return buildPage(
          child: const ErrorPage(error: 'Admin data is required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: AdminDetailsPage(admin: admin),
        state: state,
      );
    },
  ),
  GoRoute(
    path: '/super-admin/create-admin',
    name: 'superAdminCreateAdmin',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const CreateAdminPage(), state: state),
  ),

  // ==================== SUPER ADMIN - FIELD MANAGEMENT ====================
  GoRoute(
    path: '/super-admin/fields',
    name: 'superAdminFields',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const AllFieldsPage(), state: state),
  ),
  GoRoute(
    path: '/super-admin/create-field',
    name: 'superAdminCreateField',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const CreateFieldPage(), state: state),
  ),
  GoRoute(
    path: '/super-admin/edit-field',
    name: 'superAdminEditField',
    pageBuilder: (context, state) {
      final field = state.extra as FieldEntity?;
      if (field == null) {
        return buildPage(
          child: const ErrorPage(error: 'Field data is required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: EditFieldPage(field: field),
        state: state,
      );
    },
  ),

  // ==================== SUPER ADMIN - CITY MANAGEMENT ====================
  GoRoute(
    path: '/super-admin/cities',
    name: 'superAdminCities',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const CitiesPage(), state: state),
  ),

  // ==================== SUPER ADMIN - BOOKINGS ====================
  GoRoute(
    path: '/super-admin/bookings',
    name: 'superAdminBookings',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const AllBookingsPage(), state: state),
  ),

  // ==================== SUPER ADMIN - ANALYTICS & REPORTS ====================
  GoRoute(
    path: '/super-admin/analytics',
    name: 'superAdminAnalytics',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const PlatformAnalyticsPage(), state: state),
  ),
  GoRoute(
    path: '/super-admin/reports',
    name: 'superAdminReports',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const SuperAdminReportsPage(), state: state),
  ),

  // ==================== SUPER ADMIN - SETTINGS & CONFIGURATION ====================
  GoRoute(
    path: '/super-admin/settings',
    name: 'superAdminSettings',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const SuperAdminSettingsPage(), state: state),
  ),
  GoRoute(
    path: '/super-admin/sport-categories',
    name: 'manageSportCategories',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const ManageSportCategoriesPage(), state: state),
  ),
  GoRoute(
    path: '/super-admin/operating-hours',
    name: 'platformOperatingHours',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const PlatformOperatingHoursPage(), state: state),
  ),

  // ==================== SUPER ADMIN - CONTENT MANAGEMENT ====================
  GoRoute(
    path: '/super-admin/reviews',
    name: 'manageReviews',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const ManageReviewsPage(), state: state),
  ),
  GoRoute(
    path: '/super-admin/notifications',
    name: 'manageNotifications',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const ManageNotificationsPage(), state: state),
  ),

  // ==================== SUPER ADMIN - LOGIN ACTIVITY ====================
  GoRoute(
    path: '/super-admin/login-activity',
    name: 'superAdminLoginActivity',
    pageBuilder: (context, state) => buildSlidePage(
      child: const SuperAdminLoginActivityPage(),
      state: state,
    ),
  ),
];
