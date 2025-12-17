import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/features/recurring_bookings/data/models/recurring_booking_model.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';

/// Remote data source for recurring booking operations.
abstract class RecurringBookingRemoteDataSource {
  /// Create a recurring booking request.
  Future<String> createRecurringRequest({
    required String fieldId,
    required int dayOfWeek,
    required String startTime,
    required int durationHours,
  });

  /// Cancel an active recurring booking.
  Future<bool> cancelRecurringBooking({
    required String recurringBookingId,
    String? reason,
  });

  /// Get user's recurring bookings.
  Future<List<RecurringBookingModel>> getMyRecurringBookings();

  /// Approve a recurring booking request.
  Future<bool> approveRecurringBooking({required String recurringBookingId});

  /// Reject a recurring booking request.
  Future<bool> rejectRecurringBooking({
    required String recurringBookingId,
    required String reason,
  });

  /// Get pending recurring requests for owner's fields.
  Future<List<RecurringBookingModel>> getPendingRecurringRequests();

  /// Get active recurring bookings for owner's fields.
  Future<List<RecurringBookingModel>> getActiveRecurringBookingsForOwner();

  /// Check if a slot is reserved.
  Future<bool> isSlotReserved({
    required String fieldId,
    required int dayOfWeek,
    required String startTime,
  });

  /// Get reserved slots for a field.
  Future<List<ReservedSlot>> getReservedSlots({required String fieldId});
}

/// Implementation of recurring booking remote data source using Supabase.
class RecurringBookingRemoteDataSourceImpl
    implements RecurringBookingRemoteDataSource {
  final SupabaseClient _supabaseClient;

  RecurringBookingRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<String> createRecurringRequest({
    required String fieldId,
    required int dayOfWeek,
    required String startTime,
    required int durationHours,
  }) async {
    try {
      debugPrint(
        '📅 [RecurringBooking] Creating request: field=$fieldId, '
        'day=$dayOfWeek, time=$startTime, duration=$durationHours',
      );

      final result = await _supabaseClient.rpc(
        'create_recurring_booking_request',
        params: {
          'p_field_id': fieldId,
          'p_day_of_week': dayOfWeek,
          'p_start_time': startTime,
          'p_duration_hours': durationHours,
        },
      );

      debugPrint('✅ [RecurringBooking] Request created: $result');
      return result as String;
    } catch (e) {
      debugPrint('❌ [RecurringBooking] Create request failed: $e');
      rethrow;
    }
  }

  @override
  Future<bool> cancelRecurringBooking({
    required String recurringBookingId,
    String? reason,
  }) async {
    try {
      debugPrint(
        '🚫 [RecurringBooking] Canceling: $recurringBookingId, reason: $reason',
      );

      final result = await _supabaseClient.rpc(
        'cancel_recurring_booking',
        params: {
          'p_recurring_id': recurringBookingId,
          'p_reason': reason ?? 'user_request',
        },
      );

      debugPrint('✅ [RecurringBooking] Canceled: $result');
      return result as bool;
    } catch (e) {
      debugPrint('❌ [RecurringBooking] Cancel failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<RecurringBookingModel>> getMyRecurringBookings() async {
    try {
      debugPrint('📋 [RecurringBooking] Fetching user recurring bookings...');

      final result = await _supabaseClient.rpc('get_my_recurring_bookings');

      final List<dynamic> data = result as List<dynamic>;
      final bookings = data
          .map(
            (json) => RecurringBookingModel.fromUserJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

      debugPrint(
        '✅ [RecurringBooking] Fetched ${bookings.length} recurring bookings',
      );
      return bookings;
    } catch (e) {
      debugPrint('❌ [RecurringBooking] Fetch user bookings failed: $e');
      rethrow;
    }
  }

  @override
  Future<bool> approveRecurringBooking({
    required String recurringBookingId,
  }) async {
    try {
      debugPrint('✅ [RecurringBooking] Approving: $recurringBookingId');

      final result = await _supabaseClient.rpc(
        'approve_recurring_booking',
        params: {'p_recurring_id': recurringBookingId},
      );

      debugPrint('✅ [RecurringBooking] Approved: $result');
      return result as bool;
    } catch (e) {
      debugPrint('❌ [RecurringBooking] Approve failed: $e');
      rethrow;
    }
  }

  @override
  Future<bool> rejectRecurringBooking({
    required String recurringBookingId,
    required String reason,
  }) async {
    try {
      debugPrint(
        '❌ [RecurringBooking] Rejecting: $recurringBookingId, reason: $reason',
      );

      final result = await _supabaseClient.rpc(
        'reject_recurring_booking',
        params: {'p_recurring_id': recurringBookingId, 'p_reason': reason},
      );

      debugPrint('✅ [RecurringBooking] Rejected: $result');
      return result as bool;
    } catch (e) {
      debugPrint('❌ [RecurringBooking] Reject failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<RecurringBookingModel>> getPendingRecurringRequests() async {
    try {
      debugPrint('📋 [RecurringBooking] Fetching pending requests...');

      final result = await _supabaseClient.rpc(
        'get_pending_recurring_requests',
      );

      final List<dynamic> data = result as List<dynamic>;
      final requests = data
          .map(
            (json) => RecurringBookingModel.fromPendingRequestJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

      debugPrint(
        '✅ [RecurringBooking] Fetched ${requests.length} pending requests',
      );
      return requests;
    } catch (e) {
      debugPrint('❌ [RecurringBooking] Fetch pending requests failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<RecurringBookingModel>>
  getActiveRecurringBookingsForOwner() async {
    try {
      debugPrint(
        '📋 [RecurringBooking] Fetching active recurring for owner...',
      );

      final result = await _supabaseClient.rpc(
        'get_active_recurring_bookings_for_owner',
      );

      final List<dynamic> data = result as List<dynamic>;
      final bookings = data
          .map(
            (json) => RecurringBookingModel.fromActiveOwnerJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

      debugPrint(
        '✅ [RecurringBooking] Fetched ${bookings.length} active recurring',
      );
      return bookings;
    } catch (e) {
      debugPrint('❌ [RecurringBooking] Fetch active recurring failed: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isSlotReserved({
    required String fieldId,
    required int dayOfWeek,
    required String startTime,
  }) async {
    try {
      final result = await _supabaseClient.rpc(
        'is_slot_reserved_recurring',
        params: {
          'p_field_id': fieldId,
          'p_day_of_week': dayOfWeek,
          'p_start_time': startTime,
        },
      );

      return result as bool;
    } catch (e) {
      debugPrint('❌ [RecurringBooking] Check reserved slot failed: $e');
      return false;
    }
  }

  @override
  Future<List<ReservedSlot>> getReservedSlots({required String fieldId}) async {
    try {
      final result = await _supabaseClient.rpc(
        'get_reserved_recurring_slots',
        params: {'p_field_id': fieldId},
      );

      final List<dynamic> data = result as List<dynamic>;
      return data.map((json) {
        final map = json as Map<String, dynamic>;
        return ReservedSlot(
          dayOfWeek: map['day_of_week'] as int,
          startTime: _formatTime(map['start_time']),
          endTime: _formatTime(map['end_time']),
          userName: map['user_name'] as String?,
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ [RecurringBooking] Get reserved slots failed: $e');
      return [];
    }
  }

  String _formatTime(dynamic time) {
    if (time == null) return '00:00';
    final timeStr = time.toString();
    final parts = timeStr.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return timeStr;
  }
}
