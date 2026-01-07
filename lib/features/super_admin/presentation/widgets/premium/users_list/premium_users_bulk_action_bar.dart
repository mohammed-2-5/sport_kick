import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Premium bulk action bar for users list.
///
/// Features:
/// - Shows when users are selected
/// - Gold gradient design
/// - Select all/Deselect all
/// - Activate/Deactivate actions
/// - Smooth slide animation
class PremiumUsersBulkActionBar extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;

  const PremiumUsersBulkActionBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onActivate,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) {
      return const SizedBox.shrink();
    }

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: selectedCount > 0 ? Offset.zero : const Offset(0, 1),
      curve: Curves.easeOut,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.premiumGold.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selection info and toggle
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.selectedCount(selectedCount),
                        style: AppTextStyles.titleMediumWhite,
                      ),
                      Text(
                        context.l10n.ofTotalUsers(totalCount),
                        style: AppTextStyles.labelSmallWhite,
                      ),
                    ],
                  ),
                ),
                _ActionButton(
                  icon: selectedCount == totalCount
                      ? Icons.deselect
                      : Icons.select_all,
                  label: selectedCount == totalCount
                      ? context.l10n.deselect
                      : context.l10n.all,
                  onTap: selectedCount == totalCount
                      ? onDeselectAll
                      : onSelectAll,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 12),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _BulkActionButton(
                    icon: Icons.check_circle_outline,
                    label: context.l10n.activate,
                    onTap: onActivate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BulkActionButton(
                    icon: Icons.block,
                    label: context.l10n.deactivate,
                    onTap: onDeactivate,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small action button.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.withColor(
                AppTextStyles.bold(AppTextStyles.labelLarge),
                Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bulk action button.
class _BulkActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BulkActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: context.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.premiumGold),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.withColor(
                AppTextStyles.bold(AppTextStyles.bodyMedium),
                AppColors.premiumGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
