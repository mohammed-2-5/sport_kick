import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium bulk action bar for list selections.
///
/// Features:
/// - Animated appearance
/// - Selection count display
/// - Action buttons
/// - Select all / Deselect all
class PremiumBulkActionBar extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback? onActivate;
  final VoidCallback? onDeactivate;
  final VoidCallback? onDelete;
  final VoidCallback? onExport;

  const PremiumBulkActionBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.onSelectAll,
    required this.onDeselectAll,
    this.onActivate,
    this.onDeactivate,
    this.onDelete,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: selectedCount > 0 ? 60 : 0,
      child: selectedCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.premiumGold.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Selection info
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      if (selectedCount == totalCount) {
                        onDeselectAll();
                      } else {
                        onSelectAll();
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            selectedCount == totalCount
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$selectedCount selected',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Action buttons
                  Row(
                    children: [
                      if (onActivate != null)
                        _ActionIcon(
                          icon: Icons.check_circle_outline,
                          tooltip: 'Activate',
                          onTap: onActivate!,
                        ),
                      if (onDeactivate != null)
                        _ActionIcon(
                          icon: Icons.block,
                          tooltip: 'Deactivate',
                          onTap: onDeactivate!,
                        ),
                      if (onExport != null)
                        _ActionIcon(
                          icon: Icons.download,
                          tooltip: 'Export',
                          onTap: onExport!,
                        ),
                      if (onDelete != null)
                        _ActionIcon(
                          icon: Icons.delete_outline,
                          tooltip: 'Delete',
                          onTap: onDelete!,
                          isDanger: true,
                        ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

/// Action icon button.
class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isDanger;

  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: isDanger
                ? Colors.red.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDanger ? Colors.red.shade100 : Colors.white,
          ),
        ),
      ),
    );
  }
}
