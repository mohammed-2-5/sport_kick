import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Week navigation bar with previous/next buttons and today shortcut.
class WeekNavigationBar extends StatelessWidget {
  final String weekRangeString;
  final bool isCurrentWeek;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onToday;

  const WeekNavigationBar({
    required this.weekRangeString,
    required this.isCurrentWeek,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onToday,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous week button
          _NavButton(icon: Icons.chevron_left_rounded, onTap: onPreviousWeek),

          // Week range display
          Expanded(
            child: Column(
              children: [
                Text(
                  weekRangeString,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!isCurrentWeek)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: GestureDetector(
                      onTap: onToday,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.goldAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          context.l10n.goToToday,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.goldAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Next week button
          _NavButton(icon: Icons.chevron_right_rounded, onTap: onNextWeek),
        ],
      ),
    );
  }
}

/// Navigation button for week navigation.
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.navyDeep,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
