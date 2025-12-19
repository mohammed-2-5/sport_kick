import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';

/// Share button for field details.
///
/// Opens native share dialog with field info.
class FieldShareButton extends StatelessWidget {
  final FieldEntity field;

  const FieldShareButton({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () => _shareField(context),
      tooltip: context.l10n.shareField,
    );
  }

  Future<void> _shareField(BuildContext context) async {
    final price = LocaleFormatters.formatPrice(
      context,
      amount: field.pricePerHour,
      currency: field.currency,
      decimalDigits: 0,
    );
    final rating = field.hasReviews
        ? '${LocaleFormatters.formatNumber(context, field.averageRating ?? 0, decimalDigits: 1)} (${LocaleFormatters.formatNumber(context, field.totalReviews)})'
        : context.l10n.noReviews;
    final text = context.l10n.shareFieldMessage(
      field.name,
      field.description ?? '',
      field.address,
      field.city,
      price,
      rating,
    );

    // ignore: deprecated_member_use
    await share_plus.Share.share(
      text,
      subject: context.l10n.shareFieldSubject(field.name),
    );
  }
}
