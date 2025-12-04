import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/book_now_button.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_description_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_facilities_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_image_gallery.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_info_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_location_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_reviews_section.dart';

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

  const FieldDetailsPage({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FieldsCubit>()..loadFieldDetails(fieldId),
        ),
        BlocProvider(
          create: (context) => sl<FavoritesCubit>()..checkIsFavorite(fieldId),
        ),
      ],
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
              bottomNavigationBar: BookNowButton(field: state.field),
            );
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Field Details')),
            body: const Center(child: Text('Field not found')),
          );
        },
      ),
    );
  }
}

class _FieldDetailsContent extends StatelessWidget {
  final FieldEntity field;
  final dynamic category;

  const _FieldDetailsContent({required this.field, this.category});

  Future<void> _shareField(BuildContext context) async {
    final text = '''
Check out ${field.name}!

${field.description ?? 'A great sports field for booking'}

📍 ${field.address}, ${field.city}
💰 ${field.formattedPrice}
⭐ ${field.hasReviews ? '${field.ratingDisplay} (${field.totalReviews} reviews)' : 'No reviews yet'}

Book now on SpoKick!
''';

    // ignore: deprecated_member_use
    await share_plus.Share.share(
      text,
      subject: 'Check out ${field.name} on SpoKick',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listener: (context, state) {
        // Show snackbar when favorite is toggled
        if (state is FavoriteToggled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isFavorite
                    ? 'Added to favorites'
                    : 'Removed from favorites',
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // Show error message if operation fails
        if (state is FavoritesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: CustomScrollView(
        slivers: [
          // App Bar with Image Gallery
          _buildAppBar(context),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Field Info Section
                FieldInfoSection(field: field, category: category),

                const Divider(height: 32),

                // Description Section
                FieldDescriptionSection(field: field),

                const Divider(height: 32),

                // Location Section
                FieldLocationSection(field: field),

                const Divider(height: 32),

                // Facilities Section
                FieldFacilitiesSection(field: field),

                const Divider(height: 32),

                // Reviews Section (Placeholder)
                FieldReviewsSection(field: field),

                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: FieldConstants.imageGalleryHeight,
      pinned: true,
      actions: [
        // Share Button
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareField(context),
          tooltip: FieldConstants.shareLabel,
        ),
        // Favorite Button
        BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            // Determine if field is favorite based on current state
            final isFavorite = state is FavoriteStatusLoaded
                ? state.isFavorite
                : state is FavoriteToggled
                    ? state.isFavorite
                    : false;

            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                context.read<FavoritesCubit>().toggleFavorite(
                      field.id,
                      isFavorite,
                    );
              },
              tooltip: isFavorite
                  ? FieldConstants.removeFromFavoritesLabel
                  : FieldConstants.addToFavoritesLabel,
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: FieldImageGallery(
          images: field.images,
          fieldId: field.id,
          isVerified: field.isVerified,
          isPopular: field.isPopular,
        ),
      ),
    );
  }
}
