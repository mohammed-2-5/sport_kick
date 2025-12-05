import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/home/presentation/widgets/city_dropdown_widget.dart';
import 'package:spo_kick/features/home/presentation/widgets/curved_header_clipper.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';

/// Custom header widget for fields list page.
///
/// Displays:
/// - Curved gradient background
/// - Back button
/// - City dropdown
/// - Favorites button
/// - Title
/// - Floating search bar slot
class FieldsListHeader extends StatelessWidget {
  /// Widget to display in the search bar slot
  final Widget searchBar;

  const FieldsListHeader({super.key, required this.searchBar});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Curved Background
        ClipPath(
          clipper: CurvedHeaderClipper(),
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  FieldConstants.headerGradientStart,
                  FieldConstants.headerGradientEnd,
                ],
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Top Row: Back, City, Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const CityDropdownWidget(),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context.pushNamed('favorites');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Browse Fields',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Space for search bar
              ],
            ),
          ),
        ),

        // Floating Search Bar
        Positioned(bottom: -25, left: 24, right: 24, child: searchBar),
      ],
    );
  }
}
