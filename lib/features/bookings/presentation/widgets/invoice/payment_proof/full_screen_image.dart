import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Full screen image viewer for payment proof.
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.scrim,
      appBar: AppBar(
        backgroundColor: colorScheme.scrim,
        iconTheme: IconThemeData(color: colorScheme.onInverseSurface),
        title: Text(
          context.l10n.paymentProof,
          style: AppTextStyles.titleLarge.copyWith(
            color: colorScheme.onInverseSurface,
          ),
        ),
      ),
      body: InteractiveViewer(
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              );
            },
          ),
        ),
      ),
    );
  }
}
