import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/premium/facility_chip.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/premium/field_image_section.dart';

/// Premium field list item with enhanced animations and styling.
class PremiumFieldListItem extends StatefulWidget {
  final FieldEntity field;

  const PremiumFieldListItem({super.key, required this.field});

  @override
  State<PremiumFieldListItem> createState() => _PremiumFieldListItemState();
}

class _PremiumFieldListItemState extends State<PremiumFieldListItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final priceText =
        '${LocaleFormatters.formatPrice(context, amount: widget.field.pricePerHour, currency: widget.field.currency, decimalDigits: 0)}/${context.l10n.perHour}';

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: PremiumCard(
        onTap: () => context.pushNamed('fieldDetails', extra: widget.field.id),
        padding: EdgeInsets.zero,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldImageSection(field: widget.field),
              _FieldContentSection(
                field: widget.field,
                priceText: priceText,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Content section with field details.
class _FieldContentSection extends StatelessWidget {
  final FieldEntity field;
  final String priceText;
  final ColorScheme colorScheme;

  const _FieldContentSection({
    required this.field,
    required this.priceText,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NameRow(field: field, colorScheme: colorScheme),
          const SizedBox(height: 8),
          _LocationRow(field: field, colorScheme: colorScheme),
          const SizedBox(height: 12),
          _RatingPriceRow(
            field: field,
            priceText: priceText,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          if (field.hasFacilities)
            _FacilitiesWrap(facilities: field.facilities),
        ],
      ),
    );
  }
}

class _NameRow extends StatelessWidget {
  final FieldEntity field;
  final ColorScheme colorScheme;

  const _NameRow({required this.field, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            field.name,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (field.isVerified) _VerifiedBadge(colorScheme: colorScheme),
      ],
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  final ColorScheme colorScheme;

  const _VerifiedBadge({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 14, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            context.l10n.verified,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final FieldEntity field;
  final ColorScheme colorScheme;

  const _LocationRow({required this.field, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '${field.city} - ${field.address}',
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RatingPriceRow extends StatelessWidget {
  final FieldEntity field;
  final String priceText;
  final ColorScheme colorScheme;

  const _RatingPriceRow({
    required this.field,
    required this.priceText,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        field.hasReviews
            ? _RatingBadge(rating: field.averageRating ?? 0)
            : _NewBadge(colorScheme: colorScheme),
        const Spacer(),
        _PriceBadge(priceText: priceText, colorScheme: colorScheme),
      ],
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            LocaleFormatters.formatNumber(context, rating, decimalDigits: 1),
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  final ColorScheme colorScheme;

  const _NewBadge({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        context.l10n.newLabel,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final String priceText;
  final ColorScheme colorScheme;

  const _PriceBadge({required this.priceText, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        priceText,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w900,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _FacilitiesWrap extends StatelessWidget {
  final List<String> facilities;

  const _FacilitiesWrap({required this.facilities});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: facilities
          .take(3)
          .map(
            (f) =>
                FacilityChip(facility: FacilityLocalizer.localize(context, f)),
          )
          .toList(),
    );
  }
}
