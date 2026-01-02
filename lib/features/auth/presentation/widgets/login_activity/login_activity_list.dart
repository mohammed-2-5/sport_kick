import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login_activity/login_activity_empty_state.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login_activity/login_activity_item.dart';

/// Login Activity List Widget
///
/// Displays a scrollable list of login activities with
/// pull-to-refresh and pagination support.
class LoginActivityList extends StatelessWidget {
  final List<LoginActivityEntity> activities;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final VoidCallback onRefresh;

  const LoginActivityList({
    super.key,
    required this.activities,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const LoginActivityEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: AppColors.premiumGold,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 100 &&
              hasMore &&
              !isLoadingMore) {
            onLoadMore();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activities.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == activities.length) {
              return const _LoadingIndicator();
            }
            return LoginActivityItem(activity: activities[index]);
          },
        ),
      ),
    );
  }
}

/// Loading indicator for pagination.
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
