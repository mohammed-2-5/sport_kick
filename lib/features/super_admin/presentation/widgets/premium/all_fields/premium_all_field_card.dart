import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/field_card_content_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/field_card_image_section.dart';

/// Premium field card with glassmorphism and animations.
///
/// Features:
/// - Hero image with gradient overlay
/// - Rating badge with stars
/// - Price chip with currency formatting
/// - Status indicator (active/inactive)
/// - City location badge
/// - Animated tap effects
/// - Shimmer loading for image
class PremiumAllFieldCard extends StatefulWidget {
  /// Field name.
  final String name;

  /// City name.
  final String cityName;

  /// Sport type.
  final String sportType;

  /// Image URL.
  final String? imageUrl;

  /// Price per hour.
  final double pricePerHour;

  /// Average rating (0-5).
  final double rating;

  /// Number of reviews.
  final int reviewCount;

  /// Whether the field is active.
  final bool isActive;

  /// Whether the field is verified.
  final bool isVerified;

  /// Callback when card is tapped.
  final VoidCallback? onTap;

  const PremiumAllFieldCard({
    super.key,
    required this.name,
    required this.cityName,
    required this.sportType,
    this.imageUrl,
    required this.pricePerHour,
    required this.rating,
    required this.reviewCount,
    required this.isActive,
    this.isVerified = false,
    this.onTap,
  });

  @override
  State<PremiumAllFieldCard> createState() => _PremiumAllFieldCardState();
}

class _PremiumAllFieldCardState extends State<PremiumAllFieldCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: context.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                FieldCardImageSection(
                  imageUrl: widget.imageUrl,
                  sportType: widget.sportType,
                  isActive: widget.isActive,
                  isVerified: widget.isVerified,
                  rating: widget.rating,
                  reviewCount: widget.reviewCount,
                ),

                // Content Section
                FieldCardContentSection(
                  name: widget.name,
                  cityName: widget.cityName,
                  pricePerHour: widget.pricePerHour,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
