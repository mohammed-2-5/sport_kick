import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';

class CitySubtitleText extends StatelessWidget {
  final CityEntity city;

  const CitySubtitleText({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final subtitle = _subtitleText();
    if (subtitle == null) return const SizedBox.shrink();

    return Text(
      subtitle,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
    );
  }

  String? _subtitleText() {
    final parts = <String>[];
    if (city.arabicName != null) {
      parts.add(city.arabicName!);
    }
    if (city.fieldsCount != null && city.fieldsCount! > 0) {
      parts.add('${city.fieldsCount} fields');
    }
    if (parts.isEmpty) return null;
    return parts.join(' • ');
  }
}
