import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium description card with expand/collapse.
///
/// Features:
/// - Expandable text content
/// - Read more/less toggle
/// - Premium card styling
class PremiumDescriptionCard extends StatefulWidget {
  final String description;

  const PremiumDescriptionCard({super.key, required this.description});

  @override
  State<PremiumDescriptionCard> createState() => _PremiumDescriptionCardState();
}

class _PremiumDescriptionCardState extends State<PremiumDescriptionCard> {
  bool _isExpanded = false;
  static const int _maxLines = 4;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.accentCyan,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.aboutThisField,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  maxLines: _maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        context.l10n.readMore,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.accentCyan,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: AppColors.accentCyan,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        context.l10n.showLess,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.accentCyan,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_up,
                        size: 18,
                        color: AppColors.accentCyan,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
