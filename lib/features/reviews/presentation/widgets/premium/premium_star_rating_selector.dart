import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Premium interactive star rating selector.
///
/// Features:
/// - Tap to select rating
/// - Scale animation on selection
/// - Glow effect on selected stars
/// - Rating label display
/// - Haptic feedback
class PremiumStarRatingSelector extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingChanged;
  final double size;
  final String? label;

  const PremiumStarRatingSelector({
    super.key,
    this.initialRating = 0,
    required this.onRatingChanged,
    this.size = 48,
    this.label,
  });

  @override
  State<PremiumStarRatingSelector> createState() =>
      _PremiumStarRatingSelectorState();
}

class _PremiumStarRatingSelectorState extends State<PremiumStarRatingSelector>
    with TickerProviderStateMixin {
  late int _currentRating;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  int? _hoveredStar;

  static const List<String> _ratingLabels = [
    '',
    'Poor',
    'Fair',
    'Good',
    'Very Good',
    'Excellent',
  ];

  static const List<Color> _ratingColors = [
    Colors.grey,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.lightGreen,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;

    _controllers = List.generate(
      5,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.3,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    }).toList();

    // Animate initial rating
    for (int i = 0; i < _currentRating; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          _controllers[i].forward().then((_) => _controllers[i].reverse());
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onStarTap(int index) {
    final newRating = index + 1;
    if (newRating == _currentRating) return;

    HapticFeedback.lightImpact();

    setState(() {
      _currentRating = newRating;
    });

    // Animate the selected star
    _controllers[index].forward().then((_) => _controllers[index].reverse());

    widget.onRatingChanged(newRating);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Stars row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _currentRating > 0
                  ? _ratingColors[_currentRating].withValues(alpha: 0.3)
                  : colorScheme.outline,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => _onStarTap(index),
                onTapDown: (_) => setState(() => _hoveredStar = index),
                onTapUp: (_) => setState(() => _hoveredStar = null),
                onTapCancel: () => setState(() => _hoveredStar = null),
                child: AnimatedBuilder(
                  animation: _scaleAnimations[index],
                  builder: (context, child) {
                    final isSelected = index < _currentRating;
                    final isHovered = _hoveredStar == index;

                    return Transform.scale(
                      scale: isHovered ? 1.1 : _scaleAnimations[index].value,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: isSelected
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              )
                            : null,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: isSelected
                                ? [Colors.orange, Colors.amber]
                                : [
                                    colorScheme.onSurfaceVariant.withValues(
                                      alpha: 0.3,
                                    ),
                                    colorScheme.onSurfaceVariant.withValues(
                                      alpha: 0.2,
                                    ),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Icon(
                            isSelected
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: widget.size,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),

        // Rating label
        if (_currentRating > 0) ...[
          const SizedBox(height: 12),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Container(
                key: ValueKey(_currentRating),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _ratingColors[_currentRating].withValues(alpha: 0.15),
                      _ratingColors[_currentRating].withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _ratingColors[_currentRating].withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getRatingIcon(),
                      size: 18,
                      color: _ratingColors[_currentRating],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _ratingLabels[_currentRating],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _ratingColors[_currentRating],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getRatingIcon() {
    switch (_currentRating) {
      case 1:
        return Icons.sentiment_very_dissatisfied;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 4:
        return Icons.sentiment_satisfied;
      case 5:
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.star_outline;
    }
  }
}
