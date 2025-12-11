import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/onboarding/presentation/widgets/premium/premium_onboarding_page.dart';
import 'package:spo_kick/features/onboarding/presentation/widgets/premium/premium_page_indicator.dart';

/// Premium onboarding view with enhanced UI.
///
/// Features:
/// - Navy gradient background
/// - Animated page transitions
/// - Premium page indicators
/// - Skip button
/// - Get Started button on last page
class PremiumOnboardingView extends StatefulWidget {
  final List<OnboardingPageData> pages;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const PremiumOnboardingView({
    super.key,
    required this.pages,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  State<PremiumOnboardingView> createState() => _PremiumOnboardingViewState();
}

class _PremiumOnboardingViewState extends State<PremiumOnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onNextPressed() {
    if (_currentPage < widget.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navyDeep, AppColors.navyLight],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: widget.onSkip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: widget.pages.length,
                  itemBuilder: (context, index) {
                    return PremiumOnboardingPage(
                      data: widget.pages[index],
                      isActive: _currentPage == index,
                    );
                  },
                ),
              ),
              // Indicators
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: PremiumPageIndicator(
                  count: widget.pages.length,
                  currentIndex: _currentPage,
                ),
              ),
              // Next/Get Started button
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                child: PremiumButton(
                  label: _currentPage == widget.pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onPressed: _onNextPressed,
                  icon: _currentPage == widget.pages.length - 1
                      ? Icons.arrow_forward
                      : null,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Onboarding page data model.
class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
  });
}
