import 'package:flutter/material.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Verified badge for field card.
class FieldCardVerifiedBadge extends StatelessWidget {
  const FieldCardVerifiedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.success,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.verified_rounded, size: 12, color: Colors.white),
    );
  }
}
