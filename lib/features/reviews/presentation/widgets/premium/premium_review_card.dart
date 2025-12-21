import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/premium/premium_star_rating_display.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium review card with enhanced styling.
///
/// Features:
/// - PremiumCard container
/// - Animated star rating display
/// - User avatar with gradient border
/// - Read more for long comments
/// - Recent badge with glow
/// - Edit/Delete actions
class PremiumReviewCard extends StatefulWidget {
  final ReviewEntity review;
  final bool showActions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PremiumReviewCard({
    super.key,
    required this.review,
    this.showActions = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<PremiumReviewCard> createState() => _PremiumReviewCardState();
}

class _PremiumReviewCardState extends State<PremiumReviewCard> {
  bool _isExpanded = false;
  static const int _maxLength = 150;

  bool get _needsExpansion =>
      widget.review.hasComment && widget.review.comment!.length > _maxLength;

  String get _displayComment {
    if (!widget.review.hasComment) return '';
    if (_isExpanded || !_needsExpansion) return widget.review.comment!;
    return '${widget.review.comment!.substring(0, _maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            Row(
              children: [
                // User avatar
                _UserAvatar(
                  avatarUrl: widget.review.userAvatar,
                  initials: widget.review.userInitials,
                  rating: widget.review.rating,
                ),
                const SizedBox(width: 12),

                // User name and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.review.userName ?? context.l10n.anonymous,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.review.wasEdited) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                context.l10n.editedLabel,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.review.formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Rating display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PremiumStarRatingDisplay(
                      rating: widget.review.ratingAsDouble,
                      size: 16,
                    ),
                    if (widget.showActions) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.onEdit != null)
                            _ActionButton(
                              icon: Icons.edit_outlined,
                              color: AppColors.accentCyan,
                              onTap: widget.onEdit!,
                            ),
                          if (widget.onDelete != null) ...[
                            const SizedBox(width: 8),
                            _ActionButton(
                              icon: Icons.delete_outline,
                              color: Colors.red,
                              onTap: widget.onDelete!,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Comment
            if (widget.review.hasComment) ...[
              const SizedBox(height: 16),
              AnimatedCrossFade(
                firstChild: Text(
                  _displayComment,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                ),
                secondChild: Text(
                  widget.review.comment!,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
              if (_needsExpansion) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Text(
                    _isExpanded ? context.l10n.showLess : context.l10n.readMore,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentCyan,
                    ),
                  ),
                ),
              ],
            ],

            // Recent badge
            if (widget.review.isRecent) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentCyan.withValues(alpha: 0.1),
                      AppColors.accentCyan.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.new_releases,
                      size: 14,
                      color: AppColors.accentCyan,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.recentReview,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// User avatar with gradient border based on rating.
class _UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String initials;
  final int rating;

  const _UserAvatar({
    required this.avatarUrl,
    required this.initials,
    required this.rating,
  });

  List<Color> get _borderGradient {
    if (rating >= 4) {
      return [Colors.green, Colors.teal];
    } else if (rating >= 3) {
      return [Colors.orange, Colors.amber];
    } else {
      return [Colors.red, Colors.deepOrange];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: _borderGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: avatarUrl != null
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: avatarUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      _InitialsAvatar(initials: initials),
                  errorWidget: (context, url, error) =>
                      _InitialsAvatar(initials: initials),
                ),
              )
            : _InitialsAvatar(initials: initials),
      ),
    );
  }
}

/// Initials avatar fallback.
class _InitialsAvatar extends StatelessWidget {
  final String initials;

  const _InitialsAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.accentCyan, AppColors.accentCyanDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Small action button for edit/delete.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
