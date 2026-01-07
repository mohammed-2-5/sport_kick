import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/success_particle.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

    return Container(
      color: colorScheme.surface,
      child: SafeArea(
        child: Stack(
          children: [
            // Confetti particles
            ...List.generate(
              20,
              (index) => SuccessParticle(
                controller: _particleController,
                index: index,
              ),
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
                                          successColor,
                                          successColor.withValues(alpha: 0.8),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: successColor.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: colorScheme.onPrimary,
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
                                Text(
                                  context.l10n.bookingConfirmedTitle,
                                  style: AppTextStyles.headlineMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  context.l10n.bookingConfirmedDescription,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Booking ID Card
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.confirmation_number,
                                            color: colorScheme.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            context.l10n.bookingId,
                                            style: AppTextStyles.labelMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '#${widget.booking.id.substring(0, 8).toUpperCase()}',
                                        style: AppTextStyles.titleLarge
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: colorScheme.onSurface,
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
                                    label: context.l10n.viewInvoiceAndPay,
                                    onPressed: widget.onViewInvoice,
                                    fullWidth: true,
                                    icon: Icons.receipt_long_rounded,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                PremiumButton(
                                  label: context.l10n.viewMyBookings,
                                  onPressed: widget.onViewBookings,
                                  fullWidth: true,
                                  icon: Icons.list_alt,
                                  style: widget.field != null
                                      ? PremiumButtonStyle.outline
                                      : PremiumButtonStyle.primary,
                                ),
                                const SizedBox(height: 12),
                                PremiumButton(
                                  label: context.l10n.done,
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
