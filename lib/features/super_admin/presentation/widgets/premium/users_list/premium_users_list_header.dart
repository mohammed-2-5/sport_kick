import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/users_list/components/users_list_header_back_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/users_list/components/users_list_header_selection_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/users_list/components/users_list_header_search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/users_list/components/users_list_header_stat_chip.dart';

/// Premium header for super admin users list.
///
/// Features:
/// - Gold gradient background
/// - Search bar with blur effect
/// - Stats chips showing counts
/// - Back button and selection toggle
class PremiumUsersListHeader extends StatelessWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;
  final Map<String, int> stats;
  final bool isSelectionMode;
  final VoidCallback onToggleSelection;

  const PremiumUsersListHeader({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.stats,
    required this.isSelectionMode,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              UsersListHeaderBackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.manageUsers,
                      style: AppTextStyles.headlineSmallWhite,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.viewAndManageAllCustomerAccounts,
                      style: AppTextStyles.labelMediumWhite,
                    ),
                  ],
                ),
              ),
              UsersListHeaderSelectionButton(
                isActive: isSelectionMode,
                onTap: onToggleSelection,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search bar
          UsersListHeaderSearchBar(
            query: searchQuery,
            onChanged: onSearchChanged,
            onClear: onClearSearch,
          ),

          const SizedBox(height: 16),

          // Stats chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                UsersListHeaderStatChip(
                  label: context.l10n.total,
                  count: stats[context.l10n.total2] ?? 0,
                ),
                const SizedBox(width: 8),
                UsersListHeaderStatChip(
                  label: context.l10n.active,
                  count: stats[context.l10n.active2] ?? 0,
                  color: colorScheme.success,
                ),
                const SizedBox(width: 8),
                UsersListHeaderStatChip(
                  label: context.l10n.inactive,
                  count: stats[context.l10n.inactive2] ?? 0,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Back button with glass effect.
class _BackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Selection toggle button.
class _SelectionButton extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _SelectionButton({required this.isActive, required this.onTap});

  @override
  State<_SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<_SelectionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.isActive
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Icon(
                widget.isActive ? Icons.close : Icons.checklist,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
