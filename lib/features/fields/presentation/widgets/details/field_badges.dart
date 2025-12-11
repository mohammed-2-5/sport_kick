import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/trending_badge.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/verified_badge.dart';

/// Column of field badges (verified and trending).
class FieldBadges extends StatelessWidget {
  final bool isVerified;
  final bool isPopular;

  const FieldBadges({
    super.key,
    required this.isVerified,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isVerified) const VerifiedBadge(),
        if (isPopular) ...[const SizedBox(height: 10), const TrendingBadge()],
      ],
    );
  }
}
