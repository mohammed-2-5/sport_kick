import 'package:flutter/material.dart';

/// Image placeholder for field card.
class FieldCardImagePlaceholder extends StatelessWidget {
  const FieldCardImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.sports_soccer_rounded,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
