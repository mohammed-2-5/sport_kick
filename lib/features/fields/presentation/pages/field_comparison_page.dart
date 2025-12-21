import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/comparison/comparison_empty_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/comparison/field_comparison_table.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Field comparison page - compare multiple fields side-by-side.
///
/// Allows users to compare up to 3 fields to make informed booking decisions.
class FieldComparisonPage extends StatelessWidget {
  final List<FieldEntity> fields;

  const FieldComparisonPage({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PremiumCurvedHeader(
            title: context.l10n.compareFields,
            subtitle: context.l10n.fieldsSelectedCount(fields.length),
            showBackButton: true,
            height: 160,
          ),
          Expanded(
            child: fields.isEmpty
                ? const ComparisonEmptyState()
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: FieldComparisonTable(fields: fields),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
