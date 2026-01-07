import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/notifications/domain/entities/notification_entity.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_state.dart';
import 'package:spo_kick/features/notifications/presentation/widgets/notification_empty_view.dart';
import 'package:spo_kick/features/notifications/presentation/widgets/notification_error_view.dart';
import 'package:spo_kick/features/notifications/presentation/widgets/notification_item.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          context.l10n.notifications,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.unreadCount > 0) {
                return TextButton(
                  onPressed: () =>
                      context.read<NotificationCubit>().markAllAsRead(),
                  child: Text(
                    context.l10n.markAllRead,
                    style: TextStyle(color: colorScheme.primary, fontSize: 14),
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
            return Center(
              child: LoadingIndicator.inline(color: colorScheme.primary),
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
              color: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.notifications.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.notifications.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: LoadingIndicator.inline(
                          size: 24,
                          color: colorScheme.primary,
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
    final cubit = context.read<NotificationCubit>();

    if (!notification.isRead) {
      cubit.markAsRead(notification.id);
    }
  }
}
