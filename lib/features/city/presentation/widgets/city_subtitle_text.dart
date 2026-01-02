import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';

/// City Subtitle Text
///
/// Theme-aware: adapts to light/dark mode.
class CitySubtitleText extends StatelessWidget {
  final CityEntity city;

  const CitySubtitleText({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final subtitle = _subtitleText(context);
    if (subtitle == null) return const SizedBox.shrink();

    return Text(
      subtitle,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  String? _subtitleText(BuildContext context) {
    final parts = <String>[];
    if (city.arabicName != null) {
      parts.add(city.arabicName!);
    }
    if (city.fieldsCount != null && city.fieldsCount! > 0) {
      parts.add(context.l10n.fieldsCount(city.fieldsCount!));
    }
    if (parts.isEmpty) return null;
    return parts.join(' • ');
  }
}
