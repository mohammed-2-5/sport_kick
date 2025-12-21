import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium social login buttons.
///
/// Features:
/// - Google and Facebook buttons
/// - Loading state
/// - Scale animation on tap
/// - Responsive sizing
class PremiumSocialButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;

  const PremiumSocialButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "or"
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.l10n.orContinueWith,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Social buttons
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                icon: _GoogleIcon(),
                label: context.l10n.google,
                onPressed: onGooglePressed,
                isLoading: isLoading,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SocialButton(
                icon: const Icon(
                  Icons.facebook,
                  color: Color(0xFF1877F2),
                  size: 24,
                ),
                label: context.l10n.facebook,
                onPressed: onFacebookPressed,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual social button.
class _SocialButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _SocialButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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
      onTapUp: (_) {
        _controller.reverse();
        if (widget.onPressed != null && !widget.isLoading) {
          HapticFeedback.lightImpact();
          widget.onPressed!();
        }
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Google icon widget.
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

/// Google icon painter.
class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Blue
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -0.5,
      1.5,
      true,
      paint,
    );

    // Green
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      1.0,
      1.2,
      true,
      paint,
    );

    // Yellow
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      2.2,
      1.0,
      true,
      paint,
    );

    // Red
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      3.2,
      1.3,
      true,
      paint,
    );

    // White center
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 3.5,
      paint,
    );

    // G cutout
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2, size.height / 2 - 3, size.width / 2, 6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Alternative social buttons layout (vertical).
class PremiumSocialButtonsVertical extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onApplePressed;
  final bool isLoading;

  const PremiumSocialButtonsVertical({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onApplePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FullWidthSocialButton(
          icon: _GoogleIcon(),
          label: context.l10n.continueWithGoogle,
          onPressed: onGooglePressed,
          isLoading: isLoading,
        ),
        const SizedBox(height: 12),
        _FullWidthSocialButton(
          icon: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 24),
          label: context.l10n.continueWithFacebook,
          onPressed: onFacebookPressed,
          isLoading: isLoading,
        ),
        if (onApplePressed != null) ...[
          const SizedBox(height: 12),
          _FullWidthSocialButton(
            icon: const Icon(Icons.apple, color: Colors.black, size: 24),
            label: context.l10n.continueWithApple,
            onPressed: onApplePressed,
            isLoading: isLoading,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          ),
        ],
      ],
    );
  }
}

/// Full-width social button.
class _FullWidthSocialButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;

  const _FullWidthSocialButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor = Colors.white,
    this.textColor = AppColors.textPrimary,
  });

  @override
  State<_FullWidthSocialButton> createState() => _FullWidthSocialButtonState();
}

class _FullWidthSocialButtonState extends State<_FullWidthSocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
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
      onTapUp: (_) {
        _controller.reverse();
        if (widget.onPressed != null && !widget.isLoading) {
          HapticFeedback.lightImpact();
          widget.onPressed!();
        }
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
