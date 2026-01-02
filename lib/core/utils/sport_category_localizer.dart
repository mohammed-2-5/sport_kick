import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

/// Extension to get localized names for sport categories
extension SportCategoryLocalizer on SportCategoryEntity {
  /// Returns the localized name of the sport category based on current locale
  String getLocalizedName(BuildContext context) {
    final l10n = context.l10n;
    final lowerName = name.toLowerCase();

    if (lowerName.contains('football') || lowerName.contains('soccer')) {
      return l10n.sportFootball;
    } else if (lowerName.contains('tennis')) {
      return l10n.sportTennis;
    } else if (lowerName.contains('basketball')) {
      return l10n.sportBasketball;
    } else if (lowerName.contains('padel')) {
      return l10n.sportPadel;
    } else if (lowerName.contains('volleyball')) {
      return l10n.sportVolleyball;
    }

    // Fallback to original name if no match found
    return name;
  }
}
