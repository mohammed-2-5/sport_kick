import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/business_hours/data/datasources/business_hours_remote_datasource.dart';
import 'package:spo_kick/features/business_hours/data/models/business_hours_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of [BusinessHoursRemoteDataSource] using Supabase.
///
/// Handles all remote data operations for business hours feature.
class BusinessHoursRemoteDataSourceImpl
    implements BusinessHoursRemoteDataSource {
  final SupabaseClient supabaseClient;

  const BusinessHoursRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<BusinessHoursModel>> getFieldBusinessHours(String fieldId) async {
    try {
      final response = await supabaseClient
          .from('business_hours')
          .select()
          .eq('field_id', fieldId)
          .order('day_of_week', ascending: true);

      return (response as List)
          .map((json) => BusinessHoursModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BusinessHoursModel> updateBusinessHours({
    required String fieldId,
    required int dayOfWeek,
    required bool isOpen,
    String? openingTime,
    String? closingTime,
  }) async {
    try {
      final data = {
        'field_id': fieldId,
        'day_of_week': dayOfWeek,
        'is_open': isOpen,
        'opening_time': openingTime,
        'closing_time': closingTime,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await supabaseClient
          .from('business_hours')
          .upsert(data)
          .eq('field_id', fieldId)
          .eq('day_of_week', dayOfWeek)
          .select()
          .single();

      return BusinessHoursModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BusinessHoursModel>> updateMultipleBusinessHours({
    required String fieldId,
    required Map<int, BusinessHoursModel> updates,
  }) async {
    try {
      final dataList = updates.entries.map((entry) {
        final model = entry.value;
        return {
          'field_id': fieldId,
          'day_of_week': entry.key,
          'is_open': model.isOpen,
          'opening_time': model.openingTime,
          'closing_time': model.closingTime,
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      final response = await supabaseClient
          .from('business_hours')
          .upsert(dataList)
          .select();

      return (response as List)
          .map((json) => BusinessHoursModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> initializeDefaultBusinessHours(String fieldId) async {
    try {
      // Use upsert to set default hours for all 7 days (0=Sunday, 6=Saturday)
      // Default: Open 09:00 - 22:00 for all days
      // This will either insert new rows or update existing ones
      final now = DateTime.now().toIso8601String();
      final defaultHours = List.generate(
        7,
        (dayOfWeek) => {
          'field_id': fieldId,
          'day_of_week': dayOfWeek,
          'is_open': true,
          'opening_time': '09:00:00',
          'closing_time': '22:00:00',
          'closes_next_day': false,
          'updated_at': now,
        },
      );

      // Use upsert instead of insert to avoid duplicate key errors
      // The unique constraint on (field_id, day_of_week) ensures proper upsert behavior
      await supabaseClient
          .from('business_hours')
          .upsert(defaultHours, onConflict: 'field_id,day_of_week');
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> validateBookingTime({
    required String fieldId,
    required DateTime bookingTime,
  }) async {
    try {
      final response = await supabaseClient.rpc(
        'validate_booking_time',
        params: {
          'p_field_id': fieldId,
          'p_booking_time': bookingTime.toIso8601String(),
        },
      );

      return response as bool;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isFieldCurrentlyOpen(String fieldId) async {
    try {
      final now = DateTime.now();
      final dayOfWeek = now.weekday % 7; // Convert to 0-6 format
      final timeString =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      final response = await supabaseClient.rpc(
        'is_field_open_at',
        params: {
          'p_field_id': fieldId,
          'p_day_of_week': dayOfWeek,
          'p_time': timeString,
        },
      );

      return response as bool;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DateTime?> getNextOpeningTime({
    required String fieldId,
    DateTime? fromTime,
  }) async {
    try {
      final startTime = fromTime ?? DateTime.now();

      final response = await supabaseClient.rpc(
        'get_next_opening_time',
        params: {
          'p_field_id': fieldId,
          'p_from_timestamp': startTime.toIso8601String(),
        },
      );

      if (response == null) return null;

      return DateTime.parse(response as String);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
