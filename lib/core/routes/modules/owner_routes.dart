import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/route_builders.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_cubit.dart';
import 'package:spo_kick/features/business_hours/presentation/pages/manage_business_hours_page.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_crud_cubit.dart';
import 'package:spo_kick/features/owner/presentation/pages/add_edit_field_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/booking_table_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/create_manual_booking_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_analytics_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_booking_detail_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_bookings_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_dashboard_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_field_detail_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_fields_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_profile_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_revenue_page.dart';
import 'package:spo_kick/features/owner/presentation/pages/owner_settings_page.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/recurring_requests_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/pages/recurring_requests_page.dart';

/// Field Owner/Admin routes (dashboard, bookings management, etc.)
final List<GoRoute> ownerRoutes = [
  // ==================== OWNER DASHBOARD ====================
  GoRoute(
    path: '/owner/dashboard',
    name: 'ownerDashboard',
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<OwnerCubit>(),
        child: const OwnerDashboardPage(),
      ),
      state: state,
    ),
  ),

  // ==================== OWNER BOOKINGS ====================
  GoRoute(
    path: '/owner/bookings',
    name: 'ownerBookings',
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<OwnerCubit>(),
        child: const OwnerBookingsPage(),
      ),
      state: state,
    ),
  ),
  GoRoute(
    path: '/owner/booking-table',
    name: 'ownerBookingTable',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const BookingTablePage(), state: state),
  ),
  GoRoute(
    path: '/owner/bookings/manual',
    name: 'ownerCreateManualBooking',
    pageBuilder: (context, state) {
      // Get optional initial data from booking table
      final initialData = state.extra as Map<String, dynamic>?;
      return buildSlidePage(
        child: CreateManualBookingPage(initialData: initialData),
        state: state,
      );
    },
  ),
  GoRoute(
    path: '/owner/bookings/detail',
    name: 'ownerBookingDetail',
    pageBuilder: (context, state) {
      final booking = state.extra as BookingEntity?;
      if (booking == null) {
        return buildPage(
          child: const ErrorPage(error: 'Booking is required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: OwnerBookingDetailPage(booking: booking),
        state: state,
      );
    },
  ),

  // ==================== OWNER FIELDS ====================
  GoRoute(
    path: '/owner/fields',
    name: 'ownerFields',
    pageBuilder: (context, state) => buildSlidePage(
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
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<OwnerFieldsCrudCubit>(),
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
        return buildPage(
          child: const ErrorPage(error: 'Field is required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: BlocProvider(
          create: (_) => sl<OwnerFieldsCrudCubit>(),
          child: AddEditFieldPage(field: field),
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
        return buildPage(
          child: const ErrorPage(error: 'Field data is required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: BlocProvider(
          create: (_) => sl<OwnerCubit>(),
          child: OwnerFieldDetailPage(field: field),
        ),
        state: state,
      );
    },
  ),
  GoRoute(
    path: '/owner/fields/:fieldId/business-hours',
    name: 'manageBusinessHours',
    pageBuilder: (context, state) {
      final fieldId = state.pathParameters['fieldId']!;
      final extra = state.extra as Map<String, dynamic>?;
      final fieldName = extra?['fieldName'] as String?;

      return buildSlidePage(
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

  // ==================== OWNER ANALYTICS & REVENUE ====================
  GoRoute(
    path: '/owner/analytics',
    name: 'ownerAnalytics',
    pageBuilder: (context, state) => buildSlidePage(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<OwnerCubit>()),
          BlocProvider(
            create: (_) => sl<BookingCubit>()
              ..loadOwnerBookings(loadingMessage: 'Loading owner bookings...'),
          ),
          BlocProvider(create: (_) => sl<FieldsCubit>()..loadAllFields()),
        ],
        child: const OwnerAnalyticsPage(),
      ),
      state: state,
    ),
  ),
  GoRoute(
    path: '/owner/revenue',
    name: 'ownerRevenue',
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<OwnerCubit>(),
        child: const OwnerRevenuePage(),
      ),
      state: state,
    ),
  ),

  // ==================== OWNER RECURRING BOOKINGS ====================
  GoRoute(
    path: '/owner/recurring-requests',
    name: 'ownerRecurringRequests',
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<RecurringRequestsCubit>()..loadData(),
        child: const RecurringRequestsPage(),
      ),
      state: state,
    ),
  ),

  // ==================== OWNER SETTINGS & PROFILE ====================
  GoRoute(
    path: '/owner/settings',
    name: 'ownerSettings',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const OwnerSettingsPage(), state: state),
  ),
  GoRoute(
    path: '/owner/profile',
    name: 'ownerProfile',
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<OwnerCubit>(),
        child: const OwnerProfilePage(),
      ),
      state: state,
    ),
  ),
];
