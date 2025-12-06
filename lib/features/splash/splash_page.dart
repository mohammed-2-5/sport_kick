import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_strings.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/splash/presentation/widgets/splash_logo.dart';

/// Splash screen displayed when app starts.
///
/// Shows app branding while checking authentication state
/// and performing initial setup.
///
/// Flow:
/// 1. Display logo and app name
/// 2. Check auth state
/// 3. Navigate to appropriate screen based on role:
///    - Admin/Super Admin → Owner Dashboard
///    - Regular User → City Selection (if no city) or Home (if city selected)
///    - Not authenticated → Login
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthAndNavigate();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Check authentication status using AuthCubit
    // This will update the cubit state so the entire app knows the user is logged in
    final authCubit = context.read<AuthCubit>();
    await authCubit.checkAuthStatus();

    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Navigate based on auth state and user role
    final authState = authCubit.state;
    if (authState is Authenticated) {
      // User is logged in - route based on role
      final userRole = authState.user.role;

      if (userRole == 'super_admin') {
        // Super admin goes to super admin dashboard
        context.goNamed('superAdminDashboard');
      } else if (userRole == 'admin') {
        // Field owner goes to owner dashboard
        context.goNamed('ownerDashboard');
      } else {
        // Regular users - check if city is selected
        await _checkCityAndNavigate();
      }
    } else {
      // Not authenticated - go to login
      context.goNamed('login');
    }
  }

  /// Check if user has selected a city and navigate accordingly
  Future<void> _checkCityAndNavigate() async {
    if (!mounted) return;

    debugPrint('🔍 [SPLASH] Checking selected city...');
    final cityCubit = context.read<CityCubit>();
    await cityCubit.loadSelectedCity();

    if (!mounted) return;

    final cityState = cityCubit.state;
    debugPrint('🔍 [SPLASH] City State: $cityState');

    // If no city selected, go to city selection page
    if (cityState is! CitySelected) {
      debugPrint('⚠️ [SPLASH] No city selected, navigating to selection page');
      context.goNamed('citySelection');
    } else {
      debugPrint(
        '✅ [SPLASH] City selected: ${cityState.city.name}, navigating to home',
      );
      // City selected, go to home
      context.goNamed('home');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // App Logo with Animation
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: const SplashLogo(),
                ),

                const SizedBox(height: 24),

                // App Name
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: child,
                    );
                  },
                  child: Text(
                    AppStrings.appName,
                    style: AppTextStyles.displaySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: child,
                    );
                  },
                  child: Text(
                    AppStrings.appTagline,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                // Loading Indicator
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: child,
                    );
                  },
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
