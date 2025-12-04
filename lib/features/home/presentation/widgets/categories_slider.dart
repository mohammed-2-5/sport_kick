import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';

class CategoriesSlider extends StatefulWidget {
  const CategoriesSlider({super.key});

  @override
  State<CategoriesSlider> createState() => _CategoriesSliderState();
}

class _CategoriesSliderState extends State<CategoriesSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldsCubit, FieldsState>(
      builder: (context, state) {
        final bool hasRealData =
            state is FieldsLoaded && state.categories.isNotEmpty;

        print(
          '🎠 [CATEGORIES SLIDER] State: ${state.runtimeType}, hasRealData: $hasRealData',
        );
        if (state is FieldsLoaded) {
          print('   Categories count: ${state.categories.length}');
          for (var cat in state.categories) {
            print('   - ${cat.name} (ID: ${cat.id})');
          }
        }

        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: hasRealData
                  ? state.categories.length
                  : _getMockCategories().length,
              options: CarouselOptions(
                height: 200,
                viewportFraction: 0.7,
                enlargeCenterPage: true,
                enlargeFactor: 0.25,
                enableInfiniteScroll: hasRealData
                    ? state.categories.length > 2
                    : true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOutCubic,
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
              itemBuilder: (context, index, realIndex) {
                if (hasRealData) {
                  final category = state.categories[index];
                  return _buildCategoryCard(
                    context,
                    category.name,
                    _getCategoryImage(category.name),
                    category.id,
                  );
                } else {
                  final category = _getMockCategories()[index];
                  return _buildCategoryCard(
                    context,
                    category['name'] as String,
                    category['image'] as String,
                    null,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                hasRealData
                    ? state.categories.length
                    : _getMockCategories().length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentIndex == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    String imageUrl,
    String? categoryId,
  ) {
    return GestureDetector(
      onTap: () {
        if (categoryId != null) {
          print('🏷️ [CATEGORY TAP] Category: $name, ID: $categoryId');
          context.pushNamed('fieldsList', extra: {'categoryId': categoryId});
        } else {
          print('🏷️ [CATEGORY TAP] Mock category: $name (no ID)');
          context.pushNamed('fieldsList');
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to gradient if image fails to load
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _getGradientForCategory(name),
                      ),
                    ),
                  );
                },
              ),
              // Dark gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // Category Name
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMockCategories() {
    return [
      {
        'name': 'Football',
        'image':
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&q=80',
      },
      {
        'name': 'Tennis',
        'image':
            'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=800&q=80',
      },
      {
        'name': 'Basketball',
        'image':
            'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800&q=80',
      },
      {
        'name': 'Padel',
        'image':
            'https://images.unsplash.com/photo-1622163642998-1ea32b0bbc67?w=800&q=80',
      },
      {
        'name': 'Volleyball',
        'image':
            'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=800&q=80',
      },
    ];
  }

  String _getCategoryImage(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('football') || lowerName.contains('soccer')) {
      return 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&q=80';
    } else if (lowerName.contains('tennis')) {
      return 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=800&q=80';
    } else if (lowerName.contains('basketball')) {
      return 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800&q=80';
    } else if (lowerName.contains('padel')) {
      return 'https://images.unsplash.com/photo-1622163642998-1ea32b0bbc67?w=800&q=80';
    } else if (lowerName.contains('volleyball')) {
      return 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=800&q=80';
    }
    return 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&q=80';
  }

  List<Color> _getGradientForCategory(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('football') || lowerName.contains('soccer')) {
      return [const Color(0xFF00D9FF), const Color(0xFF0099CC)];
    } else if (lowerName.contains('tennis')) {
      return [const Color(0xFF7B61FF), const Color(0xFF5B41DF)];
    } else if (lowerName.contains('basketball')) {
      return [const Color(0xFFFF4B4B), const Color(0xFFCC3333)];
    } else if (lowerName.contains('padel')) {
      return [const Color(0xFFFFB800), const Color(0xFFFF8C00)];
    } else if (lowerName.contains('volleyball')) {
      return [const Color(0xFF00E676), const Color(0xFF00C853)];
    }
    return [AppColors.primary, AppColors.primaryDark];
  }
}
