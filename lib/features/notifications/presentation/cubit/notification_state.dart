import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/notifications/domain/entities/notification_entity.dart';

/// States for the notification cubit.
///
/// Updated: December 2025
sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
final class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

/// State when notifications are being loaded.
final class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

/// State when notifications are loaded successfully.
final class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool hasMore;
  final bool isLoadingMore;

  const NotificationLoaded({
    required this.notifications,
    required this.unreadCount,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    unreadCount,
    hasMore,
    isLoadingMore,
  ];
}

/// State when there's an error loading notifications.
final class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object?> get props => [message];
}
