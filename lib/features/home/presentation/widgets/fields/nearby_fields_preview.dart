import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

class NearbyFieldsPreview extends StatelessWidget {
  const NearbyFieldsPreview({super.key});

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
                context.l10n.homeNearbyFieldsTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.lightTextPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  context.pushNamed('fieldsMap');
                },
                icon: const Icon(
                  Icons.map_outlined,
                  size: 18,
                  color: AppColors.lightAccent,
                ),
                label: Text(
                  context.l10n.homeViewMap,
                  style: const TextStyle(
                    color: AppColors.lightAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            context.pushNamed('fieldsMap');
          },
          child: Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Map Background with Grid Pattern
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFE8EAF6), Color(0xFFC5CAE9)],
                      ),
                    ),
                    child: CustomPaint(
                      painter: _MapGridPainter(),
                      size: Size.infinite,
                    ),
                  ),

                  // Decorative "Streets"
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  Positioned(
                    top: 140,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 100,
                    child: Container(
                      width: 2,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 80,
                    child: Container(
                      width: 2,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),

                  // Real Field Markers
                  BlocBuilder<FieldsCubit, FieldsState>(
                    builder: (context, state) {
                      if (state is FieldsLoaded) {
                        if (state.fields.isEmpty) {
                          return _buildEmptyState(context.l10n);
                        }
                        final fields = state.fields.take(3).toList();
                        return Stack(
                          children: [
                            if (fields.isNotEmpty)
                              _buildMapMarker(
                                top: 40,
                                left: 60,
                                label: fields[0].name,
                                isPrimary: true,
                              ),
                            if (fields.length > 1)
                              _buildMapMarker(
                                top: 100,
                                right: 70,
                                label: fields[1].name,
                              ),
                            if (fields.length > 2)
                              _buildMapMarker(
                                bottom: 60,
                                left: 130,
                                label: fields[2].name,
                              ),

                            // Bottom Info Bar
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: _buildInfoBar(
                                context,
                                state.fields.length,
                              ),
                            ),
                          ],
                        );
                      } else if (state is FieldsEmpty || state is FieldsError) {
                        return _buildEmptyState(context.l10n);
                      }

                      // Loading state
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.lightAccent,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.map_outlined,
            size: 48,
            color: AppColors.lightTextSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.homeNoFieldsNearby,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.fieldsCount(count),
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                ),
                Text(
                  context.l10n.homeTapToViewOnMap,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildMapMarker({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required String label,
    bool isPrimary = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Marker Pin
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.lightAccent : AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isPrimary ? AppColors.lightAccent : AppColors.primary)
                      .withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.sports_soccer,
              color: Colors.white,
              size: 18,
            ),
          ),
          // Pin Tail
          Container(
            width: 2,
            height: 8,
            color: isPrimary ? AppColors.lightAccent : AppColors.primary,
          ),
          const SizedBox(height: 4),
          // Label
          Container(
            constraints: const BoxConstraints(maxWidth: 100),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for map grid pattern
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
