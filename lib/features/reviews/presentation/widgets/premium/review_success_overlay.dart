import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';

/// Review success overlay with animations.
///
/// Features:
/// - Animated checkmark
/// - Confetti particles
/// - Success message
/// - Done button
class ReviewSuccessOverlay extends StatefulWidget {
  final bool isEdit;
  final VoidCallback onDone;

  const ReviewSuccessOverlay({
    super.key,
    this.isEdit = false,
    required this.onDone,
  });

  @override
  State<ReviewSuccessOverlay> createState() => _ReviewSuccessOverlayState();
}

class _ReviewSuccessOverlayState extends State<ReviewSuccessOverlay>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _checkAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _checkController.forward();
      _confettiController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.7),
      child: Stack(
        children: [
          // Confetti
          ...List.generate(
            20,
            (index) =>
                _ConfettiParticle(animation: _confettiController, index: index),
          ),

          // Content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated checkmark
                    AnimatedBuilder(
                      animation: _checkAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.green, Colors.teal],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.4),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            painter: _CheckmarkPainter(
                              progress: _checkAnimation.value,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Success message
                    Text(
                      widget.isEdit ? 'Review Updated!' : 'Review Submitted!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      widget.isEdit
                          ? 'Your review has been updated successfully'
                          : 'Thank you for sharing your experience',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Done button
                    SizedBox(
                      width: 200,
                      child: PremiumButton(
                        label: 'Done',
                        onPressed: widget.onDone,
                        icon: Icons.check,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Checkmark painter.
class _CheckmarkPainter extends CustomPainter {
  final double progress;

  _CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final startPoint = Offset(center.dx - 20, center.dy);
    final midPoint = Offset(center.dx - 5, center.dy + 15);
    final endPoint = Offset(center.dx + 25, center.dy - 15);

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);

    if (progress <= 0.5) {
      // First stroke
      final t = progress * 2;
      final currentX = startPoint.dx + (midPoint.dx - startPoint.dx) * t;
      final currentY = startPoint.dy + (midPoint.dy - startPoint.dy) * t;
      path.lineTo(currentX, currentY);
    } else {
      // First stroke complete
      path.lineTo(midPoint.dx, midPoint.dy);
      // Second stroke
      final t = (progress - 0.5) * 2;
      final currentX = midPoint.dx + (endPoint.dx - midPoint.dx) * t;
      final currentY = midPoint.dy + (endPoint.dy - midPoint.dy) * t;
      path.lineTo(currentX, currentY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Confetti particle.
class _ConfettiParticle extends StatelessWidget {
  final Animation<double> animation;
  final int index;

  const _ConfettiParticle({required this.animation, required this.index});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index);
    final startX = random.nextDouble() * MediaQuery.of(context).size.width;
    final color = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      AppColors.accentCyan,
    ][random.nextInt(7)];
    final size = 8.0 + random.nextDouble() * 8;
    final delay = random.nextDouble() * 0.3;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = ((animation.value - delay) / (1 - delay)).clamp(
          0.0,
          1.0,
        );
        final y = -50 + progress * (MediaQuery.of(context).size.height + 100);
        final x = startX + math.sin(progress * math.pi * 4 + index) * 50;
        final rotation = progress * math.pi * 4;
        final opacity = progress < 0.8 ? 1.0 : 1.0 - (progress - 0.8) / 0.2;

        return Positioned(
          left: x,
          top: y,
          child: Opacity(
            opacity: opacity,
            child: Transform.rotate(
              angle: rotation,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
