import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_amenities_grid.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_description_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_field_floating_header.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_field_gallery_viewer.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_field_hero.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_field_info_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_location_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_reviews_preview.dart';

import '../../../../../../core/widgets/premium/glass_variants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium field details view with all enhanced components.
///
/// Features:
/// - Hero image with parallax
/// - Floating glassmorphism header on scroll
/// - Premium cards for all sections
/// - Image gallery viewer with zoom
/// - Floating book now button
class PremiumFieldDetailsView extends StatefulWidget {
  final FieldEntity field;
  final dynamic category;

  const PremiumFieldDetailsView({
    super.key,
    required this.field,
    this.category,
  });

  @override
  State<PremiumFieldDetailsView> createState() =>
      _PremiumFieldDetailsViewState();
}

class _PremiumFieldDetailsViewState extends State<PremiumFieldDetailsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    context.read<FieldDetailsScrollCubit>().updateScroll(
      _scrollController.offset,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Hero Image
              SliverToBoxAdapter(
                child: PremiumFieldHero(
                  images: widget.field.images,
                  fieldId: widget.field.id,
                  isVerified: widget.field.isVerified,
                  isPopular: widget.field.isPopular,
                  onImageTap: () => _showGalleryViewer(context),
                ),
              ),

              // Content Sections
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Info Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PremiumFieldInfoCard(
                        field: widget.field,
                        category: widget.category,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Description
                    if (widget.field.description != null &&
                        widget.field.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PremiumDescriptionCard(
                          description: widget.field.description!,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Amenities
                    if (widget.field.hasFacilities)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PremiumAmenitiesGrid(
                          facilities: widget.field.facilities,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Location
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PremiumLocationCard(field: widget.field),
                    ),

                    const SizedBox(height: 20),

                    // Reviews
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PremiumReviewsPreview(field: widget.field),
                    ),

                    // Bottom spacing for floating button
                    const SizedBox(height: 180),
                  ],
                ),
              ),
            ],
          ),

          // Floating Header (appears on scroll)
          BlocBuilder<FieldDetailsScrollCubit, FieldDetailsScrollState>(
            builder: (context, scrollState) {
              double opacity = 0.0;
              if (scrollState is FieldDetailsScrollActive) {
                opacity = scrollState.headerOpacity;
              }

              return BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, favState) {
                  final isFavorite = _isFavorite(favState);

                  return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: PremiumFieldFloatingHeader(
                      fieldName: widget.field.name,
                      rating: widget.field.averageRating ?? 0.0,
                      reviewCount: widget.field.totalReviews,
                      opacity: opacity,
                      onBackPressed: () => context.pop(),
                      onSharePressed: () => _shareField(),
                      onFavoritePressed: () {
                        context.read<FavoritesCubit>().toggleFavorite(
                          widget.field.id,
                          isFavorite,
                        );
                      },
                      isFavorite: isFavorite,
                    ),
                  );
                },
              );
            },
          ),

          // Back Button (visible when header is hidden)
          BlocBuilder<FieldDetailsScrollCubit, FieldDetailsScrollState>(
            builder: (context, scrollState) {
              double opacity = 1.0;
              if (scrollState is FieldDetailsScrollActive) {
                opacity = 1.0 - scrollState.headerOpacity;
              }

              return Positioned(
                top: 50,
                left: 16,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: opacity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
              );
            },
          ),

          // Floating Book Now Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BookNowFloatingButton(field: widget.field),
          ),
        ],
      ),
    );
  }

  bool _isFavorite(FavoritesState state) {
    if (state is FavoriteStatusLoaded) return state.isFavorite;
    if (state is FavoriteToggled) return state.isFavorite;
    return false;
  }

  void _showGalleryViewer(BuildContext context) {
    if (widget.field.images.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => PremiumFieldGalleryViewer(
          images: widget.field.images,
          initialIndex: 0,
        ),
      ),
    );
  }

  void _shareField() {
    final price =
        '${widget.field.pricePerHour.toStringAsFixed(0)} ${widget.field.currency}';
    final rating = widget.field.hasReviews
        ? '${widget.field.averageRating?.toStringAsFixed(1)} (${widget.field.totalReviews})'
        : context.l10n.noReviews;
    SharePlus.instance.share(
      ShareParams(
        text: context.l10n.shareFieldMessage(
          widget.field.name,
          widget.field.description ?? '',
          widget.field.address,
          widget.field.city,
          price,
          rating,
        ),
      ),
    );
  }
}

/// Floating Book Now button with glassmorphism and weekly subscription option.
class _BookNowFloatingButton extends StatelessWidget {
  final FieldEntity field;

  const _BookNowFloatingButton({required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.9),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Weekly subscription option
            GestureDetector(
              onTap: () => context.pushNamed('createRecurring', extra: field),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.goldAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.event_repeat_rounded,
                        size: 18,
                        color: AppColors.goldAccent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.reserveWeeklySlot,
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.navyDeep,
                            ),
                          ),
                          Text(
                            context.l10n.autoBookSameTimeEveryWeek,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.goldAccent,
                    ),
                  ],
                ),
              ),
            ),
            // Main book now button
            GlassFloatingButton(
              label: context.l10n.bookNow,
              icon: Icons.calendar_today,
              onPressed: () {
                context.pushNamed('createBooking', extra: field);
              },
              accentColor: AppColors.accentCyan,
            ),
          ],
        ),
      ),
    );
  }
}
