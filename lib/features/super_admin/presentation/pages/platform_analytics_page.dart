import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/booking_status_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/city_performance_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/monthly_bookings_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/revenue_trends_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/top_fields_list.dart';

/// Platform Analytics Page
///
/// Comprehensive analytics dashboard for super admin showing:
/// - Revenue trends over time
/// - Booking status distribution
/// - City performance comparison
/// - Top performing fields
/// - Monthly booking trends
class PlatformAnalyticsPage extends StatelessWidget {
  const PlatformAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()
        ..loadAllBookings()
        ..loadAllFields()
        ..loadPlatformStatistics(),
      child: const _PlatformAnalyticsView(),
    );
  }
}

class _PlatformAnalyticsView extends StatelessWidget {
  const _PlatformAnalyticsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Analytics'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SuperAdminCubit>()
                ..loadAllBookings()
                ..loadAllFields()
                ..loadPlatformStatistics();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<SuperAdminCubit, SuperAdminState>(
        builder: (context, state) {
          if (state is SuperAdminLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (state is SuperAdminError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading analytics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SuperAdminCubit>()
                        ..loadAllBookings()
                        ..loadAllFields()
                        ..loadPlatformStatistics();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AllBookingsLoaded || state is AllFieldsLoaded) {
            return _AnalyticsContent();
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuperAdminCubit, SuperAdminState>(
      builder: (context, state) {
        List<BookingEntity> bookings = [];
        List<FieldEntity> fields = [];

        if (state is AllBookingsLoaded) {
          bookings = state.bookings.cast<BookingEntity>();
        } else if (state is AllFieldsLoaded) {
          fields = state.fields.cast<FieldEntity>();
        }

        if (bookings.isEmpty && fields.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<SuperAdminCubit>()
              ..loadAllBookings()
              ..loadAllFields();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Platform Performance',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Comprehensive overview of your platform metrics',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 24),

                // Charts
                if (bookings.isNotEmpty) ...[
                  RevenueTrendsChart(bookings: bookings),
                  const SizedBox(height: 32),
                  BookingStatusChart(bookings: bookings),
                  const SizedBox(height: 32),
                  MonthlyBookingsChart(bookings: bookings),
                  const SizedBox(height: 32),
                  CityPerformanceChart(bookings: bookings),
                  const SizedBox(height: 32),
                ],

                if (fields.isNotEmpty) ...[
                  TopFieldsList(fields: fields),
                  const SizedBox(height: 32),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
