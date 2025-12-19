import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/home/presentation/widgets/hero/categories_slider.dart';
import 'package:spo_kick/features/home/presentation/widgets/hero/city_dropdown_widget.dart';
import 'package:spo_kick/features/home/presentation/widgets/hero/curved_header_clipper.dart';

import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';

class HeroSearchSection extends StatelessWidget {
  const HeroSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = (state is Authenticated) ? state.user : null;
        final userName = user?.fullName ?? context.l10n.homeGuest;
        final userInitials = user?.initials ?? context.l10n.homeGuest[0];

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Curved Background
            ClipPath(
              clipper: CurvedHeaderClipper(),
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: AppColors.navyGradient,
                ),
              ),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60), // Status bar + spacing
                // Header: Greeting & Avatar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getTimeBasedGreeting(context),
                              style: const TextStyle(
                                color: AppColors.textOnNavySecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textOnNavy,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const CityDropdownWidget(),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accentCyan,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.glassWhite,
                              child: Text(
                                userInitials,
                                style: const TextStyle(
                                  color: AppColors.textOnNavy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),

                // Categories Slider
                const CategoriesSlider(),
              ],
            ),
          ],
        );
      },
    );
  }

  String _getTimeBasedGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return context.l10n.homeGoodMorning;
    if (hour < 17) return context.l10n.homeGoodAfternoon;
    return context.l10n.homeGoodEvening;
  }
}
