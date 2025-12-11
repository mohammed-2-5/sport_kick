import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_top_field_card.dart';

/// Premium Top Fields List.
///
/// Features:
/// - Ranked field cards
/// - Revenue and booking stats
/// - Medal icons for top 3
class PremiumTopFieldsList extends StatelessWidget {
  /// List of top fields with their stats.
  final List<TopFieldData> fields;

  const PremiumTopFieldsList({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: List.generate(fields.length, (index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: PremiumTopFieldCard(
                  field: fields[index],
                  rank: index + 1,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
