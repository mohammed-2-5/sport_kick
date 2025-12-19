import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

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
              _BackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Users',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View and manage all customer accounts',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              _SelectionButton(
                isActive: isSelectionMode,
                onTap: onToggleSelection,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search bar
          _SearchBar(
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
                _StatChip(label: 'Total', count: stats['total'] ?? 0),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Active',
                  count: stats['active'] ?? 0,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Inactive',
                  count: stats['inactive'] ?? 0,
                  color: Colors.grey,
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

/// Search bar with glass effect.
class _SearchBar extends StatelessWidget {
  final String query;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: TextField(
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search by name, email, or phone...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      onPressed: onClear,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Stat chip showing count.
class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color? color;

  const _StatChip({required this.label, required this.count, this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (color ?? Colors.white).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (color ?? Colors.white).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
