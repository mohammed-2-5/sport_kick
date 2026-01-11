import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium splash screen view.
///
/// Features:
/// - Electric Modern theme (Dark Grey & Cyan)
/// - Animated logo
/// - Fade and scale entrance
/// - Glow effect
class PremiumSplashView extends StatefulWidget {
  final Widget
  child; // Kept for signature compatibility, but unused if we hardcode the logo asset
  final String appName;
  final String tagline;

  const PremiumSplashView({
    super.key,
    required this.child,
    required this.appName,
    required this.tagline,
  });

  @override
  State<PremiumSplashView> createState() => _PremiumSplashViewState();
}

class _PremiumSplashViewState extends State<PremiumSplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.electricBlack,
      body: Container(
        decoration: const BoxDecoration(
          // Subtle radial gradient for depth
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1E1E1E), // Slightly lighter center
              AppColors.electricBlack,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative glow orbs (Electric Cyan)
            _DecorativeGlowOrb(
              top: -100,
              left: -100,
              size: 300,
              animation: _glowAnimation,
            ),
            _DecorativeGlowOrb(
              bottom: -150,
              right: -100,
              size: 350,
              animation: _glowAnimation,
            ),
            // Content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Logo
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 160, // Slightly larger for the shield
                              height: 160,
                              decoration: BoxDecoration(
                                // No circle shape constraint strictly, but keep shadow soft
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.electricCyan.withValues(
                                      alpha: 0.2 * _glowAnimation.value,
                                    ),
                                    blurRadius: 50,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                      child: const SizedBox(), // Child not used
                    ),
                    const SizedBox(height: 32),
                    // App name
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        widget.appName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            BoxShadow(
                              color: AppColors.electricCyan,
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tagline
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        widget.tagline,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.7),
                          letterSpacing: 0.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    // Loading indicator
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.electricCyan,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Decorative glow orb for background.
class _DecorativeGlowOrb extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Animation<double> animation;

  const _DecorativeGlowOrb({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            opacity: 0.1 * animation.value, // Reduced opacity for subtle effect
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.electricCyan,
                    AppColors.electricCyan.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
