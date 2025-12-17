import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spo_kick/features/notifications/data/models/notification_model.dart';

/// Remote data source for notification operations.
///
/// Handles all Supabase interactions for the notifications table.
/// Updated: December 2025
abstract class NotificationRemoteDataSource {
  /// Fetch notifications for current user with pagination.
  Future<List<NotificationModel>> getNotifications({
    int limit = 20,
    int offset = 0,
  });

  /// Get unread notification count.
  Future<int> getUnreadCount();

  /// Mark notification as read.
  Future<void> markAsRead(String notificationId);

  /// Mark multiple notifications as read.
  Future<void> markMultipleAsRead(List<String> notificationIds);

  /// Mark all notifications as read.
  Future<void> markAllAsRead();

  /// Delete a notification.
  Future<void> deleteNotification(String notificationId);

  /// Stream of real-time notification updates.
  Stream<NotificationModel> notificationsStream();

  /// Stream of unread count.
  Stream<int> unreadCountStream();
}

/// Implementation of NotificationRemoteDataSource using Supabase.
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient _supabase;
  StreamController<NotificationModel>? _notificationStreamController;
  StreamController<int>? _unreadCountStreamController;
  RealtimeChannel? _notificationChannel;

  NotificationRemoteDataSourceImpl({required SupabaseClient supabase})
    : _supabase = supabase;

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  @override
  Future<List<NotificationModel>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabase
        .from('notifications')
        .select()
        .eq('user_id', _currentUserId!)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    if (_currentUserId == null) return 0;

    try {
      final result = await _supabase.rpc(
        'get_unread_notification_count',
        params: {'p_user_id': _currentUserId},
      );
      return result as int? ?? 0;
    } catch (e) {
      debugPrint('[NotificationDataSource] Error getting unread count: $e');
      // Fallback to direct count query
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('is_read', false);
      return (response as List).length;
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    if (_currentUserId == null) return;

    await _supabase
        .from('notifications')
        .update({'is_read': true, 'read_at': DateTime.now().toIso8601String()})
        .eq('id', notificationId)
        .eq('user_id', _currentUserId!);
  }

  @override
  Future<void> markMultipleAsRead(List<String> notificationIds) async {
    if (_currentUserId == null || notificationIds.isEmpty) return;

    try {
      await _supabase.rpc(
        'mark_notifications_read',
        params: {'p_notification_ids': notificationIds},
      );
    } catch (e) {
      debugPrint('[NotificationDataSource] Error marking multiple as read: $e');
      // Fallback to individual updates
      for (final id in notificationIds) {
        await markAsRead(id);
      }
    }
  }

  @override
  Future<void> markAllAsRead() async {
    if (_currentUserId == null) return;

    try {
      await _supabase.rpc('mark_all_notifications_read');
    } catch (e) {
      debugPrint('[NotificationDataSource] Error marking all as read: $e');
      // Fallback to direct update
      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', _currentUserId!)
          .eq('is_read', false);
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    if (_currentUserId == null) return;

    await _supabase
        .from('notifications')
        .delete()
        .eq('id', notificationId)
        .eq('user_id', _currentUserId!);
  }

  @override
  Stream<NotificationModel> notificationsStream() {
    _notificationStreamController?.close();
    _notificationStreamController =
        StreamController<NotificationModel>.broadcast();

    if (_currentUserId == null) {
      return _notificationStreamController!.stream;
    }

    _setupRealtimeSubscription();

    return _notificationStreamController!.stream;
  }

  void _setupRealtimeSubscription() {
    _notificationChannel?.unsubscribe();

    _notificationChannel = _supabase
        .channel('notifications:$_currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _currentUserId!,
          ),
          callback: (payload) {
            debugPrint('[NotificationDataSource] New notification received');
            final notification = NotificationModel.fromJson(payload.newRecord);
            _notificationStreamController?.add(notification);
            _updateUnreadCount();
          },
        )
        .subscribe();
  }

  @override
  Stream<int> unreadCountStream() {
    _unreadCountStreamController?.close();
    _unreadCountStreamController = StreamController<int>.broadcast();

    // Emit initial count
    _updateUnreadCount();

    return _unreadCountStreamController!.stream;
  }

  Future<void> _updateUnreadCount() async {
    final count = await getUnreadCount();
    _unreadCountStreamController?.add(count);
  }

  /// Clean up resources.
  void dispose() {
    _notificationChannel?.unsubscribe();
    _notificationStreamController?.close();
    _unreadCountStreamController?.close();
  }
}
