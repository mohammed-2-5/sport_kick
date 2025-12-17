import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/features/fields/data/models/sport_category_model.dart';

/// Datasource for sport category operations.
///
/// Handles all database operations related to sport categories.
class SuperAdminSportCategoryDatasource {
  final SupabaseClient supabaseClient;

  SuperAdminSportCategoryDatasource({required this.supabaseClient});

  /// Get all sport categories.
  Future<List<SportCategoryModel>> getAllSportCategories() async {
    final response = await supabaseClient
        .from('sport_categories')
        .select()
        .order('name', ascending: true);

    return (response as List)
        .map((json) => SportCategoryModel.fromJson(json))
        .toList();
  }

  /// Create a new sport category.
  Future<SportCategoryModel> createSportCategory({
    required String name,
    String? icon,
    String? description,
  }) async {
    final data = {
      'name': name,
      if (icon != null) 'icon': icon,
      if (description != null) 'description': description,
    };

    final response = await supabaseClient
        .from('sport_categories')
        .insert(data)
        .select()
        .single();

    return SportCategoryModel.fromJson(response);
  }

  /// Update an existing sport category.
  Future<SportCategoryModel> updateSportCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? description,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (icon != null) data['icon'] = icon;
    if (description != null) data['description'] = description;

    if (data.isEmpty) {
      throw Exception('No fields to update');
    }

    final response = await supabaseClient
        .from('sport_categories')
        .update(data)
        .eq('id', categoryId)
        .select()
        .single();

    return SportCategoryModel.fromJson(response);
  }

  /// Delete a sport category.
  Future<void> deleteSportCategory({required String categoryId}) async {
    await supabaseClient.from('sport_categories').delete().eq('id', categoryId);
  }
}
