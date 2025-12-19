import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Description section widget for field details.
///
/// Displays the field's description text if available.
class FieldDescriptionSection extends StatelessWidget {
  final FieldEntity field;

  const FieldDescriptionSection({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    if (field.description == null || field.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.about,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: FieldConstants.itemSpacing),
          Text(
            field.description!,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
