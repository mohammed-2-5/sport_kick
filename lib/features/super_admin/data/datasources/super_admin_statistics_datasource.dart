import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException;
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/super_admin/data/models/platform_statistics_model.dart';

/// Remote data source for super admin platform statistics operations.
///
/// Handles:
/// - Fetching platform-wide statistics
/// - Revenue analytics
/// - Daily revenue trends
abstract class SuperAdminStatisticsDataSource {
  Future<PlatformStatisticsModel> getPlatformStatistics();
}

/// Implementation of super admin statistics data source.
class SuperAdminStatisticsDataSourceImpl
    implements SuperAdminStatisticsDataSource {
  final SupabaseClient supabaseClient;

  SuperAdminStatisticsDataSourceImpl({required this.supabaseClient});

  @override
  Future<PlatformStatisticsModel> getPlatformStatistics() async {
    try {
      debugPrint('📊 [StatisticsDataSource] Fetching platform statistics...');

      final response = await supabaseClient
          .from('platform_statistics')
          .select()
          .single();

      debugPrint('✅ [StatisticsDataSource] Platform statistics loaded');
      debugPrint('   Total Users: ${response['total_users']}');
      debugPrint('   Total Admins: ${response['total_admins']}');
      debugPrint('   Active Fields: ${response['active_fields']}');
      debugPrint('   Total Bookings: ${response['total_bookings']}');
      debugPrint('   Total Revenue: ${response['total_revenue']}');

      // Fetch daily revenue for the last 7 days
      debugPrint('📊 [StatisticsDataSource] Fetching daily revenue trends...');
      final dailyRevenue = await _getDailyRevenue();
      debugPrint('✅ [StatisticsDataSource] Daily revenue: $dailyRevenue');

      // Merge daily revenue into response
      final Map<String, dynamic> enhancedResponse = Map.from(response);
      enhancedResponse['daily_revenue'] = dailyRevenue;

      return PlatformStatisticsModel.fromJson(enhancedResponse);
    } on PostgrestException catch (e) {
      debugPrint('❌ [StatisticsDataSource] PostgrestException: ${e.message}');
      debugPrint('   Code: ${e.code}');
      debugPrint('   Details: ${e.details}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [StatisticsDataSource] Exception: $e');
      throw ServerException('Failed to load platform statistics: $e');
    }
  }

  /// Get daily revenue for the last 7 days from bookings table.
  ///
  /// Returns a list of 7 revenue values (in thousands) for the past 7 days,
  /// ordered from oldest to newest.
  Future<List<double>> _getDailyRevenue() async {
    try {
      // Calculate date 7 days ago
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final sevenDaysAgoStr = sevenDaysAgo.toIso8601String().split('T')[0];

      debugPrint(
        '📊 [StatisticsDataSource] Querying bookings since: $sevenDaysAgoStr',
      );

      // Query bookings grouped by date
      final response = await supabaseClient.rpc(
        'get_daily_revenue',
        params: {'days_back': 7},
      );

      if (response == null || response is! List || response.isEmpty) {
        debugPrint(
          '⚠️ [StatisticsDataSource] No daily revenue data found, using zeros',
        );
        return List.filled(7, 0.0);
      }

      // Parse response into map of date -> revenue
      final Map<String, double> revenueByDate = {};
      for (final row in response) {
        if (row is Map<String, dynamic>) {
          final date = row['booking_date'] as String?;
          final revenue = (row['daily_revenue'] as num?)?.toDouble() ?? 0.0;
          if (date != null) {
            revenueByDate[date] = revenue / 1000.0; // Convert to thousands
          }
        }
      }

      // Build list for last 7 days (oldest to newest)
      final List<double> dailyRevenue = [];
      for (int i = 6; i >= 0; i--) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dateStr = date.toIso8601String().split('T')[0];
        dailyRevenue.add(revenueByDate[dateStr] ?? 0.0);
      }

      return dailyRevenue;
    } catch (e) {
      debugPrint('⚠️ [StatisticsDataSource] Error fetching daily revenue: $e');
      // Return zeros if query fails (chart will still work)
      return List.filled(7, 0.0);
    }
  }
}
