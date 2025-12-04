import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException;
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/super_admin/data/models/city_model.dart';

/// Remote data source for super admin city management operations.
///
/// Handles:
/// - Fetching all cities
/// - Fetching active cities only
abstract class SuperAdminCityManagementDataSource {
  Future<List<CityModel>> getAllCities();
  Future<List<CityModel>> getActiveCities();
}

/// Implementation of super admin city management data source.
class SuperAdminCityManagementDataSourceImpl
    implements SuperAdminCityManagementDataSource {
  final SupabaseClient supabaseClient;

  SuperAdminCityManagementDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<CityModel>> getAllCities() async {
    try {
      debugPrint('🏙️ [CityMgmtDataSource] Fetching all cities...');

      final response = await supabaseClient
          .from('cities')
          .select('*, fields(count)')
          .order('name', ascending: true);

      final cities = (response as List).map((json) {
        final data = Map<String, dynamic>.from(json as Map);
        // Extract count from fields relation
        if (data['fields'] != null && (data['fields'] as List).isNotEmpty) {
          data['fields_count'] = (data['fields'] as List).first['count'];
        } else {
          data['fields_count'] = 0;
        }
        return CityModel.fromJson(data);
      }).toList();

      debugPrint('✅ [CityMgmtDataSource] Loaded ${cities.length} cities');
      return cities;
    } on PostgrestException catch (e) {
      debugPrint('❌ [CityMgmtDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [CityMgmtDataSource] Exception: $e');
      throw ServerException('Failed to load cities: $e');
    }
  }

  @override
  Future<List<CityModel>> getActiveCities() async {
    try {
      debugPrint('🏙️ [CityMgmtDataSource] Fetching active cities...');

      final response = await supabaseClient
          .from('cities')
          .select('*, fields(count)')
          .eq('is_active', true)
          .order('name', ascending: true);

      final cities = (response as List).map((json) {
        final data = Map<String, dynamic>.from(json as Map);
        // Extract count from fields relation
        if (data['fields'] != null && (data['fields'] as List).isNotEmpty) {
          data['fields_count'] = (data['fields'] as List).first['count'];
        } else {
          data['fields_count'] = 0;
        }
        return CityModel.fromJson(data);
      }).toList();

      debugPrint(
        '✅ [CityMgmtDataSource] Loaded ${cities.length} active cities',
      );
      return cities;
    } on PostgrestException catch (e) {
      debugPrint('❌ [CityMgmtDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [CityMgmtDataSource] Exception: $e');
      throw ServerException('Failed to load active cities: $e');
    }
  }
}
