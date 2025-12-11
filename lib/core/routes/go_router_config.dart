import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/pages/admin_login_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/change_password_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/login_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/profile_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/register_page.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/edit_profile_dialog.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/pages/booking_details_page.dart';
import 'package:spo_kick/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:spo_kick/features/bookings/presentation/pages/my_bookings_page.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_cubit.dart';
import 'package:spo_kick/features/business_hours/presentation/pages/manage_business_hours_page.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/pages/city_selection_page.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/pages/favorites_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/field_details_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/fields_list_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/fields_map_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/search_page.dart';
import 'package:spo_kick/features/home/presentation/pages/main_layout_page.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/pages/add_edit_field_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/create_manual_booking_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_analytics_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_bookings_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_dashboard_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_fields_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_profile_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_settings_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_field_detail_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_revenue_page.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/pages/all_reviews_page.dart';
import 'package:spo_kick/features/reviews/presentation/pages/create_review_page.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:spo_kick/features/settings/presentation/pages/terms_of_service_page.dart';
import 'package:spo_kick/features/settings/presentation/pages/user_settings_page.dart';
import 'package:spo_kick/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:spo_kick/features/splash/presentation/pages/splash_page.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/admin_details_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/admins_list_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/all_bookings_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/all_fields_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/cities_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/create_admin_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/create_field_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/platform_analytics_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_dashboard_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_reports_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_settings_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/user_details_page.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/users_list_page.dart';

/// GoRouter configuration for the Sport Kick application.
///
/// Centralized routing configuration using the GoRouter package.
/// Provides type-safe navigation, better deep linking support, and cleaner API.
class AppRouterConfig {
  // Prevent instantiation
  AppRouterConfig._();

  /// Create and configure the GoRouter instance
  static GoRouter createRouter() {
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/',
      errorBuilder: (context, state) =>
          _ErrorPage(error: state.error?.toString() ?? 'Unknown error'),
      routes: [
        // ==================== AUTH ROUTES ====================
        GoRoute(
          path: '/',
          name: 'splash',
          pageBuilder: (context, state) =>
              _buildPage(child: const SplashPage(), state: state),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const OnboardingPage(), state: state),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) =>
              _buildPage(child: const LoginPage(), state: state),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          pageBuilder: (context, state) =>
              _buildPage(child: const RegisterPage(), state: state),
        ),
        GoRoute(
          path: '/admin-login',
          name: 'adminLogin',
          pageBuilder: (context, state) =>
              _buildPage(child: const AdminLoginPage(), state: state),
        ),
        GoRoute(
          path: '/change-password',
          name: 'changePassword',
          pageBuilder: (context, state) {
            final isFirstLogin =
                state.uri.queryParameters['isFirstLogin'] == 'true';
            return _buildSlidePage(
              child: ChangePasswordPage(isFirstLogin: isFirstLogin),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgotPassword',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const ForgotPasswordPage(), state: state),
        ),

        // ==================== MAIN APP ROUTES ====================
        GoRoute(
          path: '/city-selection',
          name: 'citySelection',
          pageBuilder: (context, state) => _buildSlidePage(
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
              _buildPage(child: const MainLayoutPage(), state: state),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) =>
              _buildPage(child: const ProfilePage(), state: state),
        ),
        GoRoute(
          path: '/edit-profile',
          name: 'editProfile',
          pageBuilder: (context, state) =>
              _buildPage(child: const _EditProfilePageWrapper(), state: state),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<SettingsCubit>(),
              child: const UserSettingsPage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/privacy-policy',
          name: 'privacyPolicy',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const PrivacyPolicyPage(), state: state),
        ),
        GoRoute(
          path: '/terms-of-service',
          name: 'termsOfService',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const TermsOfServicePage(), state: state),
        ),

        // ==================== FIELDS ROUTES ====================
        GoRoute(
          path: '/fields',
          name: 'fieldsList',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final categoryId = extra?['categoryId'] as String?;

            return _buildSlidePage(
              child: FieldsListPage(categoryId: categoryId),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/fields/:fieldId',
          name: 'fieldDetails',
          pageBuilder: (context, state) {
            final fieldId = state.pathParameters['fieldId']!;
            return _buildSlidePage(
              child: FieldDetailsPage(fieldId: fieldId),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/fields-map',
          name: 'fieldsMap',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<FieldsCubit>()..loadAllFields(),
              child: const FieldsMapPage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const SearchPage(), state: state),
        ),
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const FavoritesPage(), state: state),
        ),

        // ==================== BOOKINGS ROUTES ====================
        GoRoute(
          path: '/create-booking',
          name: 'createBooking',
          pageBuilder: (context, state) {
            final field = state.extra as FieldEntity?;
            if (field == null) {
              return _buildPage(
                child: const _ErrorPage(error: 'Field data is required'),
                state: state,
              );
            }
            return _buildSlidePage(
              child: CreateBookingPage(field: field),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/my-bookings',
          name: 'myBookings',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<BookingCubit>()..loadUserBookings(),
              child: const MyBookingsPage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/bookings/:bookingId',
          name: 'bookingDetails',
          pageBuilder: (context, state) {
            final bookingId = state.pathParameters['bookingId']!;
            return _buildSlidePage(
              child: BlocProvider(
                create: (_) => sl<BookingCubit>()..loadBookingById(bookingId),
                child: BookingDetailsPage(bookingId: bookingId),
              ),
              state: state,
            );
          },
        ),

        // ==================== REVIEWS ROUTES ====================
        GoRoute(
          path: '/create-review',
          name: 'createReview',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null ||
                !extra.containsKey('fieldId') ||
                !extra.containsKey('fieldName')) {
              return _buildPage(
                child: const _ErrorPage(error: 'Field information is required'),
                state: state,
              );
            }
            return _buildSlidePage(
              child: BlocProvider(
                create: (_) => sl<ReviewsCubit>(),
                child: CreateReviewPage(
                  fieldId: extra['fieldId'] as String,
                  fieldName: extra['fieldName'] as String,
                  bookingId: extra['bookingId'] as String?,
                  existingRating: extra['existingRating'] as int?,
                  existingComment: extra['existingComment'] as String?,
                  reviewId: extra['reviewId'] as String?,
                ),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/all-reviews',
          name: 'allReviews',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null ||
                !extra.containsKey('fieldId') ||
                !extra.containsKey('fieldName')) {
              return _buildPage(
                child: const _ErrorPage(error: 'Field information is required'),
                state: state,
              );
            }
            return _buildSlidePage(
              child: AllReviewsPage(
                fieldId: extra['fieldId'] as String,
                fieldName: extra['fieldName'] as String,
                averageRating: extra['averageRating'] as double?,
                totalReviews: extra['totalReviews'] as int?,
              ),
              state: state,
            );
          },
        ),

        // ==================== OWNER ROUTES ====================
        GoRoute(
          path: '/owner/dashboard',
          name: 'ownerDashboard',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<OwnerCubit>(),
              child: const OwnerDashboardPage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/owner/bookings',
          name: 'ownerBookings',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<OwnerCubit>(),
              child: const OwnerBookingsPage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/owner/bookings/manual',
          name: 'ownerCreateManualBooking',
          pageBuilder: (context, state) => _buildSlidePage(
            child: const CreateManualBookingPage(),
            state: state,
          ),
        ),
        GoRoute(
          path: '/owner/fields',
          name: 'ownerFields',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<OwnerCubit>(),
              child: const OwnerFieldsPage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/owner/fields/add',
          name: 'ownerAddField',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<OwnerCubit>(),
              child: const AddEditFieldPage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/owner/fields/edit',
          name: 'ownerEditField',
          pageBuilder: (context, state) {
            final field = state.extra as FieldEntity?;
            if (field == null) {
              return _buildPage(
                child: const _ErrorPage(error: 'Field is required'),
                state: state,
              );
            }
            return _buildSlidePage(
              child: BlocProvider(
                create: (_) => sl<OwnerCubit>(),
                child: AddEditFieldPage(field: field),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/owner/analytics',
          name: 'ownerAnalytics',
          pageBuilder: (context, state) => _buildSlidePage(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<OwnerCubit>()),
                BlocProvider(
                  create: (_) => sl<BookingCubit>()..loadOwnerBookings(),
                ),
                BlocProvider(create: (_) => sl<FieldsCubit>()..loadAllFields()),
              ],
              child: const OwnerAnalyticsPage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/owner/settings',
          name: 'ownerSettings',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const OwnerSettingsPage(), state: state),
        ),
        GoRoute(
          path: '/owner/profile',
          name: 'ownerProfile',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<OwnerCubit>(),
              child: const OwnerProfilePage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/owner/fields/:fieldId/business-hours',
          name: 'manageBusinessHours',
          pageBuilder: (context, state) {
            final fieldId = state.pathParameters['fieldId']!;
            final extra = state.extra as Map<String, dynamic>?;
            final fieldName = extra?['fieldName'] as String?;

            return _buildSlidePage(
              child: BlocProvider(
                create: (_) => sl<BusinessHoursCubit>(),
                child: ManageBusinessHoursPage(
                  fieldId: fieldId,
                  fieldName: fieldName,
                ),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/owner/fields/:fieldId',
          name: 'ownerFieldDetail',
          pageBuilder: (context, state) {
            final field = state.extra as FieldEntity?;
            if (field == null) {
              return _buildPage(
                child: const _ErrorPage(error: 'Field data is required'),
                state: state,
              );
            }
            return _buildSlidePage(
              child: BlocProvider(
                create: (_) => sl<OwnerCubit>(),
                child: OwnerFieldDetailPage(field: field),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/owner/revenue',
          name: 'ownerRevenue',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<OwnerCubit>(),
              child: const OwnerRevenuePage(),
            ),
            state: state,
          ),
        ),

        // ==================== SUPER ADMIN ROUTES ====================
        GoRoute(
          path: '/super-admin/dashboard',
          name: 'superAdminDashboard',
          pageBuilder: (context, state) => _buildSlidePage(
            child: BlocProvider(
              create: (_) => sl<SuperAdminCubit>()..loadPlatformStatistics(),
              child: const SuperAdminDashboardPage(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/super-admin/create-admin',
          name: 'superAdminCreateAdmin',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const CreateAdminPage(), state: state),
        ),
        GoRoute(
          path: '/super-admin/create-field',
          name: 'superAdminCreateField',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const CreateFieldPage(), state: state),
        ),
        GoRoute(
          path: '/super-admin/admins',
          name: 'superAdminAdmins',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const AdminsListPage(), state: state),
        ),
        GoRoute(
          path: '/super-admin/admin-details',
          name: 'superAdminAdminDetails',
          pageBuilder: (context, state) {
            final admin = state.extra as UserEntity?;
            if (admin == null) {
              return _buildPage(
                child: const _ErrorPage(error: 'Admin data is required'),
                state: state,
              );
            }
            return _buildSlidePage(
              child: AdminDetailsPage(admin: admin),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/super-admin/users',
          name: 'superAdminUsers',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const UsersListPage(), state: state),
        ),
        GoRoute(
          path: '/super-admin/user-details',
          name: 'superAdminUserDetails',
          pageBuilder: (context, state) {
            final user = state.extra as UserEntity?;
            if (user == null) {
              return _buildPage(
                child: const _ErrorPage(error: 'User data is required'),
                state: state,
              );
            }
            return _buildSlidePage(
              child: UserDetailsPage(user: user),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/super-admin/cities',
          name: 'superAdminCities',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const CitiesPage(), state: state),
        ),
        GoRoute(
          path: '/super-admin/fields',
          name: 'superAdminFields',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const AllFieldsPage(), state: state),
        ),
        GoRoute(
          path: '/super-admin/bookings',
          name: 'superAdminBookings',
          pageBuilder: (context, state) =>
              _buildSlidePage(child: const AllBookingsPage(), state: state),
        ),
        GoRoute(
          path: '/super-admin/analytics',
          name: 'superAdminAnalytics',
          pageBuilder: (context, state) => _buildSlidePage(
            child: const PlatformAnalyticsPage(),
            state: state,
          ),
        ),
        GoRoute(
          path: '/super-admin/settings',
          name: 'superAdminSettings',
          pageBuilder: (context, state) => _buildSlidePage(
            child: const SuperAdminSettingsPage(),
            state: state,
          ),
        ),
        GoRoute(
          path: '/super-admin/reports',
          name: 'superAdminReports',
          pageBuilder: (context, state) => _buildSlidePage(
            child: const SuperAdminReportsPage(),
            state: state,
          ),
        ),
      ],
    );
  }

  // ==================== PAGE BUILDERS ====================

  /// Build a standard page with no custom transition
  static Page<dynamic> _buildPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage<dynamic>(key: state.pageKey, child: child);
  }

  /// Build a page with slide transition
  static Page<dynamic> _buildSlidePage({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<dynamic>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

/// Error page displayed when navigation fails
class _ErrorPage extends StatelessWidget {
  final String error;

  const _ErrorPage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                error,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wrapper page that shows EditProfileDialog and pops when done.
class _EditProfilePageWrapper extends StatefulWidget {
  const _EditProfilePageWrapper();

  @override
  State<_EditProfilePageWrapper> createState() =>
      _EditProfilePageWrapperState();
}

class _EditProfilePageWrapperState extends State<_EditProfilePageWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showEditDialog();
    });
  }

  Future<void> _showEditDialog() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const EditProfileDialog(),
      ),
    );

    if (mounted && context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
