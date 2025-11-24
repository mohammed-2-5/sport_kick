import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/app_router.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';

/// Field details page - shows complete information about a field.
///
/// Displays:
/// - Image gallery
/// - Field name, rating, and price
/// - Full description
/// - Location and contact info
/// - Facilities
/// - Reviews (coming soon)
/// - Book now button
class FieldDetailsPage extends StatelessWidget {
  final String fieldId;

  const FieldDetailsPage({
    super.key,
    required this.fieldId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FieldsCubit>()..loadFieldDetails(fieldId),
      child: BlocBuilder<FieldsCubit, FieldsState>(
        builder: (context, state) {
          if (state is FieldsLoading) {
            return const Scaffold(
              body: LoadingIndicator.inline(
                message: 'Loading field details...',
              ),
            );
          }

          if (state is FieldsError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Field Details')),
              body: AppErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<FieldsCubit>().loadFieldDetails(fieldId);
                },
              ),
            );
          }

          if (state is FieldDetailsLoaded) {
            return Scaffold(
              body: _FieldDetailsContent(
                field: state.field,
                category: state.category,
              ),
              bottomNavigationBar: _BookNowButton(field: state.field),
            );
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Field Details')),
            body: const Center(
              child: Text('Field not found'),
            ),
          );
        },
      ),
    );
  }
}

class _FieldDetailsContent extends StatefulWidget {
  final FieldEntity field;
  final dynamic category;

  const _FieldDetailsContent({
    required this.field,
    this.category,
  });

  @override
  State<_FieldDetailsContent> createState() => _FieldDetailsContentState();
}

class _FieldDetailsContentState extends State<_FieldDetailsContent> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_fields') ?? [];
    setState(() {
      _isFavorite = favorites.contains(widget.field.id);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_fields') ?? [];

    if (_isFavorite) {
      favorites.remove(widget.field.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      favorites.add(widget.field.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    await prefs.setStringList('favorite_fields', favorites);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _shareField() async {
    final field = widget.field;
    final text = '''
Check out ${field.name}!

${field.description ?? 'A great sports field for booking'}

📍 ${field.address}, ${field.city}
💰 ${field.formattedPrice}
⭐ ${field.hasReviews ? '${field.ratingDisplay} (${field.totalReviews} reviews)' : 'No reviews yet'}

Book now on SpoKick!
''';

    await Share.share(
      text,
      subject: 'Check out ${field.name} on SpoKick',
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar with Image Gallery
        _buildAppBar(context),

        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Info Section
              _buildFieldInfoSection(),

              const Divider(height: 32),

              // Description Section
              _buildDescriptionSection(),

              const Divider(height: 32),

              // Location Section
              _buildLocationSection(),

              const Divider(height: 32),

              // Facilities Section
              _buildFacilitiesSection(),

              const Divider(height: 32),

              // Reviews Section (Placeholder)
              _buildReviewsSection(),

              const SizedBox(height: 100), // Space for bottom button
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final images = widget.field.images;
    final hasImages = images.isNotEmpty;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      actions: [
        // Share Button
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareField,
          tooltip: 'Share field',
        ),
        // Favorite Button
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: _toggleFavorite,
          tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: hasImages
            ? Stack(
                children: [
                  // Image Gallery with Hero Animation
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final imageWidget = Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                      );

                      // Wrap first image with Hero for transition from list
                      if (index == 0) {
                        return Hero(
                          tag: 'field_${widget.field.id}',
                          child: imageWidget,
                        );
                      }
                      return imageWidget;
                    },
                  ),

                  // Premium Gradient Overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: AppGradients.overlay,
                      ),
                    ),
                  ),

                  // Image Counter
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Badges
                  Positioned(
                    top: 60,
                    left: 16,
                    child: _buildBadges(),
                  ),
                ],
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No Images Available',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.field.isVerified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF81C784),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 18, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'Verified Field',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        if (widget.field.isPopular) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department_rounded, size: 18, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'TRENDING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFieldInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            widget.field.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Category
          if (widget.category != null)
            Text(
              widget.category.name,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

          const SizedBox(height: 12),

          // Rating and Reviews
          if (widget.field.hasReviews)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFA726),
                        Color(0xFFFFB74D),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        widget.field.ratingDisplay,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${widget.field.totalReviews})',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.info.withValues(alpha: 0.2),
                        AppColors.info.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bookmark_rounded, color: AppColors.info, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.field.totalBookings} bookings',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Price and Field Size
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppShadows.medium,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Price per hour',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.field.formattedPrice,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.info.withValues(alpha: 0.2),
                        AppColors.info.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline_rounded,
                            color: AppColors.info,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Capacity',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.info,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.field.fieldSize,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Surface Type and Indoor/Outdoor
          Row(
            children: [
              if (widget.field.surfaceType != null) ...[
                _buildInfoChip(
                  Icons.grass,
                  widget.field.surfaceType!,
                ),
                const SizedBox(width: 8),
              ],
              _buildInfoChip(
                widget.field.isIndoor ? Icons.home : Icons.wb_sunny,
                widget.field.isIndoor ? 'Indoor' : 'Outdoor',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    // Determine gradient based on label type
    LinearGradient chipGradient;
    if (label.toLowerCase().contains('grass') || label.toLowerCase().contains('natural')) {
      chipGradient = const LinearGradient(
        colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
      );
    } else if (label == 'Indoor') {
      chipGradient = const LinearGradient(
        colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
      );
    } else if (label == 'Outdoor') {
      chipGradient = const LinearGradient(
        colors: [Color(0xFFFFB74D), Color(0xFFFFD54F)],
      );
    } else {
      chipGradient = const LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: chipGradient,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: chipGradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    if (widget.field.description == null || widget.field.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.field.description!,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.field.address,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.field.city,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.field.hasLocation) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      widget.field.latitude!,
                      widget.field.longitude!,
                    ),
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.spo_kick',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            widget.field.latitude!,
                            widget.field.longitude!,
                          ),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: AppColors.error,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    if (!widget.field.hasFacilities) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Facilities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.field.facilities
                .map(
                  (facility) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryLight.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getFacilityIcon(facility),
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          facility,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  IconData _getFacilityIcon(String facility) {
    final lowerFacility = facility.toLowerCase();
    if (lowerFacility.contains('parking')) return Icons.local_parking;
    if (lowerFacility.contains('shower')) return Icons.shower;
    if (lowerFacility.contains('changing')) return Icons.checkroom;
    if (lowerFacility.contains('light') || lowerFacility.contains('flood')) {
      return Icons.lightbulb;
    }
    if (lowerFacility.contains('cafe') || lowerFacility.contains('food')) {
      return Icons.restaurant;
    }
    if (lowerFacility.contains('air') || lowerFacility.contains('ac')) {
      return Icons.ac_unit;
    }
    if (lowerFacility.contains('wifi')) return Icons.wifi;
    if (lowerFacility.contains('locker')) return Icons.lock;
    return Icons.check_circle;
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.field.hasReviews)
                TextButton(
                  onPressed: () {
                    // TODO: Show all reviews
                  },
                  child: const Text('See all'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Reviews feature coming soon!',
                    style: TextStyle(color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom Book Now Button
class _BookNowButton extends StatelessWidget {
  final FieldEntity field;

  const _BookNowButton({required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: 'Book Now',
          onPressed: () {
            // Navigate to create booking page
            Navigator.pushNamed(
              context,
              AppRouter.createBooking,
              arguments: field,
            );
          },
          icon: Icons.event_available,
        ),
      ),
    );
  }
}
