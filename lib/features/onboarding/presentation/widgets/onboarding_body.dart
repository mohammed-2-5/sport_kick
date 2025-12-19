import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';
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
    final pages = _pagesData(context);
    if (_currentPage < pages.length - 1) {
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
    final pages = _pagesData(context);
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
                child: Text(context.l10n.skip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) => OnboardingContent(
                  title: pages[index]['title'] as String,
                  description: pages[index]['description'] as String,
                  icon: pages[index]['icon'] as IconData,
                  isActive: _currentPage == index,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  OnboardingIndicators(
                    count: pages.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 32),
                  PremiumButton(
                    label: _currentPage == pages.length - 1
                        ? context.l10n.getStarted
                        : context.l10n.next,
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

  List<Map<String, dynamic>> _pagesData(BuildContext context) {
    final l10n = context.l10n;
    return [
      {
        'title': l10n.onboardingTitle1,
        'description': l10n.onboardingDesc1,
        'icon': Icons.search_rounded,
      },
      {
        'title': l10n.onboardingTitle2,
        'description': l10n.onboardingDesc2,
        'icon': Icons.calendar_today_rounded,
      },
      {
        'title': l10n.onboardingTitle3,
        'description': l10n.onboardingDesc3,
        'icon': Icons.sports_soccer_rounded,
      },
    ];
  }
}
