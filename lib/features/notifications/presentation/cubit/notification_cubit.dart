import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spo_kick/features/notifications/domain/entities/notification_entity.dart';
import 'package:spo_kick/features/notifications/domain/repositories/notification_repository.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_state.dart';

/// Cubit for managing notification state.
///
/// Handles loading, pagination, and real-time updates.
/// Updated: December 2025
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;

  static const int _pageSize = 20;
  StreamSubscription<NotificationEntity>? _notificationSubscription;
  StreamSubscription<int>? _unreadCountSubscription;

  NotificationCubit({required NotificationRepository repository})
    : _repository = repository,
      super(const NotificationInitial());

  /// Load initial notifications.
  Future<void> loadNotifications() async {
    emit(const NotificationLoading());

    final result = await _repository.getNotifications(
      limit: _pageSize,
      offset: 0,
    );

    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notifications) async {
        final unreadResult = await _repository.getUnreadCount();
        final unreadCount = unreadResult.fold((_) => 0, (count) => count);

        emit(
          NotificationLoaded(
            notifications: notifications,
            unreadCount: unreadCount,
            hasMore: notifications.length >= _pageSize,
          ),
        );

        _subscribeToRealtime();
      },
    );
  }

  /// Load more notifications (pagination).
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! NotificationLoaded ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await _repository.getNotifications(
      limit: _pageSize,
      offset: currentState.notifications.length,
    );

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (newNotifications) {
        emit(
          currentState.copyWith(
            notifications: [...currentState.notifications, ...newNotifications],
            hasMore: newNotifications.length >= _pageSize,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Mark a notification as read.
  Future<void> markAsRead(String notificationId) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    await _repository.markAsRead(notificationId);

    final updatedNotifications = currentState.notifications.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(isRead: true, readAt: DateTime.now());
      }
      return n;
    }).toList();

    emit(
      currentState.copyWith(
        notifications: updatedNotifications,
        unreadCount: (currentState.unreadCount - 1).clamp(0, 9999),
      ),
    );
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    await _repository.markAllAsRead();

    final updatedNotifications = currentState.notifications.map((n) {
      return n.copyWith(isRead: true, readAt: DateTime.now());
    }).toList();

    emit(
      currentState.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      ),
    );
  }

  /// Delete a notification.
  Future<void> deleteNotification(String notificationId) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    await _repository.deleteNotification(notificationId);

    final deletedNotification = currentState.notifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => currentState.notifications.first,
    );

    final updatedNotifications = currentState.notifications
        .where((n) => n.id != notificationId)
        .toList();

    emit(
      currentState.copyWith(
        notifications: updatedNotifications,
        unreadCount: deletedNotification.isRead
            ? currentState.unreadCount
            : (currentState.unreadCount - 1).clamp(0, 9999),
      ),
    );
  }

  /// Refresh notifications.
  Future<void> refresh() async {
    await loadNotifications();
  }

  /// Get current unread count.
  int get unreadCount {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      return currentState.unreadCount;
    }
    return 0;
  }

  void _subscribeToRealtime() {
    _notificationSubscription?.cancel();
    _unreadCountSubscription?.cancel();

    _notificationSubscription = _repository.notificationsStream().listen((
      notification,
    ) {
      final currentState = state;
      if (currentState is NotificationLoaded) {
        emit(
          currentState.copyWith(
            notifications: [notification, ...currentState.notifications],
            unreadCount: currentState.unreadCount + 1,
          ),
        );
      }
    });

    _unreadCountSubscription = _repository.unreadCountStream().listen((count) {
      final currentState = state;
      if (currentState is NotificationLoaded) {
        emit(currentState.copyWith(unreadCount: count));
      }
    });
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    _unreadCountSubscription?.cancel();
    return super.close();
  }
}
