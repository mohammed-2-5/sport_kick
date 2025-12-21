import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium profile section card.
///
/// Features:
/// - Section title
/// - List of items
/// - Edit mode support
class PremiumProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final VoidCallback? onEdit;

  const PremiumProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.accentCyan, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (onEdit != null)
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: AppColors.accentCyan,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.edit,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 8),
            // Items
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Profile info item.
class ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool canCopy;
  final Widget? trailing;

  const ProfileInfoItem({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.canCopy = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (canCopy)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.copiedToClipboard),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Icon(
                Icons.copy_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Profile action item (tappable).
class ProfileActionItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showArrow;
  final bool isDestructive;

  const ProfileActionItem({
    super.key,
    required this.label,
    required this.icon,
    this.iconColor,
    required this.onTap,
    this.trailing,
    this.showArrow = true,
    this.isDestructive = false,
  });

  @override
  State<ProfileActionItem> createState() => _ProfileActionItemState();
}

class _ProfileActionItemState extends State<ProfileActionItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isDestructive
        ? Colors.red
        : (widget.iconColor ?? AppColors.textPrimary);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.backgroundLight : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.label,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.isDestructive
                      ? Colors.red
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (widget.trailing != null)
              widget.trailing!
            else if (widget.showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}

/// Stats row for profile.
class ProfileStatsRow extends StatelessWidget {
  final List<ProfileStat> stats;

  const ProfileStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: index < stats.length - 1
                  ? const Border(right: BorderSide(color: AppColors.border))
                  : null,
            ),
            child: Column(
              children: [
                Text(
                  stat.value,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ProfileStat {
  final String label;
  final String value;

  const ProfileStat({required this.label, required this.value});
}
