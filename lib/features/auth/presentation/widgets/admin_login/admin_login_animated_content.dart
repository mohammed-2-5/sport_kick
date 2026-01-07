import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_logo.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_form_container.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/back_to_user_login_link.dart';

/// Animated content for admin login with fade and slide transitions
class AdminLoginAnimatedContent extends StatefulWidget {
  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;

  const AdminLoginAnimatedContent({
    super.key,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
  });

  @override
  State<AdminLoginAnimatedContent> createState() =>
      _AdminLoginAnimatedContentState();
}

class _AdminLoginAnimatedContentState extends State<AdminLoginAnimatedContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _animationController.forward();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const AdminLoginLogo(),
            const SizedBox(height: 40),
            AdminLoginFormContainer(
              emailController: widget.emailController,
              passwordController: widget.passwordController,
              isLoading: widget.isLoading,
              onSubmit: widget.onSubmit,
            ),
            const SizedBox(height: 24),
            const BackToUserLoginLink(),
          ],
        ),
      ),
    );
  }
}
