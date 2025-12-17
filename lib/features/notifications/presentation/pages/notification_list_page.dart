import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/notifications/domain/entities/notification_entity.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_state.dart';
import 'package:spo_kick/features/notifications/presentation/widgets/notification_empty_view.dart';
import 'package:spo_kick/features/notifications/presentation/widgets/notification_error_view.dart';
import 'package:spo_kick/features/notifications/presentation/widgets/notification_item.dart';

/// Page displaying the list of notifications.
///
/// Supports pagination, pull-to-refresh, and real-time updates.
/// Updated: December 2025
class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.premiumBackground,
      appBar: AppBar(
        backgroundColor: AppColors.premiumBackground,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.unreadCount > 0) {
                return TextButton(
                  onPressed: () =>
                      context.read<NotificationCubit>().markAllAsRead(),
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(color: AppColors.accentCyan, fontSize: 14),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: LoadingIndicator.inline(color: AppColors.accentCyan),
            );
          }

          if (state is NotificationError) {
            return NotificationErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<NotificationCubit>().loadNotifications(),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const NotificationEmptyView();
            }

            return RefreshIndicator(
              onRefresh: () => context.read<NotificationCubit>().refresh(),
              color: AppColors.accentCyan,
              backgroundColor: AppColors.premiumSurface,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.notifications.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.notifications.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: LoadingIndicator.inline(
                          size: 24,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    );
                  }

                  final notification = state.notifications[index];
                  return NotificationItem(
                    notification: notification,
                    onTap: () => _handleNotificationTap(notification),
                    onDismiss: () => context
                        .read<NotificationCubit>()
                        .deleteNotification(notification.id),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleNotificationTap(NotificationEntity notification) {
    if (!notification.isRead) {
      context.read<NotificationCubit>().markAsRead(notification.id);
    }

    final bookingId = notification.bookingId;
    if (bookingId != null && notification.isBookingNotification) {
      // TODO: Navigate to booking details when route is available
    }
  }
}
