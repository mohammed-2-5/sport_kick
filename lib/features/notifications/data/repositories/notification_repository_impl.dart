import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'package:spo_kick/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:spo_kick/features/notifications/domain/entities/notification_entity.dart';
import 'package:spo_kick/features/notifications/domain/repositories/notification_repository.dart';

import '../../../../core/errors/failures.dart';

/// Implementation of NotificationRepository using Supabase.
///
/// Handles error conversion and data transformation.
/// Updated: December 2025
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final notifications = await _remoteDataSource.getNotifications(
        limit: limit,
        offset: offset,
      );
      return Right(notifications);
    } catch (e) {
      debugPrint('[NotificationRepository] Error getting notifications: $e');
      return const Left(ServerFailure('Failed to load notifications'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      debugPrint('[NotificationRepository] Error getting unread count: $e');
      return const Left(ServerFailure('Failed to get unread count'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      debugPrint('[NotificationRepository] Error marking as read: $e');
      return const Left(ServerFailure('Failed to mark notification as read'));
    }
  }

  @override
  Future<Either<Failure, void>> markMultipleAsRead(
    List<String> notificationIds,
  ) async {
    try {
      await _remoteDataSource.markMultipleAsRead(notificationIds);
      return const Right(null);
    } catch (e) {
      debugPrint('[NotificationRepository] Error marking multiple as read: $e');
      return const Left(ServerFailure('Failed to mark notifications as read'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _remoteDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      debugPrint('[NotificationRepository] Error marking all as read: $e');
      return const Left(ServerFailure('Failed to mark all as read'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(
    String notificationId,
  ) async {
    try {
      await _remoteDataSource.deleteNotification(notificationId);
      return const Right(null);
    } catch (e) {
      debugPrint('[NotificationRepository] Error deleting notification: $e');
      return const Left(ServerFailure('Failed to delete notification'));
    }
  }

  @override
  Stream<NotificationEntity> notificationsStream() {
    return _remoteDataSource.notificationsStream();
  }

  @override
  Stream<int> unreadCountStream() {
    return _remoteDataSource.unreadCountStream();
  }
}
