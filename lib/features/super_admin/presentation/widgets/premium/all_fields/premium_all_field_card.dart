import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                _ImageSection(
                  imageUrl: widget.imageUrl,
                  sportType: widget.sportType,
                  isActive: widget.isActive,
                  isVerified: widget.isVerified,
                  rating: widget.rating,
                  reviewCount: widget.reviewCount,
                ),

                // Content Section
                _ContentSection(
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

/// Image section with overlays.
class _ImageSection extends StatelessWidget {
  final String? imageUrl;
  final String sportType;
  final bool isActive;
  final bool isVerified;
  final double rating;
  final int reviewCount;

  const _ImageSection({
    required this.imageUrl,
    required this.sportType,
    required this.isActive,
    required this.isVerified,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          if (imageUrl != null && imageUrl!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, _) => _ImagePlaceholder(),
              errorWidget: (_, _, _) => _ImagePlaceholder(),
            )
          else
            _ImagePlaceholder(),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),

          // Top badges
          Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: [
                // Sport type badge
                _SportBadge(sportType: sportType),
                if (isVerified) ...[const SizedBox(width: 8), _VerifiedBadge()],
              ],
            ),
          ),

          // Status badge
          Positioned(
            top: 12,
            right: 12,
            child: _StatusBadge(isActive: isActive),
          ),

          // Rating badge
          if (rating > 0)
            Positioned(
              bottom: 12,
              right: 12,
              child: _RatingBadge(rating: rating, reviewCount: reviewCount),
            ),
        ],
      ),
    );
  }
}

/// Image placeholder.
class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      child: const Center(
        child: Icon(
          Icons.sports_soccer_rounded,
          size: 40,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// Sport type badge.
class _SportBadge extends StatelessWidget {
  final String sportType;

  const _SportBadge({required this.sportType});

  IconData get _sportIcon {
    switch (sportType.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'volleyball':
        return Icons.sports_volleyball;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_sportIcon, size: 14, color: AppColors.navyDeep),
          const SizedBox(width: 4),
          Text(
            sportType,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.navyDeep,
            ),
          ),
        ],
      ),
    );
  }
}

/// Verified badge.
class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Color(0xFF10B981),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.verified_rounded, size: 12, color: Colors.white),
    );
  }
}

/// Status badge.
class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final label = isActive ? 'Active' : 'Inactive';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Rating badge.
class _RatingBadge extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const _RatingBadge({required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Content section with name, city, and price.
class _ContentSection extends StatelessWidget {
  final String name;
  final String cityName;
  final double pricePerHour;

  const _ContentSection({
    required this.name,
    required this.cityName,
    required this.pricePerHour,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Name and city
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        cityName,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.goldAccent, Color(0xFFD4A574)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '\$${pricePerHour.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '/hour',
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
