import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/route_builders.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/pages/booking_details_page.dart';
import 'package:spo_kick/features/bookings/presentation/pages/booking_invoice_page.dart';
import 'package:spo_kick/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:spo_kick/features/bookings/presentation/pages/my_bookings_page.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/pages/favorites_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/field_details_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/fields_list_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/fields_map_page.dart';
import 'package:spo_kick/features/fields/presentation/pages/search_page.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/pages/create_recurring_page.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/pages/my_recurring_bookings_page.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/pages/recurring_booking_detail_page.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/pages/all_reviews_page.dart';
import 'package:spo_kick/features/reviews/presentation/pages/create_review_page.dart';

/// User/Customer routes (fields browsing, bookings, reviews, etc.)
final List<GoRoute> userRoutes = [
  // ==================== FIELDS ROUTES ====================
  GoRoute(
    path: '/fields',
    name: 'fieldsList',
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final categoryId = extra?['categoryId'] as String?;

      return buildSlidePage(
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
      return buildSlidePage(
        child: FieldDetailsPage(fieldId: fieldId),
        state: state,
      );
    },
  ),
  GoRoute(
    path: '/fields-map',
    name: 'fieldsMap',
    pageBuilder: (context, state) => buildSlidePage(
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
        buildSlidePage(child: const SearchPage(), state: state),
  ),
  GoRoute(
    path: '/favorites',
    name: 'favorites',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const FavoritesPage(), state: state),
  ),

  // ==================== BOOKINGS ROUTES ====================
  GoRoute(
    path: '/create-booking',
    name: 'createBooking',
    pageBuilder: (context, state) {
      // Handle both FieldEntity directly and Map with 'field' key
      FieldEntity? field;
      if (state.extra is FieldEntity) {
        field = state.extra as FieldEntity;
      } else if (state.extra is Map<String, dynamic>) {
        final extra = state.extra as Map<String, dynamic>;
        field = extra['field'] as FieldEntity?;
      }

      if (field == null) {
        return buildPage(
          child: const ErrorPage(error: 'Field data is required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: CreateBookingPage(field: field),
        state: state,
      );
    },
  ),
  GoRoute(
    path: '/my-bookings',
    name: 'myBookings',
    pageBuilder: (context, state) => buildSlidePage(
      child: MultiBlocProvider(
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
      state: state,
    ),
  ),
  GoRoute(
    path: '/bookings/:bookingId',
    name: 'bookingDetails',
    pageBuilder: (context, state) {
      final bookingId = state.pathParameters['bookingId']!;
      return buildSlidePage(
        child: BlocProvider(
          create: (_) => sl<BookingCubit>()
            ..loadBookingById(
              bookingId,
              loadingMessage: 'Loading booking details...',
            ),
          child: BookingDetailsPage(bookingId: bookingId),
        ),
        state: state,
      );
    },
  ),
  GoRoute(
    path: '/booking-invoice',
    name: 'bookingInvoice',
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      if (extra == null ||
          !extra.containsKey('booking') ||
          !extra.containsKey('field')) {
        return buildPage(
          child: const ErrorPage(error: 'Booking and field data are required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: BookingInvoicePage(
          booking: extra['booking'] as BookingEntity,
          field: extra['field'] as FieldEntity,
        ),
        state: state,
      );
    },
  ),

  // ==================== RECURRING BOOKINGS ROUTES ====================
  GoRoute(
    path: '/myRecurringBookings',
    name: 'myRecurringBookings',
    pageBuilder: (context, state) => buildSlidePage(
      child: BlocProvider(
        create: (_) => sl<MyRecurringBookingsCubit>()..loadRecurringBookings(),
        child: const MyRecurringBookingsPage(),
      ),
      state: state,
    ),
  ),
  GoRoute(
    path: '/createRecurring',
    name: 'createRecurring',
    pageBuilder: (context, state) {
      // Handle both FieldEntity directly and Map with 'field' key
      FieldEntity? field;
      if (state.extra is FieldEntity) {
        field = state.extra as FieldEntity;
      } else if (state.extra is Map<String, dynamic>) {
        final extra = state.extra as Map<String, dynamic>;
        field = extra['field'] as FieldEntity?;
      }

      if (field == null) {
        return buildPage(
          child: const ErrorPage(error: 'Field data is required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: CreateRecurringPage(field: field),
        state: state,
      );
    },
  ),
  GoRoute(
    path: '/recurringBooking/:id',
    name: 'recurringBookingDetail',
    pageBuilder: (context, state) {
      final booking = state.extra as RecurringBookingEntity?;
      if (booking == null) {
        return buildPage(
          child: const ErrorPage(error: 'Recurring booking data is required'),
          state: state,
        );
      }
      return buildSlidePage(
        child: RecurringBookingDetailPage(booking: booking),
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
        return buildPage(
          child: const ErrorPage(error: 'Field information is required'),
          state: state,
        );
      }
      return buildSlidePage(
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
        return buildPage(
          child: const ErrorPage(error: 'Field information is required'),
          state: state,
        );
      }
      return buildSlidePage(
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
];
