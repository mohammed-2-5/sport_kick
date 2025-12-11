import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_admin_card.dart';

/// Premium list content for super admin admins.
///
/// Features:
/// - Responsive grid layout
/// - Staggered animations
/// - Pull-to-refresh
/// - Empty state
/// - Loading shimmer
class PremiumAdminsListContent extends StatelessWidget {
  final List<UserEntity> admins;
  final bool isLoading;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final Function(String) onToggleSelection;
  final Function(String) onActivateAdmin;
  final Function(String) onDeactivateAdmin;
  final String emptyMessage;

  const PremiumAdminsListContent({
    super.key,
    required this.admins,
    required this.isLoading,
    required this.isRefreshing,
    required this.onRefresh,
    required this.isSelectionMode,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onActivateAdmin,
    required this.onDeactivateAdmin,
    this.emptyMessage = 'No admins found',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && !isRefreshing) {
      return _LoadingShimmer();
    }

    if (admins.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppColors.premiumGold,
      backgroundColor: Colors.white,
      child: _buildAdminsList(context),
    );
  }

  Widget _buildAdminsList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);

    if (crossAxisCount == 1) {
      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: admins.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildAdminCard(context, admins[index]),
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
      itemCount: admins.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 375),
          columnCount: crossAxisCount,
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: _buildAdminCard(context, admins[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminCard(BuildContext context, UserEntity admin) {
    return PremiumAdminCard(
      id: admin.id,
      name: admin.fullName ?? 'Unknown',
      email: admin.email,
      phone: admin.phone,
      isActive: admin.isActive,
      fieldsCount: 0, // Would come from admin data
      isSelected: selectedIds.contains(admin.id),
      isSelectable: isSelectionMode,
      onTap: () {
        if (isSelectionMode) {
          onToggleSelection(admin.id);
        } else {
          context.pushNamed('adminDetails', pathParameters: {'id': admin.id});
        }
      },
      onSelectionChanged: (selected) => onToggleSelection(admin.id),
      onToggleStatus: isSelectionMode
          ? null
          : () {
              if (admin.isActive) {
                onDeactivateAdmin(admin.id);
              } else {
                onActivateAdmin(admin.id);
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
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    AppColors.shimmerBase,
                    AppColors.shimmerHighlight,
                    AppColors.shimmerBase,
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
              Icons.admin_panel_settings_outlined,
              size: 60,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
