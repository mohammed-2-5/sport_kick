import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/app_locale_cubit.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Small language switcher button used on public/auth screens.
///
/// Shows a simple menu to toggle between English and Arabic without
/// navigating into Settings.
class LanguageSwitcherButton extends StatelessWidget {
  final bool dark;

  const LanguageSwitcherButton({super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isEnglish = localeCode == 'en';
    final iconColor = dark ? AppColors.textOnNavy : AppColors.textPrimary;

    return PopupMenuButton<String>(
      tooltip: context.l10n.language,
      icon: Icon(Icons.language, color: iconColor),
      onSelected: (code) => context.read<AppLocaleCubit>().setLocale(code),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en',
          child: _LanguageMenuItem(
            label: context.l10n.languageEnglish,
            selected: isEnglish,
          ),
        ),
        PopupMenuItem(
          value: 'ar',
          child: _LanguageMenuItem(
            label: context.l10n.languageArabic,
            selected: !isEnglish,
          ),
        ),
      ],
    );
  }
}

class _LanguageMenuItem extends StatelessWidget {
  final String label;
  final bool selected;

  const _LanguageMenuItem({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
          size: 18,
          color: selected ? AppColors.primary : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
