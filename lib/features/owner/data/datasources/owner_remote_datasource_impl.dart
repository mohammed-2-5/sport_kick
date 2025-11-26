import 'package:flutter/foundation.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/bookings/data/models/booking_model.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';
import 'package:spo_kick/features/owner/data/datasources/owner_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of [OwnerRemoteDataSource] using Supabase
class OwnerRemoteDataSourceImpl implements OwnerRemoteDataSource {
  final SupabaseClient client;

  OwnerRemoteDataSourceImpl(this.client);

  @override
  Future<List<FieldModel>> getOwnerFields(String ownerId) async {
    try {
      debugPrint('🔄 [OwnerDataSource] Fetching fields for owner: $ownerId');

      final response = await client
          .from('fields')
          .select('*, cities(*), sport_categories(*)')
          .eq('owner_id', ownerId)
          .order('created_at', ascending: false);

      debugPrint('✅ [OwnerDataSource] Fetched ${response.length} fields');

      return (response as List)
          .map((json) => FieldModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('❌ [OwnerDataSource] Error fetching fields: $e');
      throw ServerException('Failed to fetch owner fields: $e');
    }
  }

  @override
  Future<FieldModel> updateField(
    String fieldId,
    Map<String, dynamic> updates,
  ) async {
    try {
      debugPrint('🔄 [OwnerDataSource] Updating field: $fieldId');

      final response = await client
          .from('fields')
          .update(updates)
          .eq('id', fieldId)
          .select('*, cities(*), sport_categories(*)')
          .single();

      debugPrint('✅ [OwnerDataSource] Field updated successfully');

      return FieldModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ [OwnerDataSource] Error updating field: $e');
      throw ServerException('Failed to update field: $e');
    }
  }

  @override
  Future<List<BookingModel>> getOwnerBookings({
    required String ownerId,
    String? status,
  }) async {
    try {
      debugPrint('🔄 [OwnerDataSource] Fetching bookings for owner: $ownerId');

      // First, get all field IDs owned by this owner
      final fieldsResponse = await client
          .from('fields')
          .select('id')
          .eq('owner_id', ownerId);

      final fieldIds = (fieldsResponse as List)
          .map((f) => f['id'] as String)
          .toList();

      if (fieldIds.isEmpty) {
        debugPrint('⚠️ [OwnerDataSource] No fields found for owner');
        return [];
      }

      // Then get bookings for those fields
      var query = client
          .from('bookings')
          .select('*, users(*), fields(*, cities(*), sport_categories(*))')
          .filter('field_id', 'in', fieldIds);

      // Apply status filter if provided
      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }

      final response = await query.order('created_at', ascending: false);

      debugPrint('✅ [OwnerDataSource] Fetched ${response.length} bookings');

      return (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('❌ [OwnerDataSource] Error fetching bookings: $e');
      throw ServerException('Failed to fetch owner bookings: $e');
    }
  }

  @override
  Future<void> approveBooking(String bookingId) async {
    try {
      debugPrint('🔄 [OwnerDataSource] Approving booking: $bookingId');

      await client
          .from('bookings')
          .update({'status': 'confirmed'})
          .eq('id', bookingId);

      debugPrint('✅ [OwnerDataSource] Booking approved');
    } catch (e) {
      debugPrint('❌ [OwnerDataSource] Error approving booking: $e');
      throw ServerException('Failed to approve booking: $e');
    }
  }

  @override
  Future<void> rejectBooking(String bookingId, String reason) async {
    try {
      debugPrint('🔄 [OwnerDataSource] Rejecting booking: $bookingId');

      await client
          .from('bookings')
          .update({'status': 'canceled', 'cancellation_reason': reason})
          .eq('id', bookingId);

      debugPrint('✅ [OwnerDataSource] Booking rejected');
    } catch (e) {
      debugPrint('❌ [OwnerDataSource] Error rejecting booking: $e');
      throw ServerException('Failed to reject booking: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getOwnerRevenue(String ownerId) async {
    try {
      debugPrint(
        '🔄 [OwnerDataSource] Calculating revenue for owner: $ownerId',
      );

      // Get all field IDs
      final fieldsResponse = await client
          .from('fields')
          .select('id')
          .eq('owner_id', ownerId);

      final fieldIds = (fieldsResponse as List)
          .map((f) => f['id'] as String)
          .toList();

      if (fieldIds.isEmpty) {
        return {
          'total_revenue': 0.0,
          'monthly_revenue': 0.0,
          'total_bookings': 0,
          'monthly_bookings': 0,
          'pending_bookings': 0,
          'revenue_by_field': <String, double>{},
        };
      }

      // Get all revenue-generating bookings (confirmed + completed)
      final bookings = await client
          .from('bookings')
          .select('*')
          .filter('field_id', 'in', fieldIds)
          .filter('status', 'in', ['confirmed', 'completed']);

      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);

      double totalRevenue = 0;
      double monthlyRevenue = 0;
      int totalBookings = bookings.length;
      int monthlyBookings = 0;
      final revenueByField = <String, double>{};

      for (final booking in bookings) {
        final price = (booking['total_price'] as num?)?.toDouble() ?? 0;
        final fieldId = booking['field_id'] as String;
        final createdAt = DateTime.parse(booking['created_at'] as String);

        totalRevenue += price;
        revenueByField[fieldId] = (revenueByField[fieldId] ?? 0) + price;

        if (createdAt.isAfter(monthStart)) {
          monthlyRevenue += price;
          monthlyBookings++;
        }
      }

      // Get pending bookings count
      final pendingResponse = await client
          .from('bookings')
          .select('id')
          .filter('field_id', 'in', fieldIds)
          .eq('status', 'pending');

      debugPrint('✅ [OwnerDataSource] Revenue calculated successfully');

      return {
        'total_revenue': totalRevenue,
        'monthly_revenue': monthlyRevenue,
        'total_bookings': totalBookings,
        'monthly_bookings': monthlyBookings,
        'pending_bookings': pendingResponse.length,
        'revenue_by_field': revenueByField,
      };
    } catch (e) {
      debugPrint('❌ [OwnerDataSource] Error calculating revenue: $e');
      throw ServerException('Failed to calculate revenue: $e');
    }
  }

  @override
  Future<void> updateOwnerProfile({
    required String ownerId,
    String? fullName,
    String? phone,
  }) async {
    try {
      debugPrint('🔄 [OwnerDataSource] Updating profile for owner: $ownerId');

      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;

      if (updates.isEmpty) {
        debugPrint('⚠️ [OwnerDataSource] No updates provided');
        return;
      }

      await client.from('users').update(updates).eq('id', ownerId);

      debugPrint('✅ [OwnerDataSource] Profile updated successfully');
    } catch (e) {
      debugPrint('❌ [OwnerDataSource] Error updating profile: $e');
      throw ServerException('Failed to update profile: $e');
    }
  }
}
