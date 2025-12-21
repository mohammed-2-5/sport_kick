import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Count badge widget displayed on the map.
class MapFieldsCountBadge extends StatelessWidget {
  final int count;

  const MapFieldsCountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            context.l10n
                .fieldsCount(count)
                .replaceFirst(
                  count.toString(),
                  LocaleFormatters.formatNumber(context, count),
                ),
            style: AppTextStyles.labelLarge,
          ),
        ],
      ),
    );
  }
}
