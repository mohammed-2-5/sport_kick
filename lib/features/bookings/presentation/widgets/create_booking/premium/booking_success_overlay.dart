import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Animated success overlay displayed after booking confirmation.
///
/// Features:
/// - Animated checkmark with circle
/// - Confetti-like particles
/// - Booking details summary
/// - Navigation actions
class BookingSuccessOverlay extends StatefulWidget {
  final BookingEntity booking;
  final FieldEntity? field;
  final VoidCallback onViewBookings;
  final VoidCallback onViewInvoice;
  final VoidCallback onDone;

  const BookingSuccessOverlay({
    super.key,
    required this.booking,
    this.field,
    required this.onViewBookings,
    required this.onViewInvoice,
    required this.onDone,
  });

  @override
  State<BookingSuccessOverlay> createState() => _BookingSuccessOverlayState();
}

class _BookingSuccessOverlayState extends State<BookingSuccessOverlay>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _contentController;
  late AnimationController _particleController;

  late Animation<double> _checkScaleAnimation;
  late Animation<double> _checkOpacityAnimation;
  late Animation<double> _circleAnimation;
  late Animation<double> _contentSlideAnimation;
  late Animation<double> _contentOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    HapticFeedback.heavyImpact();
  }

  void _initAnimations() {
    // Check animation controller
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _checkScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_checkController);

    _checkOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _circleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _checkController, curve: Curves.easeOut));

    // Content animation controller
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _contentSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _checkController.forward();
    _particleController.repeat();

    await Future.delayed(const Duration(milliseconds: 500));
    _contentController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    _contentController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            // Confetti particles
            ...List.generate(
              20,
              (index) =>
                  _Particle(controller: _particleController, index: index),
            ),

            // Main content - scrollable to prevent overflow
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 64,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Success Icon
                          AnimatedBuilder(
                            animation: _checkController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _checkScaleAnimation.value,
                                child: Opacity(
                                  opacity: _checkOpacityAnimation.value,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.success,
                                          AppColors.success.withValues(
                                            alpha: 0.8,
                                          ),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.success.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 60 * _circleAnimation.value,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 32),

                          // Content
                          AnimatedBuilder(
                            animation: _contentController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _contentSlideAnimation.value),
                                child: Opacity(
                                  opacity: _contentOpacityAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                const Text(
                                  'Booking Confirmed!',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Your booking has been successfully placed.\nYou will receive a confirmation shortly.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Booking ID Card
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundLight,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.confirmation_number,
                                            color: AppColors.accentCyan,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Booking ID',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '#${widget.booking.id.substring(0, 8).toUpperCase()}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Actions
                          AnimatedBuilder(
                            animation: _contentController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _contentOpacityAnimation.value,
                                child: child,
                              );
                            },
                            child: Column(
                              children: [
                                // Primary: View Invoice (for payment)
                                if (widget.field != null) ...[
                                  PremiumButton(
                                    label: 'View Invoice & Pay',
                                    onPressed: widget.onViewInvoice,
                                    fullWidth: true,
                                    icon: Icons.receipt_long_rounded,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                PremiumButton(
                                  label: 'View My Bookings',
                                  onPressed: widget.onViewBookings,
                                  fullWidth: true,
                                  icon: Icons.list_alt,
                                  style: widget.field != null
                                      ? PremiumButtonStyle.outline
                                      : PremiumButtonStyle.primary,
                                ),
                                const SizedBox(height: 12),
                                PremiumButton(
                                  label: 'Done',
                                  onPressed: widget.onDone,
                                  fullWidth: true,
                                  style: PremiumButtonStyle.outline,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated particle for confetti effect.
class _Particle extends StatelessWidget {
  final AnimationController controller;
  final int index;

  const _Particle({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index);
    final startX = random.nextDouble() * MediaQuery.of(context).size.width;
    final size = 6.0 + random.nextDouble() * 6;
    final color = [
      AppColors.accentCyan,
      AppColors.success,
      AppColors.warning,
      AppColors.primary,
    ][index % 4];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = (controller.value + index / 20) % 1.0;
        final y = -50 + progress * (MediaQuery.of(context).size.height + 100);
        final x = startX + math.sin(progress * math.pi * 4) * 30;
        final opacity = progress < 0.8 ? 1.0 : (1.0 - progress) * 5;
        final rotation = progress * math.pi * 4;

        return Positioned(
          left: x,
          top: y,
          child: Transform.rotate(
            angle: rotation,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
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
