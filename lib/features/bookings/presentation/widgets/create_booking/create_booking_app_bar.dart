import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

class CreateBookingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CreateBookingAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primary),
      ),
      title: Text(
        context.l10n.bookFieldTitle,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    );
  }
}
