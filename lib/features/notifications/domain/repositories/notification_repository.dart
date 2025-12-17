import 'package:dartz/dartz.dart';
import 'package:spo_kick/features/notifications/domain/entities/notification_entity.dart';

import '../../../../core/errors/failures.dart';

/// Repository interface for notification operations.
///
/// This defines the contract for notification data operations.
/// Implementations handle the actual data fetching from Supabase.
/// Updated: December 2025
abstract class NotificationRepository {
  /// Get all notifications for the current user.
  ///
  /// Returns a paginated list of notifications ordered by creation date.
  /// [limit] - Maximum number of notifications to return (default: 20)
  /// [offset] - Number of notifications to skip (for pagination)
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int limit = 20,
    int offset = 0,
  });

  /// Get unread notification count for the current user.
  Future<Either<Failure, int>> getUnreadCount();

  /// Mark a single notification as read.
  Future<Either<Failure, void>> markAsRead(String notificationId);

  /// Mark multiple notifications as read.
  Future<Either<Failure, void>> markMultipleAsRead(
    List<String> notificationIds,
  );

  /// Mark all notifications as read for the current user.
  Future<Either<Failure, void>> markAllAsRead();

  /// Delete a notification.
  Future<Either<Failure, void>> deleteNotification(String notificationId);

  /// Stream of real-time notifications for the current user.
  Stream<NotificationEntity> notificationsStream();

  /// Stream of unread count changes.
  Stream<int> unreadCountStream();
}
