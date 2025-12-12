import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/field_card_shimmer.dart';

/// Fields list shimmer - shows multiple loading cards.
///
/// Displays a list of skeleton field cards for loading states.
class FieldsListShimmer extends StatelessWidget {
  final int itemCount;

  const FieldsListShimmer({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => const FieldCardShimmer(),
    );
  }
}
