import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/comparison_empty_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_comparison_table.dart';

/// Field comparison page - compare multiple fields side-by-side.
///
/// Allows users to compare up to 3 fields to make informed booking decisions.
class FieldComparisonPage extends StatelessWidget {
  final List<FieldEntity> fields;

  const FieldComparisonPage({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Fields'), elevation: 0),
      body: fields.isEmpty
          ? const ComparisonEmptyState()
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: FieldComparisonTable(fields: fields),
              ),
            ),
    );
  }
}
