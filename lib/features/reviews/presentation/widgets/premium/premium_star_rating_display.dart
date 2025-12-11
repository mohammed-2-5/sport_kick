import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium animated star rating display.
///
/// Features:
/// - Filled/half/empty stars
/// - Gradient star color
/// - Animated entrance
/// - Size customization
class PremiumStarRatingDisplay extends StatefulWidget {
  final double rating;
  final double size;
  final bool showNumber;
  final bool animate;

  const PremiumStarRatingDisplay({
    super.key,
    required this.rating,
    this.size = 20,
    this.showNumber = false,
    this.animate = true,
  });

  @override
  State<PremiumStarRatingDisplay> createState() =>
      _PremiumStarRatingDisplayState();
}

class _PremiumStarRatingDisplayState extends State<PremiumStarRatingDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final delay = index * 0.1;
              final progress = ((_animation.value - delay) / (1 - delay)).clamp(
                0.0,
                1.0,
              );

              return Transform.scale(
                scale: 0.5 + (0.5 * progress),
                child: Opacity(opacity: progress, child: _buildStar(index)),
              );
            },
          );
        }),
        if (widget.showNumber) ...[
          const SizedBox(width: 8),
          Text(
            widget.rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: widget.size * 0.8,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStar(int index) {
    final difference = widget.rating - index;

    IconData icon;
    List<Color> colors;

    if (difference >= 1) {
      // Full star
      icon = Icons.star_rounded;
      colors = [Colors.orange, Colors.amber];
    } else if (difference >= 0.5) {
      // Half star
      icon = Icons.star_half_rounded;
      colors = [Colors.orange, Colors.amber];
    } else {
      // Empty star
      icon = Icons.star_outline_rounded;
      colors = [
        AppColors.textSecondary.withValues(alpha: 0.3),
        AppColors.textSecondary.withValues(alpha: 0.2),
      ];
    }

    return Padding(
      padding: EdgeInsets.only(right: index < 4 ? 2 : 0),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Icon(icon, size: widget.size, color: Colors.white),
      ),
    );
  }
}

/// Large premium rating display with breakdown.
class PremiumRatingOverview extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int>? ratingBreakdown;

  const PremiumRatingOverview({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    this.ratingBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navyDeep, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDeep.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Average rating
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                PremiumStarRatingDisplay(
                  rating: averageRating,
                  size: 24,
                  animate: true,
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalReviews ${totalReviews == 1 ? 'review' : 'reviews'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Rating breakdown
          if (ratingBreakdown != null) ...[
            Container(
              width: 1,
              height: 100,
              color: Colors.white.withValues(alpha: 0.2),
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: List.generate(5, (index) {
                  final star = 5 - index;
                  final count = ratingBreakdown![star] ?? 0;
                  final percentage = totalReviews > 0
                      ? count / totalReviews
                      : 0.0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Text(
                          '$star',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: _RatingBar(percentage: percentage)),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 30,
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Rating progress bar.
class _RatingBar extends StatelessWidget {
  final double percentage;

  const _RatingBar({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.amber, Colors.orange],
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
