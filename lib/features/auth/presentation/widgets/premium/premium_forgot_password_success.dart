import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Success screen after password reset email sent.
class PremiumForgotPasswordSuccess extends StatefulWidget {
  final String email;
  final VoidCallback onBackToLogin;

  const PremiumForgotPasswordSuccess({
    super.key,
    required this.email,
    required this.onBackToLogin,
  });

  @override
  State<PremiumForgotPasswordSuccess> createState() =>
      _PremiumForgotPasswordSuccessState();
}

class _PremiumForgotPasswordSuccessState
    extends State<PremiumForgotPasswordSuccess>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0)),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SuccessIcon(scaleAnimation: _scaleAnimation),
            const SizedBox(height: 32),
            _SuccessTitle(opacityAnimation: _opacityAnimation),
            const SizedBox(height: 16),
            _SuccessMessage(opacityAnimation: _opacityAnimation),
            const SizedBox(height: 8),
            _EmailDisplay(
              email: widget.email,
              opacityAnimation: _opacityAnimation,
            ),
            const SizedBox(height: 24),
            _ExpiryInfo(opacityAnimation: _opacityAnimation),
            const SizedBox(height: 40),
            _BackToLoginButton(
              opacityAnimation: _opacityAnimation,
              onPressed: widget.onBackToLogin,
            ),
            const SizedBox(height: 20),
            _SpamFolderHint(opacityAnimation: _opacityAnimation),
          ],
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  final Animation<double> scaleAnimation;

  const _SuccessIcon({required this.scaleAnimation});

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(
          Icons.mark_email_read_outlined,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SuccessTitle extends StatelessWidget {
  final Animation<double> opacityAnimation;

  const _SuccessTitle({required this.opacityAnimation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: Text(
        context.l10n.resetEmailSentTitle,
        style: AppTextStyles.headlineMedium.copyWith(
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SuccessMessage extends StatelessWidget {
  final Animation<double> opacityAnimation;

  const _SuccessMessage({required this.opacityAnimation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: Text(
        context.l10n.resetEmailSentMessage,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white.withValues(alpha: 0.7),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _EmailDisplay extends StatelessWidget {
  final String email;
  final Animation<double> opacityAnimation;

  const _EmailDisplay({required this.email, required this.opacityAnimation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          email,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

class _ExpiryInfo extends StatelessWidget {
  final Animation<double> opacityAnimation;

  const _ExpiryInfo({required this.opacityAnimation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: Text(
        context.l10n.resetLinkExpires,
        style: AppTextStyles.bodySmall.copyWith(
          color: Colors.white.withValues(alpha: 0.6),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _BackToLoginButton extends StatelessWidget {
  final Animation<double> opacityAnimation;
  final VoidCallback onPressed;

  const _BackToLoginButton({
    required this.opacityAnimation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: SizedBox(
        width: 200,
        child: PremiumButton(
          label: context.l10n.backToLogin,
          onPressed: onPressed,
          icon: Icons.login,
        ),
      ),
    );
  }
}

class _SpamFolderHint extends StatelessWidget {
  final Animation<double> opacityAnimation;

  const _SpamFolderHint({required this.opacityAnimation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: Text(
        context.l10n.checkSpamFolder,
        style: AppTextStyles.bodySmall.copyWith(
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
