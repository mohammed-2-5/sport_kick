import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';

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
      onPressed: () => _shareField(),
      tooltip: FieldConstants.shareLabel,
    );
  }

  Future<void> _shareField() async {
    final text =
        '''
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
}
