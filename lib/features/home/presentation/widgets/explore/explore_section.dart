import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';

class ExploreSection extends StatelessWidget {
  const ExploreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.homeExploreTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              TextButton(
                onPressed: () => context.pushNamed('fieldsList'),
                child: Text(
                  context.l10n.homeViewAll,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.lightAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<FieldsCubit, FieldsState>(
          builder: (context, state) {
            if (state is FieldsLoading) {
              return const SizedBox(
                height: 240,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.lightAccent,
                  ),
                ),
              );
            } else if (state is FieldsLoaded) {
              final fields = state.fields.take(5).toList();

              if (fields.isEmpty) {
                return _buildEmptyState(context);
              }

              return SizedBox(
                height: 240,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: fields.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final field = fields[index];
                    return _buildExploreCard(context, field: field);
                  },
                ),
              );
            } else if (state is FieldsEmpty) {
              return _buildEmptyState(context);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildExploreCard(
    BuildContext context, {
    required dynamic field, // Should be FieldEntity
  }) {
    final imageUrl = field.images.isNotEmpty ? field.images.first : null;
    final rating = field.averageRating ?? 0.0;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to field details
        context.pushNamed(
          'fieldDetails',
          pathParameters: {'fieldId': field.id},
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Stack(
                children: [
                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.lightAccent,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.sports_soccer,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.sports_soccer,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.lightSurface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: AppColors.lightTextPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.lightTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.ratingActive,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${field.totalReviews}+)',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${LocaleFormatters.formatPrice(context, amount: field.pricePerHour, currency: field.currency, decimalDigits: 0)} / ${context.l10n.perHour}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.lightAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 48,
              color: AppColors.lightTextSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.homeNoFieldsAvailable,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
