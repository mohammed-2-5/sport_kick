import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import 'onboarding_content.dart';
import 'onboarding_indicators.dart';

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({super.key});

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pagesData = [
    {
      'title': 'Find Perfect Fields',
      'description':
          'Discover top-rated sports fields near you with detailed information and reviews.',
      'icon': Icons.search_rounded,
    },
    {
      'title': 'Book Instantly',
      'description':
          'Easily check availability and book your favorite field in seconds.',
      'icon': Icons.calendar_today_rounded,
    },
    {
      'title': 'Play & Enjoy',
      'description': 'Compete with friends, join matches, and enjoy your game!',
      'icon': Icons.sports_soccer_rounded,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    context.read<OnboardingCubit>().pageChanged(index);
  }

  void _onNextPressed() {
    if (_currentPage < _pagesData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<OnboardingCubit>().completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.goNamed('login');
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () =>
                    context.read<OnboardingCubit>().completeOnboarding(),
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pagesData.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) => OnboardingContent(
                  title: _pagesData[index]['title'] as String,
                  description: _pagesData[index]['description'] as String,
                  icon: _pagesData[index]['icon'] as IconData,
                  isActive: _currentPage == index,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  OnboardingIndicators(
                    count: _pagesData.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 32),
                  PremiumButton(
                    label: _currentPage == _pagesData.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _onNextPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
