import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';

/// Premium card with built-in padding.
///
/// Convenience wrapper around [PremiumCard] with default 16px padding.
class PremiumCardWithPadding extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? accentColor;
  final bool showAccentBorder;

  const PremiumCardWithPadding({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor,
    this.showAccentBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      accentColor: accentColor,
      showAccentBorder: showAccentBorder,
      child: child,
    );
  }
}

/// Elevated premium card with stronger shadow.
///
/// Use for cards that need more prominence.
class ElevatedPremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const ElevatedPremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: padding,
      onTap: onTap,
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        const BoxShadow(
          color: AppColors.shadow,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      child: child,
    );
  }
}
