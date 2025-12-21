import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium auth container with glassmorphism effect.
///
/// Features:
/// - Navy gradient background
/// - Glass form container
/// - Responsive sizing
/// - Safe area handling
/// - Animated logo
class PremiumAuthContainer extends StatelessWidget {
  final Widget child;
  final bool showLogo;
  final String? title;
  final String? subtitle;
  final Widget? header;
  final bool centerContent;

  const PremiumAuthContainer({
    super.key,
    required this.child,
    this.showLogo = true,
    this.title,
    this.subtitle,
    this.header,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final isTablet = size.shortestSide >= 600;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyDeep, AppColors.navyLight, Color(0xFF1E3A5F)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background decorations
          _BackgroundDecorations(),

          // Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = isTablet
                    ? (isLandscape ? 500.0 : 450.0)
                    : constraints.maxWidth;

                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 40 : 24,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        mainAxisAlignment: centerContent
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          if (header != null) header!,

                          if (showLogo) ...[
                            const _AnimatedLogo(),
                            const SizedBox(height: 24),
                          ],

                          if (title != null) ...[
                            Text(
                              title!,
                              style: AppTextStyles.displaySmall.copyWith(
                                fontSize: isTablet ? 32 : 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                subtitle!,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: isTablet ? 16 : 14,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 32),
                          ],

                          // Glass container
                          _GlassFormContainer(child: child),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Background decorative elements.
class _BackgroundDecorations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top right glow
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentCyan.withValues(alpha: 0.2),
                  AppColors.accentCyan.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        // Bottom left glow
        Positioned(
          bottom: -150,
          left: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentCyan.withValues(alpha: 0.15),
                  AppColors.accentCyan.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        // Center subtle pattern
        Positioned.fill(child: CustomPaint(painter: _PatternPainter())),
      ],
    );
  }
}

/// Subtle grid pattern painter.
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1;

    const spacing = 40.0;
    for (var i = 0.0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (var i = 0.0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Animated logo widget.
class _AnimatedLogo extends StatefulWidget {
  const _AnimatedLogo();

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentCyan.withValues(
                    alpha: _glowAnimation.value,
                  ),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.sports_soccer,
              size: 50,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

/// Glass form container with blur effect.
class _GlassFormContainer extends StatelessWidget {
  final Widget child;

  const _GlassFormContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Compact auth container for pages that don't need full glass effect.
class PremiumAuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;

  const PremiumAuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyDeep, AppColors.navyLight],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          if (onBack != null) const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
