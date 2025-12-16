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
/// - Creating new cities
/// - Updating existing cities
/// - Deleting cities (soft/hard delete)
abstract class SuperAdminCityManagementDataSource {
  Future<List<CityModel>> getAllCities();
  Future<List<CityModel>> getActiveCities();
  Future<CityModel> createCity({required String name, bool isActive = true});
  Future<CityModel> updateCity({
    required String cityId,
    String? name,
    bool? isActive,
  });
  Future<void> deleteCity({required String cityId, required bool hardDelete});
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

  @override
  Future<CityModel> createCity({
    required String name,
    bool isActive = true,
  }) async {
    try {
      debugPrint('🏙️ [CityMgmtDataSource] Creating city: $name');

      final response = await supabaseClient
          .from('cities')
          .insert({'name': name, 'is_active': isActive})
          .select()
          .single();

      final city = CityModel.fromJson(response);
      debugPrint('✅ [CityMgmtDataSource] City created: ${city.id}');
      return city;
    } on PostgrestException catch (e) {
      debugPrint('❌ [CityMgmtDataSource] PostgrestException: ${e.message}');
      if (e.code == '23505') {
        throw ValidationException('City "$name" already exists');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [CityMgmtDataSource] Exception: $e');
      throw ServerException('Failed to create city: $e');
    }
  }

  @override
  Future<CityModel> updateCity({
    required String cityId,
    String? name,
    bool? isActive,
  }) async {
    try {
      debugPrint('🏙️ [CityMgmtDataSource] Updating city: $cityId');

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updates['name'] = name;
      if (isActive != null) updates['is_active'] = isActive;

      final response = await supabaseClient
          .from('cities')
          .update(updates)
          .eq('id', cityId)
          .select()
          .single();

      final city = CityModel.fromJson(response);
      debugPrint('✅ [CityMgmtDataSource] City updated: ${city.id}');
      return city;
    } on PostgrestException catch (e) {
      debugPrint('❌ [CityMgmtDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [CityMgmtDataSource] Exception: $e');
      throw ServerException('Failed to update city: $e');
    }
  }

  @override
  Future<void> deleteCity({
    required String cityId,
    required bool hardDelete,
  }) async {
    try {
      debugPrint(
        '🏙️ [CityMgmtDataSource] ${hardDelete ? "Hard" : "Soft"} deleting city: $cityId',
      );

      if (hardDelete) {
        await supabaseClient.from('cities').delete().eq('id', cityId);
        debugPrint('✅ [CityMgmtDataSource] City permanently deleted');
      } else {
        await supabaseClient
            .from('cities')
            .update({'is_active': false})
            .eq('id', cityId);
        debugPrint('✅ [CityMgmtDataSource] City deactivated');
      }
    } on PostgrestException catch (e) {
      debugPrint('❌ [CityMgmtDataSource] PostgrestException: ${e.message}');
      if (e.code == '23503') {
        throw const ValidationException(
          'Cannot delete city with existing fields. Deactivate instead.',
        );
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [CityMgmtDataSource] Exception: $e');
      throw ServerException('Failed to delete city: $e');
    }
  }
}
