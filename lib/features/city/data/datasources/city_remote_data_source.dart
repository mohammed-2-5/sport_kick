import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/city/data/models/city_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// City Remote Data Source Interface
abstract class CityRemoteDataSource {
  /// Get all active cities from Supabase
  Future<List<CityModel>> getCities();

  /// Get city by ID from Supabase
  Future<CityModel> getCityById(String cityId);
}

/// City Remote Data Source Implementation
///
/// Handles fetching city data from Supabase.
class CityRemoteDataSourceImpl implements CityRemoteDataSource {
  final SupabaseClient supabaseClient;

  const CityRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<CityModel>> getCities() async {
    try {
      final response = await supabaseClient
          .from('cities')
          .select('id, name, name_ar, is_active, created_at')
          .eq('is_active', true)
          .order('name', ascending: true);

      return (response as List)
          .map((json) => CityModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch cities: ${e.toString()}');
    }
  }

  @override
  Future<CityModel> getCityById(String cityId) async {
    try {
      final response = await supabaseClient
          .from('cities')
          .select('id, name, name_ar, is_active, created_at')
          .eq('id', cityId)
          .single();

      return CityModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch city: ${e.toString()}');
    }
  }
}
