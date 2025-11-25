import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';
import 'package:spo_kick/features/fields/data/models/sport_category_model.dart';

/// Remote data source for field-related API operations.
///
/// Handles all Supabase queries for fields and sport categories.
/// Throws [ServerException] on any API errors.
abstract class FieldRemoteDataSource {
  /// Get all active fields
  Future<List<FieldModel>> getAllFields();

  /// Get field by ID
  Future<FieldModel> getFieldById(String fieldId);

  /// Search fields by query
  Future<List<FieldModel>> searchFields(String query);

  /// Get fields by sport category
  Future<List<FieldModel>> getFieldsByCategory(String categoryId);

  /// Get fields by city
  Future<List<FieldModel>> getFieldsByCity(String city);

  /// Get featured fields
  Future<List<FieldModel>> getFeaturedFields();

  /// Get popular fields
  Future<List<FieldModel>> getPopularFields({int limit = 10});

  /// Get fields by owner
  Future<List<FieldModel>> getFieldsByOwner(String ownerId);

  /// Get all sport categories
  Future<List<SportCategoryModel>> getSportCategories();

  /// Get sport category by ID
  Future<SportCategoryModel> getSportCategoryById(String categoryId);

  /// Filter fields by criteria
  Future<List<FieldModel>> filterFields({
    String? categoryId,
    String? city,
    double? minPrice,
    double? maxPrice,
    List<String>? amenities,
  });
}

/// Implementation of [FieldRemoteDataSource] using Supabase.
class FieldRemoteDataSourceImpl implements FieldRemoteDataSource {
  final SupabaseClient supabaseClient;

  const FieldRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<FieldModel>> getAllFields() async {
    try {
      final response = await supabaseClient
          .from('fields')
          .select('*, cities(name)')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => FieldModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch fields: $e');
    }
  }

  @override
  Future<FieldModel> getFieldById(String fieldId) async {
    try {
      final response = await supabaseClient
          .from('fields')
          .select('*, cities(name)')
          .eq('id', fieldId)
          .single();

      return FieldModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw NotFoundException('Field not found');
      }
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch field: $e');
    }
  }

  @override
  Future<List<FieldModel>> searchFields(String query) async {
    try {
      // Search in name, city, and address
      final response = await supabaseClient
          .from('fields')
          .select()
          .eq('is_active', true)
          .or('name.ilike.%$query%,city.ilike.%$query%,address.ilike.%$query%')
          .order('name', ascending: true);

      return (response as List)
          .map((json) => FieldModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to search fields: $e');
    }
  }

  @override
  Future<List<FieldModel>> getFieldsByCategory(String categoryId) async {
    try {
      final response = await supabaseClient
          .from('fields')
          .select()
          .eq('sport_category_id', categoryId)
          .eq('is_active', true)
          .order('name', ascending: true);

      return (response as List)
          .map((json) => FieldModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch fields by category: $e');
    }
  }

  @override
  Future<List<FieldModel>> getFieldsByCity(String city) async {
    try {
      final response = await supabaseClient
          .from('fields')
          .select()
          .eq('city', city)
          .eq('is_active', true)
          .order('name', ascending: true);

      return (response as List)
          .map((json) => FieldModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch fields by city: $e');
    }
  }

  @override
  Future<List<FieldModel>> getFeaturedFields() async {
    try {
      final response = await supabaseClient
          .from('fields')
          .select()
          .eq('is_featured', true)
          .eq('is_active', true)
          .order('booking_count', ascending: false)
          .limit(10);

      return (response as List)
          .map((json) => FieldModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch featured fields: $e');
    }
  }

  @override
  Future<List<FieldModel>> getPopularFields({int limit = 10}) async {
    try {
      final response = await supabaseClient
          .from('fields')
          .select()
          .eq('is_active', true)
          .order('booking_count', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => FieldModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch popular fields: $e');
    }
  }

  @override
  Future<List<FieldModel>> getFieldsByOwner(String ownerId) async {
    try {
      final response = await supabaseClient
          .from('fields')
          .select()
          .eq('owner_id', ownerId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => FieldModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch fields by owner: $e');
    }
  }

  @override
  Future<List<SportCategoryModel>> getSportCategories() async {
    try {
      final response = await supabaseClient
          .from('sport_categories')
          .select()
          .eq('is_active', true)
          .order('display_order', ascending: true);

      return (response as List)
          .map(
            (json) => SportCategoryModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch sport categories: $e');
    }
  }

  @override
  Future<SportCategoryModel> getSportCategoryById(String categoryId) async {
    try {
      final response = await supabaseClient
          .from('sport_categories')
          .select()
          .eq('id', categoryId)
          .single();

      return SportCategoryModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw NotFoundException('Sport category not found');
      }
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch sport category: $e');
    }
  }

  @override
  Future<List<FieldModel>> filterFields({
    String? categoryId,
    String? city,
    double? minPrice,
    double? maxPrice,
    List<String>? amenities,
  }) async {
    try {
      var query = supabaseClient.from('fields').select().eq('is_active', true);

      // Apply filters
      if (categoryId != null) {
        query = query.eq('sport_category_id', categoryId);
      }

      if (city != null) {
        query = query.eq('city', city);
      }

      if (minPrice != null) {
        query = query.gte('price_per_hour', minPrice);
      }

      if (maxPrice != null) {
        query = query.lte('price_per_hour', maxPrice);
      }

      if (amenities != null && amenities.isNotEmpty) {
        // Check if amenities array contains all specified amenities
        query = query.contains('amenities', amenities);
      }

      final response = await query.order('name', ascending: true);

      return (response as List)
          .map((json) => FieldModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to filter fields: $e');
    }
  }
}
