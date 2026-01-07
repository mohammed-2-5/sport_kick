import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_user_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium list content for super admin users.
///
/// Features:
/// - Responsive grid layout
/// - Staggered animations
/// - Pull-to-refresh
/// - Empty state
/// - Loading shimmer
class PremiumUsersListContent extends StatelessWidget {
  final List<UserEntity> users;
  final bool isLoading;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final Function(String) onToggleSelection;
  final Function(String) onActivateUser;
  final Function(String) onDeactivateUser;
  final String emptyMessage;

  const PremiumUsersListContent({
    super.key,
    required this.users,
    required this.isLoading,
    required this.isRefreshing,
    required this.onRefresh,
    required this.isSelectionMode,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onActivateUser,
    required this.onDeactivateUser,
    this.emptyMessage = 'No users found',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && !isRefreshing) {
      return _LoadingShimmer();
    }

    if (users.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppColors.premiumGold,
      backgroundColor: colorScheme.surface,
      child: _buildUsersList(context),
    );
  }

  Widget _buildUsersList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);

    if (crossAxisCount == 1) {
      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: users.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildUserCard(context, users[index]),
              ),
            ),
          );
        },
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 375),
          columnCount: crossAxisCount,
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: _buildUserCard(context, users[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserCard(BuildContext context, UserEntity user) {
    return PremiumUserCard(
      id: user.id,
      name: user.fullName ?? 'Unknown',
      email: user.email,
      phone: user.phone,
      isActive: user.isActive,
      bookingsCount: 0, // Would come from user data
      isSelected: selectedIds.contains(user.id),
      isSelectable: isSelectionMode,
      onTap: () {
        if (isSelectionMode) {
          onToggleSelection(user.id);
        } else {
          context.pushNamed('superAdminUserDetails', extra: user);
        }
      },
      onSelectionChanged: (selected) => onToggleSelection(user.id),
      onToggleStatus: isSelectionMode
          ? null
          : () {
              if (user.isActive) {
                onDeactivateUser(user.id);
              } else {
                onActivateUser(user.id);
              }
            },
      onDelete: null,
    );
  }
}

/// Loading shimmer effect.
class _LoadingShimmer extends StatefulWidget {
  @override
  State<_LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<_LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final colorScheme = Theme.of(context).colorScheme;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    colorScheme.shimmerBase,
                    colorScheme.shimmerHighlight,
                    colorScheme.shimmerBase,
                  ],
                  stops: [
                    (0.3 + _animation.value / 4).clamp(0.0, 1.0),
                    (0.5 + _animation.value / 4).clamp(0.0, 1.0),
                    (0.7 + _animation.value / 4).clamp(0.0, 1.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Empty state with icon and message.
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.premiumGold.withValues(alpha: 0.1),
                  AppColors.premiumGoldDark.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Icon(
              Icons.people_outline,
              size: 60,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: AppTextStyles.bold(
              AppTextStyles.titleMedium,
            ).copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.tryAdjustingYourSearchOrFilters,
            style: AppTextStyles.bodyMediumSecondary.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
